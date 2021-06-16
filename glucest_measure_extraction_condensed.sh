#!/bin/bash

#This script calculates GluCEST contrast and gray matter density measures

#######################################################################################################
## DEFINE PATHS ##

structural=/project/bbl_projects/MotorGluCEST/structural
cest=/project/bbl_projects/MotorGluCEST/glucest #path to processed GluCEST data
outputpath=/project/bbl_projects/MotorGluCEST/sandbox/output_measures

while read line
do
case=$line
mkdir $outputpath/$case
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
#######################################################################################################
## GMDensity MEASURE EXTRACTION ##

#Motor Network (Figure XX): Gray Matter Density
for atlas in ho s100
do
touch $outputpath/GMDensity-$atlas-MotorNetwork-Measures.csv
echo "Subject	MotorNetwork_GMDensity_mean	MotorNetwork_GMDensity_numvoxels	MotorNetwork_GMDensity_SD" >> $outputpath/GMDensity-$atlas-MotorNetwork-Measures.csv
while read line
do
case=$line
#quantify GM density for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-$atlas-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/fast/$case-2d-FASTGMprob.nii.gz >> $outputpath/$case/$case-$atlas-MotorNetwork-GMDensity-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-$atlas-MotorNetwork-GMDensity-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-$atlas-MotorNetwork-GMDensity-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-$atlas-MotorNetwork-GMDensity-measures.csv
#enter participant GM density data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-$atlas-MotorNetwork-GMDensity-measures.csv >> $outputpath/GMDensity-$atlas-MotorNetwork-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
done
#######################################################################################################
## GluCEST MEASURE EXTRACTION ##

# Make array to store names of ROIs, masks, and atlases
# These arrays are ordered so that they store corresponding names of atlases, input masks, and ROIs.
# These names are incorporated into filenames in the script below.
ROI_list=( "MotorNetwork" "MotorNetwork-M1" )
Mask_list=( "MotorAtlas-TotalNetwork" "MotorAtlas-M1" )
atlas_list=( "s100" "ho" )
#Loop through arrays to process data from all desiredROIs
for i in ${!ROI_list[@]}
do
echo $i
# for j in ${Mask_list[@]}
# do
# echo $j
# done

touch $outputpath/GluCEST-${atlas_list[i]}-${ROI_list[i]}-Measures.csv
echo "Subject \	${ROI_list[i]}_CEST_mean \ ${ROI_list[i]}_CEST_numvoxels \	${ROI_list[i]}_CEST_SD" >> $outputpath/GluCEST-${atlas_list[i]}-${ROI_list[i]}-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-${atlas_list[i]}-${Mask_list[i]}.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-${atlas_list[i]}-${ROI_list[i]}-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-${atlas_list[i]}-${ROI_list[i]}-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-${atlas_list[i]}-${ROI_list[i]}-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-${atlas_list[i]}-${ROI_list[i]}-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-${atlas_list[i]}-${ROI_list[i]}-GluCEST-measures.csv >> $outputpath/GluCEST-${atlas_list[i]}-${ROI_list[i]}-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
done

# "MotorAtlas-SMA"	"VisualAtlas-TotalNetwork"	"NonMotor"	"MotorAtlas-TotalNetwork"	"MotorAtlas-SomMotA"	"MotorAtlas-SomMotB"	"VisualAtlas-TotalNetwork"	"NonMotor" "Europe" "America"
#	"ho"	"ho"	"ho"	"s100"	"s100"	"s100"	"s100"	"s100")
#	"MotorNetwork_SMA"	"VisualNetwork"	"NonMotor"	"MotorNetwork"	"MotorNetwork-SomMotA"	"MotorNetwork-SomMotB"	"VisualNetwork"	"NonMotor" ) #"Germany" "Argentina" )
echo "Subject" "${ROI_list[i]}_CEST_mean" "${ROI_list[i]}_CEST_numvoxels" "${ROI_list[i]}_CEST_SD" >> $outputpath/GluCEST-${atlas_list[i]}-${ROI_list[i]}-Measures.csv


#######################################################################################################
## ALTERNATIVE Total NETWORK MEASURE EXTRACTION - CEST and GMDensity ##

# The script below is another version I was working on. A bit simpler/less condensed.

## Motor Network (Figure 2A): GluCEST Contrast
for atlas in ho s100
do

#s100 Motor Network (Figure XX): GluCEST Contrast
touch $outputpath/GluCEST-$atlas-MotorNetwork-Measures.csv
echo "Subject	MotorNetwork_CEST_mean MotorNetwork_CEST_numvoxels	MotorNetwork_CEST_SD" >> $outputpath/GluCEST-$atlas-MotorNetwork-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-$atlas-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-$atlas-GluCEST.nii.gz >> $outputpath/$case/$case-$atlas-MotorNetwork-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-$atlas-MotorNetwork-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-$atlas-MotorNetwork-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-$atlas-MotorNetwork-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-$atlas-MotorNetwork-GluCEST-measures.csv >> $outputpath/GluCEST-$atlas-MotorNetwork-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt

## Visual Network Regions (Figure 4): GluCEST Contrast
touch $outputpath/GluCEST-$atlas-VisualNetwork-Measures.csv
echo "Subject	Visual_CEST_mean	Visual_CEST_numvoxels	Visual_CEST_SD" >> $outputpath/GluCEST-$atlas-VisualNetwork-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-VisualAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-$atlas-VisualNetwork-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-$atlas-VisualNetwork-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-$atlas-VisualNetwork-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-$atlas-VisualNetwork-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-$atlas-VisualNetwork-GluCEST-measures.csv >> $outputpath/GluCEST-$atlas-VisualNetwork-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt

## All Non-Motor Brain Regions (Figure 4): GluCEST Contrast
touch $outputpath/GluCEST-$atlas-NonMotor-Measures.csv
echo "Subject	NonMotor_CEST_mean	NonMotor_CEST_numvoxels	NonMotor_CEST_SD" >> $outputpath/GluCEST-$atlas-NonMotor-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-$atlas-NonMotor.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-$atlas-NonMotor-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-$atlas-NonMotor-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-$atlas-NonMotor-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-$atlas-NonMotor-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-$atlas-NonMotor-GluCEST-measures.csv >> $outputpath/GluCEST-$atlas-NonMotor-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt


## Motor Network (Figure XX): Gray Matter Density
touch $outputpath/GMDensity-$atlas-MotorNetwork-Measures.csv
echo "Subject	MotorNetwork_GMDensity_mean	MotorNetwork_GMDensity_numvoxels	MotorNetwork_GMDensity_SD" >> $outputpath/GMDensity-$atlas-MotorNetwork-Measures.csv
while read line
do
case=$line
#quantify GM density for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-$atlas-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/fast/$case-2d-FASTGMprob.nii.gz >> $outputpath/$case/$case-$atlas-MotorNetwork-GMDensity-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-$atlas-MotorNetwork-GMDensity-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-$atlas-MotorNetwork-GMDensity-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-$atlas-MotorNetwork-GMDensity-measures.csv
#enter participant GM density data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-$atlas-MotorNetwork-GMDensity-measures.csv >> $outputpath/GMDensity-$atlas-MotorNetwork-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
done
#######################################################################################################
## SUB-NETWORK and ROI MEASURE EXTRACTION ##

# Harvard-Oxford Motor Network: M1 (Figure XX): GluCEST Contrast
touch $outputpath/GluCEST-MotorNetwork-M1-Measures.csv
echo "Subject	MotorNetwork_M1_CEST_mean	MotorNetwork_M1_CEST_numvoxels	MotorNetwork_M1_CEST_SD" >> $outputpath/GluCEST-MotorNetwork-M1-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-M1.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.csv >> $outputpath/GluCEST-MotorNetwork-M1-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt

# Harvard-Oxford Motor Network: SMA Component (Figure XX): GluCEST Contrast
touch $outputpath/GluCEST-MotorNetwork-SMA-Measures.csv
echo "Subject	MotorNetwork_SMA_CEST_mean	MotorNetwork_SMA_CEST_numvoxels	MotorNetwork_SMA_CEST_SD" >> $outputpath/GluCEST-MotorNetwork-SMA-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-SMA.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.csv >> $outputpath/GluCEST-MotorNetwork-SMA-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt

# Schaefer100 Motor Network: SomMotA (Figure 4): GluCEST Contrast
touch $outputpath/GluCEST-s100-MotorNetwork-SomMotA-Measures.csv
echo "Subject	MotorNetwork_Positive_CEST_mean	MotorNetwork_Positive_CEST_numvoxels	MotorNetwork_Positive_CEST_SD" >> $outputpath/GluCEST-s100-MotorNetwork-SomMotA-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-SomMotA.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.csv >> $outputpath/GluCEST-s100-MotorNetwork-SomMotA-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt

#Schaefer100 Motor Network: SomMotB (Figure 4): GluCEST Contrast
touch $outputpath/GluCEST-s100-MotorNetwork-SomMotB-Measures.csv
echo "Subject	MotorNetwork_Positive_CEST_mean	MotorNetwork_Positive_CEST_numvoxels	MotorNetwork_Positive_CEST_SD" >> $outputpath/GluCEST-s100-MotorNetwork-SomMotB-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-SomMotB.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.csv >> $outputpath/GluCEST-s100-MotorNetwork-SomMotB-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt


#######################################################################################################
## Sensitivity Analysis ##

# #Motor Atlas 50% Overlap Map (Sensitivity Analysis): GluCEST Contrast
# #NEED TO RUN HEATMAP SCRIPT FIRST
# touch $outputpath/GluCEST-ho-MotorNetwork-Heatmap50-Measures.csv
# echo "Subject	MotorNetwork_50_CEST_mean	MotorNetwork_50_CEST_numvoxels	MotorNetwork_50_CEST_SD" >> $outputpath/GluCEST-MotorNetwork-Heatmap50-Measures.csv
# while read line
# do
# case=$line
# #quantify GluCEST contrast for each participant & format participant-specific csv
# 3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-50%Heatmap.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-MotorNetwork-Heatmap50-GluCEST-measures.csv
# #format participant-specific csv
# sed -i 's/name/Subject/g' $outputpath/$case/$case-MotorNetwork-Heatmap50-GluCEST-measures.csv
# cut -f2-3 --complement $outputpath/$case/$case-MotorNetwork-Heatmap50-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
# mv $outputpath/$case/tmp.csv $outputpath/$case/$case-MotorNetwork-Heatmap50-GluCEST-measures.csv
# #enter participant GluCEST contrast data into master spreadsheet
# sed -n "2p" $outputpath/$case/$case-MotorNetwork-Heatmap50-GluCEST-measures.csv >> $outputpath/GluCEST-MotorNetwork-Heatmap50-Measures.csv
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt
