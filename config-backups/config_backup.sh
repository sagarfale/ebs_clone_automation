## Author Sagar Fale
## this script takes the config backups

##########################################################################
today=`date +%Y%m%d`.`date +%H%M%S`; export today
echo "BKP_DIR=${REFRESH_DIR}/${TARGET_INSTANCE_NAME}/refresh_files_"$today""
#BKP_DIR=${REFRESH_DIR}/${TARGET_INSTANCE_NAME}/refresh_files_"$today"
HOST_NAME=`hostname`
LOW_HOSTNAME=`echo ${HOST_NAME} | tr [A-Z] [a-z]`; export LOW_HOSTNAME
echo $LOW_HOSTNAME




:<<COMMENT
today=`date +%Y%m%d`.`date +%H%M%S`; export today
BKP_DIR=$HOME/refresh_files_"$today"

HOST_NAME=`hostname`
LOW_HOSTNAME=`echo ${HOST_NAME} | tr [A-Z] [a-z]`; export LOW_HOSTNAME
echo $LOW_HOSTNAME

#
# Set Environment
##########################################################################
. /ua2001/appsr12/apps/EBSapps.env
#
# Create Backup Directories
##########################################################################
mkdir -p ${BKP_DIR}/appl
mkdir -p ${BKP_DIR}/10.1.2
mkdir -p ${BKP_DIR}/10.1.3
mkdir -p ${BKP_DIR}/inst

#
# Backing up Application Tier Files
##########################################################################
echo "Starting : Backing up Application Tier Files : $today ..."
echo "APPL_TOP is set to : $APPL_TOP ..."
cp $APPL_TOP/*.env ${BKP_DIR}/appl/.
cp $INST_TOP/appl/admin/*.env ${BKP_DIR}/inst/.
cp $INST_TOP/appl/admin/*.xml ${BKP_DIR}/inst/.
cp $INST_TOP/ora/10.1.2/*.env ${BKP_DIR}/10.1.2/.
cp $INST_TOP/ora/10.1.2/network/admin/*.ora ${BKP_DIR}/10.1.2/.
cp $INST_TOP/ora/10.1.3/*.env ${BKP_DIR}/10.1.3/.
cp $INST_TOP/ora/10.1.3/network/admin/*.ora ${BKP_DIR}/10.1.3/.
#cp $INST_TOP/admin/scripts/default_key.ini ${BKP_DIR}/inst/.

echo ""
echo "####################################################################"
echo ""
echo "Finished : Backing up Application Tier Files : $today ..."
echo ""
echo "####################################################################"
echo ""
echo ""
COMMENT