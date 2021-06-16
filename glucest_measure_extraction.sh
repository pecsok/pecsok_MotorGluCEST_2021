#!/bin/bash

#This script calculates GluCEST contrast and gray matter density measures

#######################################################################################################
## DEFINE PATHS ##

structural=/project/bbl_projects/MotorGluCEST/structural
cest=/project/bbl_projects/MotorGluCEST/glucest #path to processed GluCEST data
outputpath=/project/bbl_projects/MotorGluCEST/sandbox/output_measures2

while read line
do
case=$line
mkdir $outputpath/$case
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt
#######################################################################################################
## Motor NETWORK MEASURE EXTRACTION ##

#Motor Network (Figure 2A): GluCEST Contrast
touch $outputpath/GluCEST-ho-MotorNetwork-Measures.csv
echo "Subject MotorNetwork_CEST_mean MotorNetwork_CEST_numvoxels MotorNetwork_CEST_SD" >> $outputpath/GluCEST-ho-MotorNetwork-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv
#format participant-specific csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv >> $outputpath/GluCEST-ho-MotorNetwork-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt


#Motor Network (Figure XX): Gray Matter Density
touch $outputpath/GMDensity-ho-MotorNetwork-Measures.csv
echo "Subject	MotorNetwork_GMDensity_mean MotorNetwork_GMDensity_numvoxels MotorNetwork_GMDensity_SD" >> $outputpath/GMDensity-ho-MotorNetwork-Measures.csv
while read line
do
case=$line
#quantify GM density for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/fast/$case-2d-FASTGMprob.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-GMDensity-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-GMDensity-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-GMDensity-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-ho-MotorNetwork-GMDensity-measures.csv
#enter participant GM density data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-GMDensity-measures.csv >> $outputpath/GMDensity-ho-MotorNetwork-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt

#Motor Network: M1 (Figure XX): GluCEST Contrast
touch $outputpath/GluCEST-ho-MotorNetwork-M1-Measures.csv
echo "Subject" "MotorNetwork_M1_CEST_mean" "MotorNetwork_M1_CEST_numvoxels" "MotorNetwork_M1_CEST_SD" >> $outputpath/GluCEST-ho-MotorNetwork-M1-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-M1.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.csv >> $outputpath/GluCEST-ho-MotorNetwork-M1-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt

#Motor Network: SMA Component (Figure XX): GluCEST Contrast
touch $outputpath/GluCEST-ho-MotorNetwork-SMA-Measures.csv
echo "Subject"	"MotorNetwork_SMA_CEST_mean"	"MotorNetwork_SMA_CEST_numvoxels"	"MotorNetwork_SMA_CEST_SD" >> $outputpath/GluCEST-ho-MotorNetwork-SMA-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-SMA.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.csv >> $outputpath/GluCEST-ho-MotorNetwork-SMA-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt
# #######################################################################################################
# # Sensitivity Analysis ##
#
# #Motor Atlas 50% Overlap Map (Sensitivity Analysis): GluCEST Contrast
# #NEED TO RUN HEATMAP SCRIPT FIRST
# touch $outputpath/GluCEST-ho-MotorNetwork-Heatmap50-Measures.csv
# echo "Subject"	"MotorNetwork_50_CEST_mean"	"MotorNetwork_50_CEST_numvoxels"	"MotorNetwork_50_CEST_SD" >> $outputpath/GluCEST-ho-MotorNetwork-Heatmap50-Measures.csv
# while read line
# do
# case=$line
# #quantify GluCEST contrast for each participant & format participant-specific csv
# 3dROIstats -mask $cest2/$case/atlases/$case-2d-ho-MotorAtlas-50%Heatmap.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-Heatmap50-GluCEST-measures.csv
# #format participant-specific csv
# sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-Heatmap50-GluCEST-measures.csv
# cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-Heatmap50-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
# mv $outputpath/$case/tmp.csv $outputpath/$case/$case-ho-MotorNetwork-Heatmap50-GluCEST-measures.csv
# #enter participant GluCEST contrast data into master spreadsheet
# sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-Heatmap50-GluCEST-measures.csv >> $outputpath/GluCEST-ho-MotorNetwork-Heatmap50-Measures.csv
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt
# #######################################################################################################
## NON-Motor MEASURE EXTRACTION ##

#Visual Network Regions (Figure 4): GluCEST Contrast
touch $outputpath/GluCEST-ho-VisualNetwork-Measures.csv
echo "Subject"	"NonMotor_CEST_mean"	"NonMotor_CEST_numvoxels"	"NonMotor_CEST_SD" >> $outputpath/GluCEST-ho-VisualNetwork-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv *****CHECK GLUCEST SCRIPT
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-VisualAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.csv >> $outputpath/GluCEST-ho-VisualNetwork-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt

#All Non-Motor Brain Regions (Figure 4): GluCEST Contrast
touch $outputpath/GluCEST-ho-NonMotor-Measures.csv
echo "Subject"	"NonMotor_CEST_mean"	"NonMotor_CEST_numvoxels"	"NonMotor_CEST_SD" >> $outputpath/GluCEST-ho-NonMotor-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-NonMotor.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-NonMotor-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-NonMotor-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-ho-NonMotor-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-ho-NonMotor-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-NonMotor-GluCEST-measures.csv >> $outputpath/GluCEST-ho-NonMotor-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt
#######################################################################################################
## Schaefer100 Atlas

