#!/bin/bash
	
#This script creates the motor network coverage heatmap used to identify network voxels wherein greater than 50% of participants had GluCEST data.
#MotorNetwork-Heatmap-50%.nii.gz was used for the coverage sensitivity analysis.
	

#######################################################################################################
## DEFINE PATHS #
	

structural=/project/bbl_projects/MotorGluCEST/sandbox/structural/
#path to processed structural data
cest=/structural=/project/bbl_projects/MotorGluCEST/sandbox/GluCEST #path to processed GluCEST data
motor_dir=/project/bbl_projects/MotorGluCEST/sandbox/structural/MNI_Templates/Motor_Atlas/2D_MotorNetworks_inMNI
#######################################################################################################
## TRANSFORM 5mm MOTOR NETWORK SLICES BACK TO MNI SPACE ##
	

while read line
do
case=$line
antsApplyTransforms -d 3 -i $cest/$case/atlases/$case-2d-MotorAtlas-TotalNetwork.nii.gz -r $structural/MNI_Templates/MNI/MNI152_T1_0.8mm_brain.nii.gz -n NearestNeighbor -o $structural/MNI_Templates/Motor_Atlas/2D_MotorNetworks_inMNI/$case-2d-MotorAtlas-inMNI.nii.gz -t $structural/$case/MNI_transforms/$case-UNIinMNI-1Warp.nii.gz -t $structural/$case/MNI_transforms/$case-UNIinMNI-0GenericAffine.mat
done < /project/bbl_projects/MotorGluCEST/sandbox/structural/GluCEST_BASReward_Caselist_N45.txt
#######################################################################################################
## CREATE MOTOR NETWORK HEATMAP ## 
	

firstcase=$(ls ${motor_dir} | head -1) 
othercases=$(ls ${motor_dir} | tail -n+2)
	

for casefile in ${othercases}; do
	echo -n "-add " >> ${motor_dir}/fslmaths_inputs.txt
	echo -n "$motor_dir/${casefile} " >> ${motor_dir}/fslmaths_inputs.txt
done
	

fslmaths $motor_dir/$firstcase $(cat ${motor_dir}/fslmaths_inputs.txt) $motor_dir/MotorNetwork-Heatmap.nii.gz
rm ${motor_dir}/fslmaths_inputs.txt
#######################################################################################################
## CREATE 50% OVERLAP MOTOR ATLAS ##
	

#threshold heatmap at >50% of participants
fslmaths $motor_dir/MotorNetwork-Heatmap.nii.gz -thr 23 $motor_dir/MotorNetwork-Heatmap-50%.nii.gz
fslmaths $motor_dir/MotorNetwork-Heatmap-50%.nii.gz -bin $motor_dir/MotorNetwork-Heatmap-50%.nii.gz
	

#transform MotorNetwork-Heatmap-50%.nii.gz to GluCEST space
while read line
do
case=$line
antsApplyTransforms -d 3 -r $structural/$case/$case-UNI-masked.nii.gz -i $motor_dir/MotorNetwork-Heatmap-50%.nii.gz -n NearestNeighbor -o $structural/$case/atlases/${case}-MotorAtlas-50%Heatmap.nii.gz -t [$structural/$case/MNI_transforms/$case-UNIinMNI-0GenericAffine.mat,1] -t $structural/$case/MNI_transforms/$case-UNIinMNI-1InverseWarp.nii.gz
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $structural/$case/atlases/${case}-MotorAtlas-50%Heatmap.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest/$case/atlases/$case-2d-MotorAtlas-50%Heatmap.nii 
gzip $cest/$case/atlases/$case-2d-MotorAtlas-50%Heatmap.nii
done < /data/jux/BBL/projects/sydnor_glucest/GluCEST_BASReward_Project/GluCEST_BASReward_Caselist_N45.txt

