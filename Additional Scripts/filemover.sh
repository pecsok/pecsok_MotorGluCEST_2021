# pecsok_MotorGluCEST_2021

#This GitHub contains files relevant for the GluCEST Motor Project.

#Scripts include:
#Structural Script

#######################################################################################################
## DEFINE PATHS ##
structural=/project/bbl_projects/MotorGluCEST/structural/
cest=/project/bbl_projects/MotorGluCEST/glucest #path to processed GluCEST data
dicoms=/project/bbl_projects/MotorGluCEST/dicoms #path to GUI Dicoms
structural_old=/project/bbl_data/syrp/sydnor_glucest/GluCEST_BASReward_Project/Structural
cest_old=/project/bbl_data/syrp/sydnor_glucest/GluCEST_BASReward_Project/GluCEST
dicoms_old=/project/bbl_projects/MotorGluCEST/sandbox/dicoms
   #/project/bbl_data/syrp/sydnor_glucest/GluCEST_BASReward_Project/Dicoms path to Val's folder
#######################################################################################################
## IDENTIFY CASES FOR PROCESSING ##
for i in 20580_11279 20707_11292
do
case=${i##*/}
echo "CASE: $case"

cp -r $dicoms_old/$case $dicoms


done

#121407_10688 125073_10972 132179_10760 132641_10692 19783_PERC04 19790_10819 19798_PERC03 19830_10789 19970_10827 19971_PERC09 19974_PERC11 19981_11106 20011_10888 20180_11011 80537_10989 80557_10738 81725_11109 83835_10706 87225_10933 87804_10951 88608_10764 88760_10673 89095_11100 90077_10962 90281_10902 90877_10907 91393_11133 91919_10683 91962_11090 92155_11022 92211_10981 93274_10765 93292_10938 93734_10694 96659_11096
