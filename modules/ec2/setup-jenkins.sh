#!/bin/bash
#######################################################################
# The script mounts the created EBS volume and change file ownership
# to jenkins:jenkins
JENKINS_HOME=/mnt/jenkins_master/jenkins_home
systemctl enable docker.service
systemctl start docker.service
if [ ! -d /mnt/jenkins_master ]; then
  mkdir -p /mnt/jenkins_master
fi
mount /dev/xvdf /mnt/jenkins_master
cp -f /etc/fstab /etc/fstab.bak
echo "UUID=`blkid -o value -s UUID /dev/xvdf` /mnt/jenkins_master   ext4    defaults,nofail        0       2" >> /etc/fstab

cp /tmp/quiet-start.groovy $JENKINS_HOME/init.groovy.d/quiet-start.groovy
chmod 755 $JENKINS_HOME/init.groovy.d/quiet-start.groovy
# The chown takes a looonnnnnng time to execute. It'll have to be done
# manually inside the instance so the Terraform plan doesn't ran forever.
#chown -R jenkins:jenkins /mnt/jenkins_master
