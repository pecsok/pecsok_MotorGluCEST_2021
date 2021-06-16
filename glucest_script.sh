#!/bin/bash

#This script post-processes GluCEST data output by the Matlab software cest2d_TERRA_SYRP. This script requires that:
#1. The MP2RAGE processing script MP2RAGE_Processing_Pipeline.sh has been run
#2. The CEST data has been processed via the Matlab GUI cest2d_TERRA_SYRP and output in dicom format

#The processing pipeline includes:
#dcm to nifti conversion for Matlab generated B0 maps, B1 maps, and B0B1-corrected GluCEST dicoms
#B0 and B1 map thresholding of GluCEST images
#CSF removal from GluCEST images
#GluCEST brain masking
#registration of atlases from MNI space to participant UNI images
#registration of FAST segmentation and reward atlas slices to GluCEST images
#generation of reward network anatomical and valence-encoding subcomponent masks
#######################################################################################################
## DEFINE PATHS ##
structural=/project/bbl_projects/MotorGluCEST/structural
cest=/project/bbl_projects/MotorGluCEST/glucest #path to processed GluCEST data
dicoms=/project/bbl_projects/MotorGluCEST/dicoms #path to GUI Dicoms
#######################################################################################################
## IDENTIFY CASES FOR PROCESSING ##
for i in $(ls $dicoms)
do
case=${i##*/}
echo "CASE: $case"
#check for structural data
if [ -e $structural/$case/$case-UNI-processed.nii.gz ] && [ -e $structural/$case/fast/${case}_seg.nii.gz ]
then
echo "Structural Data exists for $case"
sleep 1.5
else
echo "Oh No! Structural Data is missing. Cannot process CEST! Run MP2RAGE_Processing_Pipeline.sh first."
sleep 1.5
fi
#check for GluCEST GUI data
if [ -d $dicoms/$case/*WASSR_B0MAP2D ] && [ -d $dicoms/$case/*B1MAP2D ] && [ -d $dicoms/$case/*B0B1CESTMAP2D ]
then
echo "CEST GUI Data exists for $case"
sleep 1.5
else
echo "Oh No! CEST GUI Data is missing. Cannot process CEST! Analyze this case with CEST_2d_TERRA first."
sleep 1.5
fi
if ! [ -d $cest/$case ] && [ -d $dicoms/$case/*WASSR_B0MAP2D ] && [ -d $dicoms/$case/*B1MAP2D ] && [ -d $dicoms/$case/*B0B1CESTMAP2D ] && [ -e $structural/$case/fast/${case}_seg.nii.gz ]
then
logfile=/project/bbl_projects/MotorGluCEST/logs/cest/${case}.log
(
echo "--------Processing GluCEST data for $case---------"
sleep 1.5
#######################################################################################################
## CONVERT B0, B1, and B0B1-CORRECTED CEST FROM DCM TO NII ##
mkdir $cest/$case
log_files=$cest/$case/log_files #path to intermediate files. Remove for final script
mkdir $log_files

for seq in B0MAP B1MAP B0B1CESTMAP
do
/project/bbl_projects/apps/melliott/scripts/dicom2nifti.sh -u -r Y -F $cest/$case/$case-$seq.nii $dicoms/$case/S*${seq}2D/*dcm
done
#######################################################################################################
## THRESHOLD B0 AND B1 MAPS ##
#threshold b0 from -1 to 1 ppm (relative to water resonance)
fslmaths $cest/$case/$case-B0MAP.nii -add 10 $cest/$case/$case-B0MAP-pos.nii.gz # make B0 map values positive to allow for thresholding with fslmaths
fslmaths $cest/$case/$case-B0MAP-pos.nii.gz -thr 9 -uthr 11 $cest/$case/$case-B0MAP-thresh.nii.gz #threshold from -1(+10=9) to 1(+10=11)
fslmaths $cest/$case/$case-B0MAP-thresh.nii.gz -bin $cest/$case/$case-b0.nii.gz #binarize thresholded B0 map
#threshold b1 from 0.3 to 1.3
fslmaths $cest/$case/$case-B1MAP.nii -thr 0.3 -uthr 1.3 $cest/$case/$case-B1MAP-thresh.nii.gz #threshold from 0.3 to 1.3
fslmaths $cest/$case/$case-B1MAP-thresh.nii.gz -bin $cest/$case/$case-b1.nii.gz #binarize thresholded B1 map
#######################################################################################################
## ALIGN FSL FAST OUTPUT TO GLUCEST IMAGES ##
mkdir $cest/$case/fast
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $structural/$case/fast/${case}_seg.nii.gz $cest/$case/$case-B0B1CESTMAP.nii $cest/$case/fast/$case-2d-FAST.nii
gzip $cest/$case/fast/$case-2d-FAST.nii
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh $structural/$case/fast/${case}_prob_1.nii.gz $cest/$case/$case-B0B1CESTMAP.nii $cest/$case/fast/$case-2d-FASTGMprob.nii
gzip $cest/$case/fast/$case-2d-FASTGMprob.nii
#######################################################################################################
## APPLY THRESHOLDED B0 MAP, B1 MAP, and TISSUE MAP (CSF removed) TO GLUCEST IMAGES ##
#exclude voxels with B0 offset greater than +- 1 pmm from GluCEST images
fslmaths $cest/$case/$case-B0B1CESTMAP.nii -mul $cest/$case/$case-b0.nii.gz $cest/$case/$case-CEST_b0thresh.nii.gz
#exclude voxels with B1 values outside the range of 0.3 to 1.3 from GluCEST images
fslmaths $cest/$case/$case-CEST_b0thresh.nii.gz -mul $cest/$case/$case-b1.nii.gz $cest/$case/$case-CEST_b0b1thresh.nii.gz
#exclude CSF voxels from GluCEST images
fslmaths $cest/$case/fast/$case-2d-FAST.nii.gz -thr 2 $cest/$case/fast/$case-tissuemap.nii.gz
fslmaths $cest/$case/fast/$case-tissuemap.nii.gz -bin $cest/$case/fast/$case-tissuemap-bin.nii.gz
fslmaths $cest/$case/$case-CEST_b0b1thresh.nii.gz -mul $cest/$case/fast/$case-tissuemap-bin.nii.gz $cest/$case/$case-CEST-finalthresh.nii.gz
#######################################################################################################
## MASK THE PROCESSED GLUCEST IMAGE ##
fslmaths $cest/$case/$case-B1MAP.nii -bin $cest/$case/CEST-masktmp.nii.gz
fslmaths $cest/$case/CEST-masktmp.nii.gz -ero -kernel sphere 1 $cest/$case/CEST-masktmp-er1.nii.gz
fslmaths $cest/$case/CEST-masktmp-er1.nii.gz -ero -kernel sphere 1 $cest/$case/CEST-masktmp-er2.nii.gz
fslmaths $cest/$case/CEST-masktmp-er2.nii.gz -ero -kernel sphere 1 $cest/$case/$case-CEST-mask.nii.gz
fslmaths $cest/$case/$case-CEST-finalthresh.nii.gz -mul $cest/$case/$case-CEST-mask.nii.gz $cest/$case/$case-GluCEST.nii.gz #final processed GluCEST Image
#######################################################################################################
#clean up and organize, whistle while you work
mv -f $cest/$case/*masktmp* $log_files/
#rm -f $cest/$case/*masktmp*
#mv -f $cest/$case/*log* $log_files/
#rm -f $cest/$case/*log*
mv -f $cest/$case/$case-B0MAP-pos.nii.gz $log_files/
#rm -f $cest/$case/$case-B0MAP-pos.nii.gz
mv -f $cest/$case/$case-B0MAP-thresh.nii.gz $log_files/
#rm -f $cest/$case/$case-B0MAP-thresh.nii.gz
mv -f $cest/$case/$case-B1MAP-thresh.nii.gz $log_files/
#rm -f $cest/$case/$case-B1MAP-thresh.nii.gz

mkdir $cest/$case/orig_data
mv $cest/$case/$case-B0MAP.nii $cest/$case/$case-B1MAP.nii $cest/$case/$case-B0B1CESTMAP.nii $cest/$case/orig_data
#######################################################################################################
## REGISTER ATLASES TO UNI IMAGES AND GLUCEST IMAGES ##
mkdir $cest/$case/atlases
#Harvard Oxford Atlases
#for atlas in cort #sub
#do
antsApplyTransforms -d 3 -r $structural/$case/$case-UNI-masked.nii.gz -i $structural/MNI_Templates/HarvardOxford/HarvardOxford-cort-maxprob-thr25-0.8mm.nii.gz -n MultiLabel -o $structural/$case/atlases/${case}-HarvardOxford-cort.nii.gz  -t [$structural/$case/MNI_transforms/$case-UNIinMNI-0GenericAffine.mat,1] -t $structural/$case/MNI_transforms/$case-UNIinMNI-1InverseWarp.nii.gz
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $structural/$case/atlases/${case}-HarvardOxford-cort.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest/$case/atlases/${case}-2d-HarvardOxford-cort.nii
gzip $cest/$case/atlases/${case}-2d-HarvardOxford-cort.nii
fslmaths $cest/$case/atlases/$case-2d-HarvardOxford-cort.nii.gz -mul $cest/$case/fast/$case-tissuemap-bin.nii.gz $cest/$case/atlases/$case-2d-HarvardOxford-cort.nii.gz
#done

#Motor Network ]
antsApplyTransforms -d 3 -r $structural/$case/$case-UNI-masked.nii.gz -i $structural/MNI_Templates/Motor_Atlas/ho_motormask-bin-0.8mm.nii.gz -n NearestNeighbor -o $structural/$case/atlases/${case}-MotorAtlas-TotalNetwork.nii.gz -t [$structural/$case/MNI_transforms/$case-UNIinMNI-0GenericAffine.mat,1] -t $structural/$case/MNI_transforms/$case-UNIinMNI-1InverseWarp.nii.gz
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $structural/$case/atlases/${case}-MotorAtlas-TotalNetwork.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii
gzip $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii
fslmaths $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii.gz -mul $cest/$case/fast/$case-tissuemap-bin.nii.gz $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii.gz
cp -f $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii.gz $structural/MNI_Templates/Motor_Atlas/

#Motor Network ROIs: M1 (Figure XX) (For now, just using -cort atlas.)
# Isolate ROI; binarize; extract data
#M1
fslmaths $cest/$case/atlases/$case-2d-HarvardOxford-cort.nii.gz -thr 7 -uthr 7 $cest/$case/atlases/$case-2d-M1Mask.nii.gz #extract cortical HO labels
fslmaths $cest/$case/atlases/$case-2d-M1Mask.nii.gz -bin $cest/$case/atlases/$case-2d-M1Mask.nii.gz
fslmaths $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii.gz -mul $cest/$case/atlases/$case-2d-M1Mask.nii.gz $cest/$case/atlases/$case-2d-ho-MotorAtlas-M1.nii.gz
#SMA
fslmaths $cest/$case/atlases/$case-2d-HarvardOxford-cort.nii.gz -thr 26 -uthr 26 $cest/$case/atlases/$case-2d-SMAMask.nii.gz #extract cortical HO labels
fslmaths $cest/$case/atlases/$case-2d-SMAMask.nii.gz -bin $cest/$case/atlases/$case-2d-SMAMask.nii.gz
fslmaths $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii.gz -mul $cest/$case/atlases/$case-2d-SMAMask.nii.gz $cest/$case/atlases/$case-2d-ho-MotorAtlas-SMA.nii.gz

#Visual Network (Figure XX)
antsApplyTransforms -d 3 -r $structural/$case/$case-UNI-masked.nii.gz -i $structural/MNI_Templates/Visual_Atlas/ho_vismask-0.8mm.nii.gz -n NearestNeighbor -o $structural/$case/atlases/${case}-ho-VisualAtlas-TotalNetwork.nii.gz -t [$structural/$case/MNI_transforms/$case-UNIinMNI-0GenericAffine.mat,1] -t $structural/$case/MNI_transforms/$case-UNIinMNI-1InverseWarp.nii.gz
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $structural/$case/atlases/${case}-ho-VisualAtlas-TotalNetwork.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest/$case/atlases/$case-2d-ho-VisualAtlas-TotalNetwork.nii
gzip $cest/$case/atlases/$case-2d-ho-VisualAtlas-TotalNetwork.nii
fslmaths $cest/$case/atlases/$case-2d-ho-VisualAtlas-TotalNetwork.nii.gz -mul $cest/$case/fast/$case-tissuemap-bin.nii.gz $cest/$case/atlases/$case-2d-ho-VisualAtlas-TotalNetwork.nii.gz
cp -f $cest/$case/atlases/$case-2d-ho-VisualAtlas-TotalNetwork.nii.gz $structural/MNI_Templates/Visual_Atlas/

#Non-Motor Brain Regions (Figure XX)
fslmaths $cest/$case/atlases/$case-2d-HarvardOxford-cort.nii.gz -bin $cest/$case/atlases/$case-2d-HarvardOxford-cort-bin.nii.gz
fslmaths $cest/$case/atlases/$case-2d-HarvardOxford-cort-bin.nii.gz -sub $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii.gz $cest/$case/atlases/$case-2d-ho-NonMotor.nii.gz
fslmaths $cest/$case/atlases/$case-2d-ho-NonMotor.nii.gz -thr 0 $cest/$case/atlases/$case-2d-ho-NonMotor.nii.gz
mv -f $cest/$case/atlases/$case-2d-HarvardOxford-cort-bin.nii.gz $log_files
#rm $cest/$case/atlases/$case-2d-HarvardOxford-$atlas-bin.nii.gz

##Schaefer100 Atlas
echo "Schaefer100 Atlas"
antsApplyTransforms -d 3 -r $structural/$case/$case-UNI-masked.nii.gz -i $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_17Networks_order_FSLMNI152_0.8mm.nii.gz -n MultiLabel -o  $structural/$case/atlases/${case}-Schaefer100.nii.gz -t [$structural/$case/MNI_transforms/$case-UNIinMNI-0GenericAffine.mat,1] -t $structural/$case/MNI_transforms/$case-UNIinMNI-1InverseWarp.nii.gz
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $structural/$case/atlases/${case}-Schaefer100.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest/$case/atlases/${case}-2d-Schaefer100.nii
gzip $cest/$case/atlases/${case}-2d-Schaefer100.nii
fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -mul $cest/$case/fast/$case-tissuemap-bin.nii.gz $cest/$case/atlases/$case-2d-Schaefer100.nii.gz
#flirt -in $cest/$case/slices/${case}-Schaefer100-slice.nii.gz -ref $cest/$case/orig_data/$case-B0B1CESTMAP.nii -out $cest/$case/atlases/${case}-2d-Schaefer100.nii.gz -init $cest/$case/$case-UNI2CEST-matrix.mat -applyxfm -interp nearestneighbour -2D

#Motor Network (Figure XX)
antsApplyTransforms -d 3 -r $structural/$case/$case-UNI-masked.nii.gz -i $structural/MNI_Templates/Motor_Atlas/s100_motormask-0.8mm.nii.gz -n NearestNeighbor -o $structural/$case/atlases/${case}-s100-MotorAtlas-TotalNetwork.nii.gz -t [$structural/$case/MNI_transforms/$case-UNIinMNI-0GenericAffine.mat,1] -t $structural/$case/MNI_transforms/$case-UNIinMNI-1InverseWarp.nii.gz
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $structural/$case/atlases/${case}-s100-MotorAtlas-TotalNetwork.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii
gzip $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii
fslmaths $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -mul $cest/$case/fast/$case-tissuemap-bin.nii.gz $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz
cp -f $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz $structural/MNI_Templates/Motor_Atlas/


#Visual Network (Figure XX)
antsApplyTransforms -d 3 -r $structural/$case/$case-UNI-masked.nii.gz -i $structural/MNI_Templates/Visual_Atlas/s100_visualmask-0.8mm.nii.gz -n NearestNeighbor -o $structural/$case/atlases/${case}-s100-VisualAtlas-TotalNetwork.nii.gz -t [$structural/$case/MNI_transforms/$case-UNIinMNI-0GenericAffine.mat,1] -t $structural/$case/MNI_transforms/$case-UNIinMNI-1InverseWarp.nii.gz
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $structural/$case/atlases/${case}-s100-VisualAtlas-TotalNetwork.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest/$case/atlases/$case-2d-s100-VisualAtlas-TotalNetwork.nii
gzip $cest/$case/atlases/$case-2d-s100-VisualAtlas-TotalNetwork.nii
fslmaths $cest/$case/atlases/$case-2d-s100-VisualAtlas-TotalNetwork.nii.gz -mul $cest/$case/fast/$case-tissuemap-bin.nii.gz $cest/$case/atlases/$case-2d-s100-VisualAtlas-TotalNetwork.nii.gz
cp -f $cest/$case/atlases/$case-2d-s100-VisualAtlas-TotalNetwork.nii.gz $structural/MNI_Templates/Visual_Atlas/

#Non-Motor Brain Regions (Figure XX)
fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -bin $cest/$case/atlases/$case-2d-Schaefer100-bin.nii.gz
fslmaths $cest/$case/atlases/$case-2d-Schaefer100-bin.nii.gz -sub $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz $cest/$case/atlases/$case-2d-s100-NonMotor.nii.gz
fslmaths $cest/$case/atlases/$case-2d-s100-NonMotor.nii.gz -thr 0 $cest/$case/atlases/$case-2d-s100-NonMotor.nii.gz
mv -f $cest/$case/atlases/$case-2d-Schaefer100-bin.nii.gz $log_files

#######################################################################################################
echo -e "\n$case SUCCESFULLY PROCESSED\n\n\n"
)  | tee "$logfile"
else
echo "$case is either missing data or already processed. Will not process"
sleep 1.5
fi
done



for i in $(ls $dicoms)
do
case=${i##*/}
echo "CASE: $case"

#SomMotA Sub-Network (Figure XX)
antsApplyTransforms -d 3 -r $structural/$case/$case-UNI-masked.nii.gz -i $structural/MNI_Templates/Motor_Atlas/s100_SomMotA-0.8mm.nii.gz -n NearestNeighbor -o $structural/$case/atlases/${case}-s100-MotorAtlas-SomMotA.nii.gz -t [$structural/$case/MNI_transforms/$case-UNIinMNI-0GenericAffine.mat,1] -t $structural/$case/MNI_transforms/$case-UNIinMNI-1InverseWarp.nii.gz
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $structural/$case/atlases/${case}-s100-MotorAtlas-SomMotA.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest/$case/atlases/$case-2d-MotorAtlas-s100-SomMotA.nii
gzip $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotA.nii
fslmaths $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotA.nii.gz -mul $cest/$case/fast/$case-tissuemap-bin.nii.gz $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotA.nii.gz
cp -f $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotA.nii.gz $structural/MNI_Templates/Motor_Atlas/

#SomMotB Sub-Network (Figure XX)
antsApplyTransforms -d 3 -r $structural/$case/$case-UNI-masked.nii.gz -i $structural/MNI_Templates/Motor_Atlas/s100_SomMotB-0.8mm.nii.gz -n NearestNeighbor -o $structural/$case/atlases/${case}-s100-MotorAtlas-SomMotB.nii.gz -t [$structural/$case/MNI_transforms/$case-UNIinMNI-0GenericAffine.mat,1] -t $structural/$case/MNI_transforms/$case-UNIinMNI-1InverseWarp.nii.gz
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $structural/$case/atlases/${case}-s100-SomMotB.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotB.nii
gzip $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotB.nii
fslmaths $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotB.nii.gz -mul $cest/$case/fast/$case-tissuemap-bin.nii.gz $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotB.nii.gz
cp -f $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotB.nii.gz $structural/MNI_Templates/Motor_Atlas/



done

#SomMotA Sub-Network (Figure XX)
antsApplyTransforms -d 3 -r $structural/$case/$case-UNI-masked.nii.gz -i $structural/MNI_Templates/Motor_Atlas/s100_SomMotA-0.8mm.nii.gz -n NearestNeighbor -o $structural/$case/atlases/${case}-s100-MotorAtlas-SomMotA.nii.gz -t [$structural/$case/MNI_transforms/$case-UNIinMNI-0GenericAffine.mat,1] -t $structural/$case/MNI_transforms/$case-UNIinMNI-1InverseWarp.nii.gz
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $structural/$case/atlases/${case}-s100-MotorAtlas-SomMotA.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest/$case/atlases/$case-2d-MotorAtlas-s100-SomMotA.nii
gzip $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotA.nii
fslmaths $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotA.nii.gz -mul $cest/$case/fast/$case-tissuemap-bin.nii.gz $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotA.nii.gz
cp -f $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotA.nii.gz $structural/MNI_Templates/Motor_Atlas/



#Left and Right SomMotA and SomMotB Network
fslmaths $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -thr 8 -uthr 10 $cest/$case/atlases/$case-2d-l-SomMotA-0.8mm.nii.gz
fslmaths $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -thr 57 -uthr 60 $cest/$case/atlases/$case-2d-r-SomMotA-0.8mm.nii.gz
fslmaths $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -thr 11 -uthr 13 $cest/$case/atlases/$case-2d-l-SomMotB-0.8mm.nii.gz
fslmaths $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -thr 61 -uthr 64 $cest/$case/atlases/$case-2d-r-SomMotB-0.8mm.nii.gz
#Binarize
fslmaths $cest/$case/atlases/$case-2d-l-SomMotA-0.8mm.nii.gz -bin $cest/$case/atlases/$case-2d-l-SomMotA-0.8mm.nii.gz
fslmaths $cest/$case/atlases/$case-2d-r-SomMotA-0.8mm.nii.gz -bin $cest/$case/atlases/$case-2d-r-SomMotA-0.8mm.nii.gz
fslmaths $cest/$case/atlases/$case-2d-l-SomMotB-0.8mm.nii.gz -bin $cest/$case/atlases/$case-2d-l-SomMotB-0.8mm.nii.gz
fslmaths $cest/$case/atlases/$case-2d-r-SomMotB-0.8mm.nii.gz -bin $cest/$case/atlases/$case-2d-r-SomMotB-0.8mm.nii.gz
#Combine left and right
fslmaths $cest/$case/atlases/$case-2d-l-SomMotA-0.8mm.nii.gz -add $cest/$case/atlases/$case-2d-r-SomMotA-0.8mm.nii.gz $cest/$case/atlases/$case-2d-s100-SomMotA-0.8mm.nii.gz
fslmaths $cest/$case/atlases/$case-2d-l-SomMotB-0.8mm.nii.gz -add $cest/$case/atlases/$case-2d-r-SomMotB-0.8mm.nii.gz $cest/$case/atlases/$case-2d-s100-SomMotB-0.8mm.nii.gz
#Isolate ROI Data
fslmaths $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -mul $cest/$case/atlases/$case-2d-s100-SomMotA-0.8mm.nii.gz $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotA.nii.gz
fslmaths $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -mul $cest/$case/atlases/$case-2d-s100-SomMotB-0.8mm.nii.gz $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotB.nii.gz
cp -f $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotA.nii.gz $structural/MNI_Templates/Motor_Atlas/
cp -f $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotA.nii.gz $structural/MNI_Templates/Motor_Atlas/
