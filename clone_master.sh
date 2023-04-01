## Author Sagar Fale
## Issue 1 20-Mar-23 :  env files may contains special chars \r .. hence addding the command to remove it
## Issue 2 20-Mar-23 :  env files may contains special chars \M .. hence addding the command to remove it
export TARGET_INSTANCE_NAME=$1
find /home/applmgr/scripts_itc/EBS-Clone-Automation-v2 -name "*.env" -type f -exec sed -i 's/\r//g' {} +
find /home/applmgr/scripts_itc/EBS-Clone-Automation-v2 -name "*list" -type f -exec sed -i 's/\r//g' {} +
source "$(find "$(pwd)" -name "${TARGET_INSTANCE_NAME}-instance-details.env" -print)"
sh ${WORKFLOW}/${TARGET_INSTANCE_NAME}.workflow.sh



