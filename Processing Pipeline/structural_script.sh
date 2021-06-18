#!/bin/bash

#This script processes 7T Terra MP2RAGE data.
#The processing pipeline includes:
	#UNI and INV2 dicom to nifti conversion
	#structural brain masking
	#ANTS N4 bias field correction
	#FSL FAST (for tissue segmentation and gray matter probability maps)
	#UNI to MNI registration with ANTS SyN (rigid+affine+deformable syn)

#######################################################################################################
## DEFINE PATHS ##
structural=/project/bbl_projects/MotorGluCEST/structural
dicoms=/project/bbl_projects/MotorGluCEST/dicoms
base=/project/bbl_projects/MotorGluCEST/
log=/project/bbl_projects/MotorGluCEST/logs/structural
ANTSPATH=/appl/ANTs-2.3.1/bin
#######################################################################################################
## IDENTIFY CASES FOR PROCESSING ##

for i in $(ls $dicoms)
do
case=${i##*/}
echo "CASE: $case"

if ! [ -d $structural/$case ] && [ -d $dicoms/$case/*mp2rage_mark_ipat3_0.80mm_INV2 ] && [ -d $dicoms/$case/*mp2rage_mark_ipat3_0.80mm_UNI_Images ]

then
logfile=$log/${case}.log
{
echo "--------Processing structural data for $case---------"
sleep 1.5
mkdir $structural/$case
mkdir $structural/$case/fast
mkdir $structural/$case/MNI_transforms
mkdir $structural/$case/atlases
mkdir $structural/$case/log_files #store intermediate files
logfiles=$structural/$case/log_files
#######################################################################################################
## STRUCTURAL DICOM CONVERSION ##

#convert UNI
/project/bbl_projects/apps/melliott/scripts/dicom2nifti.sh -u -F $structural/$case/$case-UNI.nii $dicoms/$case/*mp2rage_mark_ipat3_0.80mm_UNI_Images/*dcm
gzip $structural/$case/$case-UNI.nii $structural/$case/$case-UNI.nii.gz

#convert INV2 for mask generatation
/project/bbl_projects/apps/melliott/scripts/dicom2nifti.sh -u -F $structural/$case/$case-INV2.nii $dicoms/$case/*mp2rage_mark_ipat3_0.80mm_INV2/*dcm
gzip $structural/$case/$case-INV2.nii $structural/$case/$case-INV2.nii.gz
#######################################################################################################
## STRUCTURAL BRAIN MASKING ##

#Create initial mask with BET using INV2
bet $structural/$case/$case-INV2.nii.gz $structural/$case/$case -m -f 0.2
mv -f $structural/$case/$case.nii.gz $logfiles/$case.nii.gz
#rm -f $structural/$case/$case.nii.gz

#generate final brain mask
fslmaths $structural/$case/$case-UNI.nii.gz -mul $structural/$case/${case}_mask.nii.gz $structural/$case/$case-UNI.nii.gz
mv -f $structural/$case/${case}_mask.nii.gz $logfiles/${case}_mask.nii.gz
#rm -f $structural/$case/${case}_mask.nii.gz
fslmaths $structural/$case/$case-UNI.nii.gz -bin $structural/$case/$case-mask.nii.gz
fslmaths $structural/$case/$case-mask.nii.gz -ero -kernel sphere 1 $structural/$case/$case-UNI-mask-er.nii.gz
mv -f $structural/$case/$case-mask.nii.gz $logfiles/$case-mask.nii.gz
#rm -f $structural/$case/$case-mask.nii.gz

#Apply finalized eroded mask to UNI image
fslmaths $structural/$case/$case-UNI.nii.gz -mas $structural/$case/$case-UNI-mask-er.nii.gz $structural/$case/$case-UNI-masked.nii.gz
fslmaths $structural/$case/$case-INV2.nii.gz -mas $structural/$case/$case-UNI-mask-er.nii.gz $structural/$case/$case-INV2-masked.nii.gz
#######################################################################################################
## BIAS FIELD CORRECTION ##

N4BiasFieldCorrection -d 3 -i $structural/$case/$case-UNI-masked.nii.gz -o $structural/$case/$case-UNI-processed.nii.gz
N4BiasFieldCorrection -d 3 -i $structural/$case/$case-INV2-masked.nii.gz -o $structural/$case/$case-INV2-processed.nii.gz
#######################################################################################################
## FAST TISSUE SEGMENTATION ##

fast -n 3 -t 1 -g -p -o $structural/$case/fast/$case $structural/$case/$case-INV2-processed.nii.gz
#######################################################################################################
## UNI TO MNI152 REGISTRATION ##

echo "----------Registering $case to MNI space----------"
#Register masked UNI to upsampled MNI T1 template
#MNI152 T1 1mm template was upsampled with:
antsRegistrationSyN.sh -d 3 -f $structural/MNI_Templates/MNI/MNI152_T1_0.8mm_brain.nii.gz -m $structural/$case/$case-UNI-processed.nii.gz -o $structural/$case/MNI_transforms/$case-UNIinMNI-
#######################################################################################################
#clean up
#rm $structural/$case/$case-UNI.nii.gz
#rm $structural/$case/$case-INV2.nii.gz
#rm $structural/$case/*log
mv -f $structural/$case/$case-UNI.nii.gz $logfiles/$case-UNI.nii.gz
mv -f $structural/$case/$case-INV2.nii.gz $logfiles/$case-INV2.nii.gz
mv -f $structural/$case/*log $log

echo -e "\n$case SUCCESFULLY PROCESSED\n\n\n"
} | tee "$logfile"
else
echo "$case is either missing structural dicoms or already processed. Will not process"
sleep 1.5
fi

done
