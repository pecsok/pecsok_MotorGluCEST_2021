#!/bin/bash

#This script extracts mask for motor areas


for i in $(ls $dicoms)
do
  for y in a b c d e f g h i j k l m n o p q r s t u v w x
  do

case=$i #case=${i##*/}
echo "CASE: $case"

if [$dicoms/$case/*mp2rage_mark_ipat3_0.80mm_INV2/*3$y.nii]
then

echo "yes"
fi
done
done



done


#######################################################################################################
## DEFINE PATHS ##
structural=/project/bbl_projects/MotorGluCEST/sandbox/structural
structural2=/project/bbl_projects/MotorGluCEST/structural
#######################################################################################################
##  ##

#for atlas in cort sub
#do
#Add Motor ROIs
#Primary Motor Cortex
fslmaths $structural/MNI_Templates/HarvardOxford/HarvardOxford-cort-maxprob-thr25-0.8mm.nii.gz -thr 7 -uthr 7 $structural/MNI_Templates/HarvardOxford/m1-motormask-0.8mm.nii.gz
#Supplememntary Motor Cortex
fslmaths $structural/MNI_Templates/HarvardOxford/HarvardOxford-cort-maxprob-thr25-0.8mm.nii.gz -thr 26 -uthr 26 $structural/MNI_Templates/HarvardOxford/sma-motormask-0.8mm.nii.gz
#Binarize
fslmaths $structural/MNI_Templates/HarvardOxford/m1-motormask-0.8mm.nii.gz -bin $structural/MNI_Templates/HarvardOxford/m1-bin-motormask-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/HarvardOxford/sma-motormask-0.8mm.nii.gz -bin $structural/MNI_Templates/HarvardOxford/sma-bin-motormask-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/HarvardOxford/m1-bin-motormask-0.8mm.nii.gz -add $structural/MNI_Templates/HarvardOxford/sma-bin-motormask-0.8mm.nii.gz $structural/MNI_Templates/HarvardOxford/motormask-0.8mm.nii.gz
#Non-motor mask
fslmaths $structural/MNI_Templates/HarvardOxford/HarvardOxford-cort-maxprob-thr25-0.8mm.nii.gz -bin $structural/MNI_Templates/HarvardOxford/bin_HarvardOxford-cort-maxprob-thr25-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/HarvardOxford/bin_HarvardOxford-cort-maxprob-thr25-0.8mm.nii.gz -sub $structural/MNI_Templates/HarvardOxford/motormask-0.8mm.nii.gz $structural/MNI_Templates/HarvardOxford/non-motormask.nii.gz

#Add Occipital ROIs
#Occipital Pole and supracalcarine sulcus
fslmaths $structural/MNI_Templates/HarvardOxford/HarvardOxford-cort-maxprob-thr25-0.8mm.nii.gz -thr 47 -uthr 48 $structural/MNI_Templates/HarvardOxford/vis1-mask-0.8mm.nii.gz
#Other Visual Areas (Occ fusiform, Inferior Lateral Occipital Cortex, intracalcarine sortex,cuneal,lingual)
fslmaths $structural/MNI_Templates/HarvardOxford/HarvardOxford-cort-maxprob-thr25-0.8mm.nii.gz -thr 40 -uthr 40 $structural/MNI_Templates/HarvardOxford/vis2-mask-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/HarvardOxford/HarvardOxford-cort-maxprob-thr25-0.8mm.nii.gz -thr 23 -uthr 24 $structural/MNI_Templates/HarvardOxford/vis3-mask-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/HarvardOxford/HarvardOxford-cort-maxprob-thr25-0.8mm.nii.gz -thr 32 -uthr 32 $structural/MNI_Templates/HarvardOxford/vis4-mask-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/HarvardOxford/HarvardOxford-cort-maxprob-thr25-0.8mm.nii.gz -thr 36 -uthr 36 $structural/MNI_Templates/HarvardOxford/vis5-mask-0.8mm.nii.gz
#Binarize
fslmaths $structural/MNI_Templates/HarvardOxford/vis1-mask-0.8mm.nii.gz -bin $structural/MNI_Templates/HarvardOxford/vis1-bin-mask-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/HarvardOxford/vis2-mask-0.8mm.nii.gz -bin $structural/MNI_Templates/HarvardOxford/vis2-bin-mask-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/HarvardOxford/vis3-mask-0.8mm.nii.gz -bin $structural/MNI_Templates/HarvardOxford/vis3-bin-mask-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/HarvardOxford/vis4-mask-0.8mm.nii.gz -bin $structural/MNI_Templates/HarvardOxford/vis4-bin-mask-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/HarvardOxford/vis5-mask-0.8mm.nii.gz -bin $structural/MNI_Templates/HarvardOxford/vis5-bin-mask-0.8mm.nii.gz

fslmaths $structural/MNI_Templates/HarvardOxford/vis1-bin-mask-0.8mm.nii.gz -add $structural/MNI_Templates/HarvardOxford/vis2-bin-mask-0.8mm.nii.gz -add $structural/MNI_Templates/HarvardOxford/vis3-bin-mask-0.8mm.nii.gz -add $structural/MNI_Templates/HarvardOxford/vis4-bin-mask-0.8mm.nii.gz -add $structural/MNI_Templates/HarvardOxford/vis5-bin-mask-0.8mm.nii.gz $structural/MNI_Templates/HarvardOxford/vismask-0.8mm.nii.gz


cp $structural/MNI_Templates/HarvardOxford/m1-bin-motormask-0.8mm.nii.gz $structural2/MNI_Templates/Motor_Atlas/ho-m1-motormask-0.8mm.nii.gz
cp $structural/MNI_Templates/HarvardOxford/sma-bin-motormask-0.8mm.nii.gz $structural2/MNI_Templates/Motor_Atlas/ho-sma-motormask-0.8mm.nii.gz
cp $structural/MNI_Templates/HarvardOxford/motormask-0.8mm.nii.gz $structural2/MNI_Templates/Motor_Atlas/ho-motormask-0.8mm.nii.gz
cp $structural/MNI_Templates/HarvardOxford/non-motormask.nii.gz $structural2/MNI_Templates/Motor_Atlas/ho-non-motormask-0.8mm.nii.gz
cp $structural/MNI_Templates/HarvardOxford/vismask-0.8mm.nii.gz $structural2/MNI_Templates/Visual_Atlas/ho-vismask-0.8mm.nii.gz


#
# #centralvis
# fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -thr 1 -uthr 4 $cest/$case/atlases/$case-l-centralvis-0.8mm.nii.gz #extract cortical s100 labels
# fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -thr 51 -uthr 53 $cest/$case/atlases/$case-r-centralvis-0.8mm.nii.gz #extract cortical s100 labels
# fslmaths $cest/$case/atlases/$case-l-centralvis-0.8mm.nii.gz -bin $cest/$case/atlases/$case-l-centralvis-0.8mm.nii.gz #binarize
# fslmaths $cest/$case/atlases/$case-r-centralvis-0.8mm.nii.gz -bin $cest/$case/atlases/$case-r-centralvis-0.8mm.nii.gz #binarize
# fslmaths $cest/$case/atlases/$case-l-centralvis-0.8mm.nii.gz -add $cest/$case/atlases/$case-r-centralvis-0.8mm.nii.gz $cest/$case/atlases/$case-2d-centralvis.nii.gz #combine l and r
# fslmaths $cest/$case/atlases/$case-2d-s100-VisualAtlas-TotalNetwork.nii.gz -mul $cest/$case/atlases/$case-2d-centralvis.nii.gz $cest/$case/atlases/$case-2d-VisualAtlas-centralvis.nii.gz
# #periphvis
# fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -thr 5 -uthr 7 $cest/$case/atlases/$case-l-periphvis-0.8mm.nii.gz #extract cortical s100 labels
# fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -thr 54 -uthr 56 $cest/$case/atlases/$case-r-periphvis-0.8mm.nii.gz #extract cortical s100 labels
# fslmaths $cest/$case/atlases/$case-l-periphvis-0.8mm.nii.gz -bin $cest/$case/atlases/$case-l-periphvis-0.8mm.nii.gz #binarize
# fslmaths $cest/$case/atlases/$case-r-periphvis-0.8mm.nii.gz -bin $cest/$case/atlases/$case-r-periphvis-0.8mm.nii.gz #binarize
# fslmaths $cest/$case/atlases/$case-l-periphvis-0.8mm.nii.gz -add $cest/$case/atlases/$case-r-periphvis-0.8mm.nii.gz $cest/$case/atlases/$case-2d-periphvis.nii.gz #combine l and r
# fslmaths $cest/$case/atlases/$case-2d-s100-VisualAtlas-TotalNetwork.nii.gz -mul $cest/$case/atlases/$case-2d-periphvis.nii.gz $cest/$case/atlases/$case-2d-VisualAtlas-periphvis.nii.gz



#Schaefer100 masks
ResampleImage 3 Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm.nii.gz Schaefer2018_100Parcels_17Networks_order_FSLMNI152_0.8mm.nii.gz 0.8223684430X0.8223684430X0.8199999928 0 1
#Left and Right Central Visual Network
fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_17Networks_order_FSLMNI152_0.8mm.nii.gz -thr 1 -uthr 4 $structural/MNI_Templates/Schaefer100/l-centralvis-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_17Networks_order_FSLMNI152_0.8mm.nii.gz -thr 51 -uthr 53 $structural/MNI_Templates/Schaefer100/r-centralvis-0.8mm.nii.gz
#Left and Right Periph Visual Network
fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_17Networks_order_FSLMNI152_0.8mm.nii.gz -thr 5 -uthr 7 $structural/MNI_Templates/Schaefer100/l-periphvis-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_17Networks_order_FSLMNI152_0.8mm.nii.gz -thr 54 -uthr 56 $structural/MNI_Templates/Schaefer100/r-periphvis-0.8mm.nii.gz
#Binarize
fslmaths $structural/MNI_Templates/Schaefer100/l-centralvis-0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/l-bin-centralvis-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/Schaefer100/r-centralvis-0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/r-bin-centralvis-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/Schaefer100/l-periphvis-0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/l-bin-periphvis-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/Schaefer100/r-periphvis-0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/r-bin-periphvis-0.8mm.nii.gz
#Combine
fslmaths $structural/MNI_Templates/Schaefer100/s100_periphvis-0.8mm.nii.gz -add $structural/MNI_Templates/Schaefer100/s100_centralvis-0.8mm.nii.gz $structural/MNI_Templates/Schaefer100/s100_visualmask-0.8mm.nii.gz

#Left and Right SomMotA Network
fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_17Networks_order_FSLMNI152_0.8mm.nii.gz -thr 8 -uthr 10 $structural/MNI_Templates/Schaefer100/l-SomMotA-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_17Networks_order_FSLMNI152_0.8mm.nii.gz -thr 57 -uthr 60 $structural/MNI_Templates/Schaefer100/r-SomMotA-0.8mm.nii.gz
#Left and Right SomMotB Network
fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_17Networks_order_FSLMNI152_0.8mm.nii.gz -thr 11 -uthr 13 $structural/MNI_Templates/Schaefer100/l-SomMotB-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_17Networks_order_FSLMNI152_0.8mm.nii.gz -thr 61 -uthr 64 $structural/MNI_Templates/Schaefer100/r-SomMotB-0.8mm.nii.gz
#Binarize
fslmaths $structural/MNI_Templates/Schaefer100/l-SomMotA-0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/l-bin-SomMotA-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/Schaefer100/r-SomMotA-0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/r-bin-SomMotA-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/Schaefer100/l-SomMotB-0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/l-bin-SomMotB-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/Schaefer100/r-SomMotB-0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/r-bin-SomMotB-0.8mm.nii.gz
#Combine
fslmaths $structural/MNI_Templates/Schaefer100/l-bin-SomMotA-0.8mm.nii.gz -add $structural/MNI_Templates/Schaefer100/r-bin-SomMotA-0.8mm.nii.gz $structural/MNI_Templates/Schaefer100/s100_SomMotA-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/Schaefer100/l-bin-SomMotB-0.8mm.nii.gz -add $structural/MNI_Templates/Schaefer100/r-bin-SomMotB-0.8mm.nii.gz $structural/MNI_Templates/Schaefer100/s100_SomMotB-0.8mm.nii.gz
fslmaths $structural/MNI_Templates/Schaefer100/s100_SomMotA-0.8mm.nii.gz -add $structural/MNI_Templates/Schaefer100/s100_SomMotB-0.8mm.nii.gz $structural/MNI_Templates/Schaefer100/s100_motormask-0.8mm.nii.gz
#Non-motor mask
fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_17Networks_order_FSLMNI152_0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/bin_Schaefer2018_100Parcels_17Networks_order_FSLMNI152_0.8mm.nii.gz
fslmaths $structural/MNI_Templates/Schaefer100/bin_Schaefer2018_100Parcels_17Networks_order_FSLMNI152_0.8mm.nii.gz -sub $structural/MNI_Templates/Schaefer100/s100_motormask-0.8mm.nii.gz $structural/MNI_Templates/Schaefer100/s100_non-motormask.nii.gz


cp $structural/MNI_Templates/Schaefer100/s100_visualmask-0.8mm.nii.gz $structural2/MNI_Templates/Visual_Atlas/s100_visualmask-0.8mm.nii.gz
cp $structural/MNI_Templates/Schaefer100/s100_SomMotA-0.8mm.nii.gz $structural2/MNI_Templates/Motor_Atlas/s100_SomMotA-0.8mm.nii.gz
cp $structural/MNI_Templates/Schaefer100/s100_SomMotB-0.8mm.nii.gz $structural2/MNI_Templates/Motor_Atlas/s100_SomMotB-0.8mm.nii.gz
cp $structural/MNI_Templates/Schaefer100/s100_motormask-0.8mm.nii.gz $structural2/MNI_Templates/Motor_Atlas/s100_motormask-0.8mm.nii.gz
cp $structural/MNI_Templates/Schaefer100/s100_non-motormask.nii.gz $structural2/MNI_Templates/Motor_Atlas/s100_non-motormask.nii.gz


#
#
# #Schaefer100 Occipital MASK (55,58)
# #Left Motor Network
# fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_7Networks_order_FSLMNI152_0.8mm.nii.gz -thr 10 -uthr 15 $structural/MNI_Templates/Schaefer100/l-motormask-0.8mm.nii.gz
# #Right Motor Network
# fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_7Networks_order_FSLMNI152_0.8mm.nii.gz -thr 59 -uthr 66 $structural/MNI_Templates/Schaefer100/r-motormask-0.8mm.nii.gz
# #Binarize
# fslmaths $structural/MNI_Templates/Schaefer100/l-motormask-0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/l-bin-motormask-0.8mm.nii.gz
# fslmaths $structural/MNI_Templates/Schaefer100/r-motormask-0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/r-bin-motormask-0.8mm.nii.gz
# fslmaths $structural/MNI_Templates/Schaefer100/l-bin-motormask-0.8mm.nii.gz -add $structural/MNI_Templates/Schaefer100/r-bin-motormask-0.8mm.nii.gz $structural/MNI_Templates/Schaefer100/s100_motormask-0.8mm.nii.gz
# #Non-motor mask
# fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_7Networks_order_FSLMNI152_0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/bin_Schaefer2018_100Parcels_7Networks_order_FSLMNI152_0.8mm.nii.gz
# fslmaths $structural/MNI_Templates/Schaefer100/bin_Schaefer2018_100Parcels_7Networks_order_FSLMNI152_0.8mm.nii.gz -sub $structural/MNI_Templates/Schaefer100/s100_motormask-0.8mm.nii.gz $structural/MNI_Templates/Schaefer100/s100_non-motormask.nii.gz
#
# #Left Visual Network
# fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_7Networks_order_FSLMNI152_0.8mm.nii.gz -thr 1 -uthr 9 $structural/MNI_Templates/Schaefer100/l-visualmask-0.8mm.nii.gz
# #Right Visual Network
# fslmaths $structural/MNI_Templates/Schaefer100/Schaefer2018_100Parcels_7Networks_order_FSLMNI152_0.8mm.nii.gz -thr 51 -uthr 58 $structural/MNI_Templates/Schaefer100/r-visualmask-0.8mm.nii.gz
# #Binarize
# fslmaths $structural/MNI_Templates/Schaefer100/l-visualmask-0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/l-bin-visualmask-0.8mm.nii.gz
# fslmaths $structural/MNI_Templates/Schaefer100/r-visualmask-0.8mm.nii.gz -bin $structural/MNI_Templates/Schaefer100/r-bin-visualmask-0.8mm.nii.gz
# fslmaths $structural/MNI_Templates/Schaefer100/l-bin-visualmask-0.8mm.nii.gz -add $structural/MNI_Templates/Schaefer100/r-bin-visualmask-0.8mm.nii.gz $structural/MNI_Templates/Schaefer100/s100_visualmask-0.8mm.nii.gz
#
#
#
#
#
# #Could be added to glucest script:
#
# #Motor Network ROIs: M1 (Figure XX) (For now, just using -cort atlas.)
# # Isolate ROI; binarize; extract data
# #SomMotA
# fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -thr 8 -uthr 10 $cest/$case/atlases/$case-l-SomMotA-0.8mm.nii.gz #extract cortical s100 labels
# fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -thr 57 -uthr 60 $cest/$case/atlases/$case-r-SomMotA-0.8mm.nii.gz #extract cortical s100 labels
# fslmaths $cest/$case/atlases/$case-l-SomMotA-0.8mm.nii.gz -bin $cest/$case/atlases/$case-l-SomMotA-0.8mm.nii.gz #binarize
# fslmaths $cest/$case/atlases/$case-r-SomMotA-0.8mm.nii.gz -bin $cest/$case/atlases/$case-r-SomMotA-0.8mm.nii.gz #binarize
# fslmaths $cest/$case/atlases/$case-l-SomMotA-0.8mm.nii.gz -add $cest/$case/atlases/$case-r-SomMotA-0.8mm.nii.gz $cest/$case/atlases/$case-2d-SomMotA.nii.gz #combine l and r
# fslmaths $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -mul $cest/$case/atlases/$case-2d-SomMotA.nii.gz $cest/$case/atlases/$case-2d-MotorAtlas-SomMotA.nii.gz
# #SomMotB
# fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -thr 11 -uthr 13 $cest/$case/atlases/$case-l-SomMotB-0.8mm.nii.gz #extract cortical s100 labels
# fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -thr 61 -uthr 64 $cest/$case/atlases/$case-r-SomMotB-0.8mm.nii.gz #extract cortical s100 labels
# fslmaths $cest/$case/atlases/$case-l-SomMotB-0.8mm.nii.gz -bin $cest/$case/atlases/$case-l-SomMotB-0.8mm.nii.gz #binarize
# fslmaths $cest/$case/atlases/$case-r-SomMotB-0.8mm.nii.gz -bin $cest/$case/atlases/$case-r-SomMotB-0.8mm.nii.gz #binarize
# fslmaths $cest/$case/atlases/$case-l-SomMotB-0.8mm.nii.gz -add $cest/$case/atlases/$case-r-SomMotB-0.8mm.nii.gz $cest/$case/atlases/$case-2d-SomMotB.nii.gz #combine l and r
# fslmaths $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -mul $cest/$case/atlases/$case-2d-SomMotB.nii.gz $cest/$case/atlases/$case-2d-MotorAtlas-SomMotB.nii.gz
#
# #centralvis
# fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -thr 1 -uthr 4 $cest/$case/atlases/$case-l-centralvis-0.8mm.nii.gz #extract cortical s100 labels
# fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -thr 51 -uthr 53 $cest/$case/atlases/$case-r-centralvis-0.8mm.nii.gz #extract cortical s100 labels
# fslmaths $cest/$case/atlases/$case-l-centralvis-0.8mm.nii.gz -bin $cest/$case/atlases/$case-l-centralvis-0.8mm.nii.gz #binarize
# fslmaths $cest/$case/atlases/$case-r-centralvis-0.8mm.nii.gz -bin $cest/$case/atlases/$case-r-centralvis-0.8mm.nii.gz #binarize
# fslmaths $cest/$case/atlases/$case-l-centralvis-0.8mm.nii.gz -add $cest/$case/atlases/$case-r-centralvis-0.8mm.nii.gz $cest/$case/atlases/$case-2d-centralvis.nii.gz #combine l and r
# fslmaths $cest/$case/atlases/$case-2d-s100-VisualAtlas-TotalNetwork.nii.gz -mul $cest/$case/atlases/$case-2d-centralvis.nii.gz $cest/$case/atlases/$case-2d-VisualAtlas-centralvis.nii.gz
# #periphvis
# fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -thr 5 -uthr 7 $cest/$case/atlases/$case-l-periphvis-0.8mm.nii.gz #extract cortical s100 labels
# fslmaths $cest/$case/atlases/$case-2d-Schaefer100.nii.gz -thr 54 -uthr 56 $cest/$case/atlases/$case-r-periphvis-0.8mm.nii.gz #extract cortical s100 labels
# fslmaths $cest/$case/atlases/$case-l-periphvis-0.8mm.nii.gz -bin $cest/$case/atlases/$case-l-periphvis-0.8mm.nii.gz #binarize
# fslmaths $cest/$case/atlases/$case-r-periphvis-0.8mm.nii.gz -bin $cest/$case/atlases/$case-r-periphvis-0.8mm.nii.gz #binarize
# fslmaths $cest/$case/atlases/$case-l-periphvis-0.8mm.nii.gz -add $cest/$case/atlases/$case-r-periphvis-0.8mm.nii.gz $cest/$case/atlases/$case-2d-periphvis.nii.gz #combine l and r
# fslmaths $cest/$case/atlases/$case-2d-s100-VisualAtlas-TotalNetwork.nii.gz -mul $cest/$case/atlases/$case-2d-periphvis.nii.gz $cest/$case/atlases/$case-2d-VisualAtlas-periphvis.nii.gz
