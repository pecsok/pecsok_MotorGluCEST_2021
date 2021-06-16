#!/bin/bash

#This script generates outputs for FAST segmentation.


#######################################################################################################
## DEFINE PATHS ##
structural=/project/bbl_projects/MotorGluCEST/structural
structural2=/project/bbl_projects/MotorGluCEST/sandbox/structural
dicoms=/project/bbl_projects/MotorGluCEST/dicoms
base=/project/bbl_projects/MotorGluCEST
fast_output=/project/bbl_projects/MotorGluCEST/sandbox/structural/fast_segmentations
cest=/project/bbl_projects/MotorGluCEST/glucest #path to processed GluCEST data
cest2=/project/bbl_projects/MotorGluCEST/sandbox/glucest
#######################################################################################################
## IDENTIFY CASES FOR PROCESSING ##

for i in 19798_PERC03 19981_11106 #$(ls $dicoms)
do
case=$i #${i##*/}

echo "CASE: $case"

mkdir $fast_output/$case
mkdir $fast_output/$case/fast

# INV2 Fast Segmentations
# fast -n 3 -t 1 -g -p -o $fast_output/$case/fast/$case-INV2-3 $structural/$case/$case-INV2-processed.nii.gz # INV2, n=3
# fast -n 4 -t 1 -g -p -o $fast_output/$case/fast/$case-INV2-4 $structural/$case/$case-INV2-processed.nii.gz # INV2, n=4
# fast -n 5 -t 1 -g -p -o $fast_output/$case/fast/$case-INV2-5 $structural/$case/$case-INV2-processed.nii.gz # INV2, n=5
# UNI Fast Segmentations
fast -n 3 -t 1 -g -p -o $fast_output/$case/fast/$case-UNI-3 $structural/$case/$case-UNI-processed.nii.gz # UNI, n=3
fast -n 4 -t 1 -g -p -o $fast_output/$case/fast/$case-UNI-4 $structural/$case/$case-UNI-processed.nii.gz # UNI, n=4
fast -n 5 -t 1 -g -p -o $fast_output/$case/fast/$case-UNI-5 $structural/$case/$case-UNI-processed.nii.gz # UNI, n=5

#######################################################################################################
## ALIGN FSL FAST OUTPUT TO GLUCEST IMAGES ##
mkdir $cest2/$case
mkdir $cest2/$case/fast
# /project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $fast_output/$case/fast/${case}-INV2-3_seg.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest2/$case/fast/$case-INV2-3-2d-FAST.nii
# gzip $cest2/$case/fast/$case-INV2-3-2d-FAST.nii
# /project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $fast_output/$case/fast/${case}-INV2-4_seg.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest2/$case/fast/$case-INV2-4-2d-FAST.nii
# gzip $cest2/$case/fast/$case-INV2-4-2d-FAST.nii
# /project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $fast_output/$case/fast/${case}-INV2-5_seg.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest2/$case/fast/$case-INV2-5-2d-FAST.nii
# gzip $cest2/$case/fast/$case-INV2-5-2d-FAST.nii

/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $fast_output/$case/fast/${case}-UNI-3_seg.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest2/$case/fast/$case-UNI-3-2d-FAST.nii
gzip $cest2/$case/fast/$case-UNI-3-2d-FAST.nii
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $fast_output/$case/fast/${case}-UNI-4_seg.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest2/$case/fast/$case-UNI-4-2d-FAST.nii
gzip $cest2/$case/fast/$case-UNI-4-2d-FAST.nii
/project/bbl_projects/apps/melliott/scripts/extract_slice2.sh -MultiLabel $fast_output/$case/fast/${case}-UNI-5_seg.nii.gz $cest/$case/orig_data/$case-B0B1CESTMAP.nii $cest2/$case/fast/$case-UNI-5-2d-FAST.nii
gzip $cest2/$case/fast/$case-UNI-5-2d-FAST.nii

done

for i in 90281_10902 20580_11279
do
case=$i #${i##*/}

mkdir $structural/$case/sandbox-fast/
cp $cest2/$case/fast/$case-UNI-3-2d-FAST.nii.gz $structural/$case/sandbox-fast/
cp $cest2/$case/fast/$case-UNI-4-2d-FAST.nii.gz $structural/$case/sandbox-fast/
cp $cest2/$case/fast/$case-UNI-5-2d-FAST.nii.gz $structural/$case/sandbox-fast/

done

for i in 19798_PERC03 19981_11106 97994_11114 
do
case=$i

fslmaths $structural/$case/sandbox-fast/$case-UNI-4-2d-FAST.nii.gz -thr 2 -uthr 3 $structural/$case/sandbox-fast/$case-UNI-4-2d-FAST-thr2-3.nii.gz
fslmaths $structural/$case/sandbox-fast/$case-UNI-4-2d-FAST-thr2-3.nii.gz -bin  $structural/$case/sandbox-fast/$case-UNI-4-2d-FAST-thr2-3.nii.gz
fslmaths $structural/$case/sandbox-fast/$case-UNI-5-2d-FAST.nii.gz -thr 3 -uthr 4 $structural/$case/sandbox-fast/$case-UNI-5-2d-FAST-thr3-4.nii.gz
fslmaths $structural/$case/sandbox-fast/$case-UNI-5-2d-FAST-thr3-4.nii.gz -bin $structural/$case/sandbox-fast/$case-UNI-5-2d-FAST-thr3-4.nii.gz

done
