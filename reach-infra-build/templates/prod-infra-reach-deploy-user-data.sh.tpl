#!/bin/bash
echo "###############################################################################################"
echo "# STARTING EXECUTION USING ROOT                                                               #"
echo "###############################################################################################"
echo "# SETTING UP THE LOG FILE                                                                     #"
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2> /dev/console) 2>&1
echo "###############################################################################################"
echo "# WAITING THE INSTANCE TO BE READY                                                            #"
echo "Waiting time started at: " && date
while ! ping -c 1 -W 1 google.ca; do
  echo "Waiting for connectivity..."
done
sleep 1
echo "Waiting time finished at: " && date
echo "###############################################################################################"
echo "# DEFINING VARIABLES                                                                          #"
CUSTOMER="reach" && echo "customer=$CUSTOMER"
ENVIRONMENT="prod" && echo "environment=$ENVIRONMENT"
APPLICATION_NAME="reach" && echo "application_name=$APPLICATION_NAME"
AWS_REGION="ca-central-1" && echo "region=$AWS_REGION"
echo "###############################################################################################"
echo "# UPDATING THE INSTANCE                                                                       #"
yum update -y
echo "###############################################################################################"
echo "# Set prompt config                                                                           #"
cat > /etc/profile.d/custom_prompt.sh <<- "EOF"
#!/bin/sh
export PROMPT_COMMAND='export PS1="\u@\H \W:\$ "'
EOF
echo "###############################################################################################"
echo "# Install bash-completion                                                                     #"
yum install bash-completion bash-completion-extras -y
echo "###############################################################################################"
echo "# INSTALL JQ                                                                                  #"
yum install jq -y
echo "###############################################################################################"
echo "# INSTALL ZIP and UNZIP                                                                       #"
yum install zip unzip -y
echo "###############################################################################################"
echo "# INSTALL AWSCLI                                                                              #"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
echo "###############################################################################################"
echo "# Reading instance tag name                                                                   #"
INSTANCE_ID="`curl http://169.254.169.254/latest/meta-data/instance-id`"
TAGNAME="`aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" --region $AWS_REGION --output=text | cut -f5`"
echo "###############################################################################################"
echo "# Set hostname                                                                                #"
echo $TAGNAME
sudo echo "$TAGNAME" > /etc/hostname
cat /etc/hostname
echo "###############################################################################################"
echo "# SET EST TIMEZONE                                                                            #"
timedatectl set-timezone America/Toronto
timedatectl
echo "###############################################################################################"
echo "# DEFINE AWS REGION                                                                           #"
aws configure set region $AWS_REGION
echo "###############################################################################################"
echo "# INSTALL JUMPCLOUD"
echo "*********** Instaling Jumpcloud Agent ***********"
sudo curl --tlsv1.2 --silent --show-error --header 'x-connect-key: 8f571c489dd16b8e8484fd94f23792bddb6f6460' https://kickstart.jumpcloud.com/Kickstart | sudo bash
sudo systemctl start jcagent.service
sudo systemctl enable jcagent.service
sudo systemctl is-enabled jcagent.service
echo "###############################################################################################"
echo "# INSTALL MYSQL CLIENT                                                                        #"
yum install mysql -y
mysql -V
echo "###############################################################################################"
echo "# INSTALL BUILDKITE                                                                           #"
sudo sh -c 'echo -e "[buildkite-agent]\nname = Buildkite Pty Ltd\nbaseurl = https://yum.buildkite.com/buildkite-agent/stable/x86_64/\nenabled=1\ngpgcheck=0\npriority=1" > /etc/yum.repos.d/buildkite-agent.repo'
sudo yum -y install buildkite-agent
echo "###############################################################################################"
echo "# CONFIGURING BUILDKITE                                                                       #"
BUILDKITETOKEN=$(aws ssm get-parameters --region ca-central-1 --names buildkite-agent-token --query 'Parameters[*].[Value]' --output text)
sed -i "s/xxx/$BUILDKITETOKEN/g" /etc/buildkite-agent/buildkite-agent.cfg
sed -Ei 's/^# tags="key1=val2,key2=val2"/tags="type='"$TAGNAME"'"/' /etc/buildkite-agent/buildkite-agent.cfg
sed -Ei 's/^name="%hostname-%spawn"/name="'"$TAGNAME"'"/' /etc/buildkite-agent/buildkite-agent.cfg
systemctl enable buildkite-agent && sudo systemctl start buildkite-agent
cat /etc/buildkite-agent/buildkite-agent.cfg
systemctl status buildkite-agent
echo "###############################################################################################"
echo "# SETTING UP BUILDKITE_AGENT USER                                                             #"
usermod --shell /bin/bash buildkite-agent
sudo usermod -aG docker buildkite-agent
sudo systemctl restart buildkite-agent
echo "###############################################################################################"
echo "# LAST SERVER UPDATE                                                                          #"
yum update -y
echo "###############################################################################################"
echo "# FINISH SCRIPT EXECUTION AND UPLODAD LOG TO S3                                               #"
aws s3 cp /var/log/user-data.log "s3://ep-prod-infrastructure-s3/deployment_logs/$CUSTOMER/$ENVIRONMENT/$TAGNAME/user-data-$(date +%F).log" --region ca-central-1 && sleep 5
echo "Script finish at: " && date
reboot
