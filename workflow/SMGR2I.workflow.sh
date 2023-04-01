## Author Sagar Fale
## this script control the entire execution of the cloning process
clear
echo "TARGET_INSTANCE_NAME is $TARGET_INSTANCE_NAME"
## checking the task files

FILES=("${COMMON}/common_functions.sh" "${WORKFLOW}/${TARGET_INSTANCE_NAME}-cloning-task-list" "${WORKFLOW}/${TARGET_INSTANCE_NAME}-cloning-task-list")
for file in "${FILES[@]}"; do if [ ! -f "$file" ]; then ls -l  $file; echo "File $file does not exist"; exit 1; fi; done


## Sourcing the functions and creating log directory

.  ${COMMON}/common_functions.sh
[ -d "${REFRESH_DIR}/log/${TARGET_INSTANCE_NAME}" ] || mkdir -p "${REFRESH_DIR}/log/${TARGET_INSTANCE_NAME}"

## sourcing status functions
#while IFS= read -r f_task_name || [[ -n "$f_task_name" ]]; do [[ $f_task_name != \#* ]] && ls -l $${COMMON}/$f_task_name; source "${COMMON}/$f_task_name"; done < "${WORKFLOW}/status_functions"

### Sourcing 
while IFS= read -r f_task_name || [ -n "$f_task_name" ]; do
  # Remove trailing whitespace from $f_task_name
  f_task_name=$(echo "$f_task_name" | sed -e 's/[[:space:]]*$//')
  
  if [[ $f_task_name != \#* ]] && [ -e "${COMMON}/$f_task_name" ]; then
    if source "${COMMON}/$f_task_name"; then
      echo "Sourced file: ${COMMON}/$f_task_name"
      F_ECHO "Sourced file: ${COMMON}/$f_task_name"
    else
      F_ECHO "Unable to source file: ${COMMON}/$f_task_name"
    fi
  fi
done < "${WORKFLOW}/status_functions"


while IFS= read -r f_task_name || [[ -n "$f_task_name" ]]; do
  # Remove trailing whitespace from $f_task_name
  f_task_name=$(echo "$f_task_name" | sed -e 's/[[:space:]]*$//')
  
  if [[ $f_task_name != \#* ]] && [ -e "${COMMON}/F_$f_task_name" ]; then
    if source "${COMMON}/F_$f_task_name"; then
      F_ECHO "Sourced file: ${COMMON}/F_$f_task_name"
    else
      F_ECHO "Unable to source file: ${COMMON}/F_$f_task_name"
    fi
  fi
done < "${WORKFLOW}/${TARGET_INSTANCE_NAME}-cloning-task-list"


echo "**************************"
F_CREATION_OF_LOGDIR
F_CLONE_STATUS_TABLE

#F_CLONE_STATUS_TABLE
#F_CHECKING_CLONING_STATUS_TABULAR

## sourcing custom functions


#F_CHECKING_CLONING_STATUS_TABULAR


#F_CHECKS_WEBLOGIC_CONN_STATUS $EBS_RELEASE
:<<'COMMENT'


F_CHECKS_SYSTEM_CONN_STATUS
#F_CHECKS_APPS_CONN_STATUS
#EBS_RELEASE=$(F_EBS_RELEASE_VERSION)
#F_CREATION_OF_LOGDIR
F_CLONE_STATUS_TABLE
#F_DB_TNSPING_STATUS
#F_CHECKING_CLONING_STATUS_TABULAR

for i in `cat ${WORKFLOW}/${TARGET_INSTANCE_NAME}-cloning-task-list`
do
	#echo "SELECT REFRESH_TASK_NAME FROM CLONE_PROCESSING_STATUS WHERE REFRESH_TASK_NAME='${i}' and CURRENT_STATUS='INITIATED' and FINAL_STATUS NOT in ('SUCCESS','SKIPPED') ;"
	#echo "i is $i"
	output=`DB_CONN_SYSTEM <<EOF
	       set feedback off pause off pagesize 0 verify off linesize 500 term off
	       col REFRESH_TASK_NAME for a50
	       col FINAL_STATUS for a10
           set pages 80
           set head off
           set line 120
           set echo off
	SELECT REFRESH_TASK_NAME FROM CLONE_PROCESSING_STATUS WHERE REFRESH_TASK_NAME='${i}'  and FINAL_STATUS NOT in ('SUCCESS','SKIPPED') ;
EOF
`
	output=`echo $output|  tr -d '[:space:]'`
	#echo ">>> output is $output"
	if [ "$output" = "${i}" ]; then
		echo "************************* Restarting Cloning stage $i..."
		#sleep 10
		F_${i}
	fi
	#echo "SELECT REFRESH_TASK_NAME FROM CLONE_PROCESSING_STATUS WHERE REFRESH_TASK_NAME='${i}' and CURRENT_STATUS is NULL and FINAL_STATUS is NULL ;"
		output1=`DB_CONN_SYSTEM <<EOF
	       set feedback off pause off pagesize 0 verify off linesize 500 term off
	       col REFRESH_TASK_NAME for a50
	       col FINAL_STATUS for a10
           set pages 80
           set head off
           set line 120
           set echo off
	SELECT REFRESH_TASK_NAME FROM CLONE_PROCESSING_STATUS WHERE REFRESH_TASK_NAME='${i}' and FINAL_STATUS is NULL ;
EOF
`
	output1=`echo $output1|  tr -d '[:space:]'`
	#echo ">>> output1 is $output1"
	if [ "$output1" = "${i}" ]; then
		echo "************************* Starting Cloning stage $i..."
		#echo "F_${i}"
		F_${output1}
	fi
done

F_CHECKING_CLONING_STATUS
F_CHECKING_CLONING_STATUS_TABULAR
COMMENT