#s100 Motor Network (Figure XX): GluCEST Contrast  ****Double check line 141 CEST input file!
touch $outputpath/GluCEST-s100-MotorNetwork-Measures.csv
echo "Subject"	"MotorNetworkC_CEST_mean" "MotorNetworkC_CEST_numvoxels"	"MotorNetworkC_CEST_SD" >> $outputpath/GluCEST-s100-MotorNetwork-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-MotorNetwork-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-MotorNetwork-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-s100-MotorNetwork-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-s100-MotorNetwork-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-MotorNetwork-GluCEST-measures.csv >> $outputpath/GluCEST-s100-MotorNetwork-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt

#s100 Motor Network (Figure XX): Gray Matter Density
touch $outputpath/GMDensity-s100-MotorNetwork-Measures.csv
echo "Subject"	"MotorNetwork_GMDensity_mean"	"MotorNetwork_GMDensity_numvoxels"	"MotorNetwork_GMDensity_SD" >> $outputpath/GMDensity-s100-MotorNetwork-Measures.csv
while read line
do
case=$line
#quantify GM density for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/fast/$case-2d-FASTGMprob.nii.gz >> $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.csv
#enter participant GM density data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.csv >> $outputpath/GMDensity-s100-MotorNetwork-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt

#S100 Motor Network: SomMotA (Figure 4): GluCEST Contrast ****STILL PROBLEMS
touch $outputpath/GluCEST-s100-MotorNetwork-SomMotA-Measures.csv
echo "Subject"	"MotorNetwork_Positive_CEST_mean"	"MotorNetwork_Positive_CEST_numvoxels"	"MotorNetwork_Positive_CEST_SD" >> $outputpath/GluCEST-s100-MotorNetwork-SomMotA-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotA.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.csv >> $outputpath/GluCEST-s100-MotorNetwork-SomMotA-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt

#S100 Motor Network: SomMotB (Figure 4): GluCEST Contrast
touch $outputpath/GluCEST-s100-MotorNetwork-SomMotB-Measures.csv
echo "Subject"	"MotorNetwork_Positive_CEST_mean"	"MotorNetwork_Positive_CEST_numvoxels"	"MotorNetwork_Positive_CEST_SD" >> $outputpath/GluCEST-s100-MotorNetwork-SomMotB-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotB.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.csv >> $outputpath/GluCEST-s100-MotorNetwork-SomMotB-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt

# #######################################################################################################
# # Sensitivity Analysis ##
#
# #Motor Atlas 50% Overlap Map (Sensitivity Analysis): GluCEST Contrast
# #NEED TO RUN HEATMAP SCRIPT FIRST
# touch $outputpath/GluCEST-s100-MotorNetwork-Heatmap50-Measures.csv
# echo "Subject"	"MotorNetwork_50_CEST_mean"	"MotorNetwork_50_CEST_numvoxels"	"MotorNetwork_50_CEST_SD" >> $outputpath/GluCEST-s100-MotorNetwork-Heatmap50-Measures.csv
# while read line
# do
# case=$line
# #quantify GluCEST contrast for each participant & format participant-specific csv
# 3dROIstats -mask $cest2/$case/atlases/$case-2d-s100-MotorAtlas-50%Heatmap.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-MotorNetwork-Heatmap50-GluCEST-measures.csv
# #format participant-specific csv
# sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-MotorNetwork-Heatmap50-GluCEST-measures.csv
# cut -f2-3 --complement $outputpath/$case/$case-s100-MotorNetwork-Heatmap50-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
# mv $outputpath/$case/tmp.csv $outputpath/$case/$case-s100-MotorNetwork-Heatmap50-GluCEST-measures.csv
# #enter participant GluCEST contrast data into master spreadsheet
# sed -n "2p" $outputpath/$case/$case-s100-MotorNetwork-Heatmap50-GluCEST-measures.csv >> $outputpath/GluCEST-s100-MotorNetwork-Heatmap50-Measures.csv
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt
# #######################################################################################################
## NON-Motor MEASURE EXTRACTION ##

#Visual Network Regions (Figure 4): GluCEST Contrast
touch $outputpath/GluCEST-s100-VisualNetwork-Measures.csv
echo "Subject"	"NonMotor_CEST_mean"	"NonMotor_CEST_numvoxels"	"NonMotor_CEST_SD" >> $outputpath/GluCEST-s100-VisualNetwork-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-VisualAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-VisualNetwork-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-VisualNetwork-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-s100-VisualNetwork-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-s100-VisualNetwork-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-VisualNetwork-GluCEST-measures.csv >> $outputpath/GluCEST-s100-VisualNetwork-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt

#All Non-Motor Brain Regions (Figure 4): GluCEST Contrast
touch $outputpath/GluCEST-s100-NonMotor-Measures.csv
echo "Subject"	"NonMotor_CEST_mean"	"NonMotor_CEST_numvoxels"	"NonMotor_CEST_SD" >> $outputpath/GluCEST-s100-NonMotor-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-NonMotor.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.csv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.csv
cut -f2-3 --complement $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.csv >> $outputpath/GluCEST-s100-NonMotor-Measures.csv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt
