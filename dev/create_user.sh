#!/bin/bash -x

user_var=$1
pub_key=$2
msg=`echo  "{\n    user    = "$user_var"\n    pub_key = ["$pub_key"]\n  },"`
number=`grep -wn sftp_users_with_keys terraform.tfvars | cut -d: -f1`
number1=$(($number+1))
echo $number1
echo "$number"
echo "$msg"
sed -i "$number1"i" $msg" terraform.tfvars