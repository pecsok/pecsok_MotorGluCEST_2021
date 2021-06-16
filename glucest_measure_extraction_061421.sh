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
## Motor NETWORK MEASURE EXTRACTION ##

#Motor Network (Figure 2A): GluCEST Contrast
#touch $outputpath/GluCEST-ho-MotorNetwork-Measures.tsv
printf "Subject\tMotorNetwork_CEST_mean\tMotorNetwork_CEST_numvoxels\tMotorNetwork_CEST_SD\n" >> $outputpath/GluCEST-ho-MotorNetwork-Measures.tsv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific tsv
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.tsv
#format participant-specific tsv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.tsv
cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.tsv >> $outputpath/$case/tmp.tsv
mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.tsv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.tsv >> $outputpath/GluCEST-ho-MotorNetwork-Measures.tsv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt


#Motor Network (Figure XX): Gray Matter Density
#touch $outputpath/GMDensity-ho-MotorNetwork-Measures.tsv
printf "Subject\tMotorNetwork_GMDensity_mean\tMotorNetwork_GMDensity_numvoxels\tMotorNetwork_GMDensity_SD\n" >> $outputpath/GMDensity-ho-MotorNetwork-Measures.tsv
while read line
do
case=$line
#quantify GM density for each participant & format participant-specific tsv
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/fast/$case-2d-FASTGMprob.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-GMDensity-measures.tsv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-GMDensity-measures.tsv
cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-GMDensity-measures.tsv >> $outputpath/$case/tmp.tsv
mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-ho-MotorNetwork-GMDensity-measures.tsv
#enter participant GM density data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-GMDensity-measures.tsv >> $outputpath/GMDensity-ho-MotorNetwork-Measures.tsv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt

#Motor Network: M1 (Figure XX): GluCEST Contrast
#touch $outputpath/GluCEST-ho-MotorNetwork-M1-Measures.tsv
printf "Subject\tMotorNetwork_M1_CEST_mean\tMotorNetwork_M1_CEST_numvoxels\tMotorNetwork_M1_CEST_SD\n" >> $outputpath/GluCEST-ho-MotorNetwork-M1-Measures.tsv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific tsv
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-M1.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.tsv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.tsv
cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.tsv >> $outputpath/$case/tmp.tsv
mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.tsv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-M1-GluCEST-measures.tsv >> $outputpath/GluCEST-ho-MotorNetwork-M1-Measures.tsv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt

#Motor Network: SMA Component (Figure XX): GluCEST Contrast
#touch $outputpath/GluCEST-ho-MotorNetwork-SMA-Measures.tsv
printf "Subject\tMotorNetwork_SMA_CEST_mean\tMotorNetwork_SMA_CEST_numvoxels\tMotorNetwork_SMA_CEST_SD\n" >> $outputpath/GluCEST-ho-MotorNetwork-SMA-Measures.tsv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific tsv
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-SMA.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.tsv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.tsv
cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.tsv >> $outputpath/$case/tmp.tsv
mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.tsv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-SMA-GluCEST-measures.tsv >> $outputpath/GluCEST-ho-MotorNetwork-SMA-Measures.tsv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
# #######################################################################################################
## NON-Motor MEASURE EXTRACTION ##
#Visual Network Regions (Figure 4): GluCEST Contrast
#touch $outputpath/GluCEST-ho-VisualNetwork-Measures.tsv
printf "Subject\tVisual_CEST_mean\tVisual_CEST_numvoxels\tVisual_CEST_SD\n" >> $outputpath/GluCEST-ho-VisualNetwork-Measures.tsv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific tsv *****CHECK GLUCEST SCRIPT
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-VisualAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.tsv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.tsv
cut -f2-3 --complement $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.tsv >> $outputpath/$case/tmp.tsv
mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.tsv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.tsv >> $outputpath/GluCEST-ho-VisualNetwork-Measures.tsv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt

#All Non-Motor Brain Regions (Figure 4): GluCEST Contrast
#touch $outputpath/GluCEST-ho-NonMotor-Measures.tsv
printf "Subject\tNonMotor_CEST_mean\tNonMotor_CEST_numvoxels\tNonMotor_CEST_SD\n" >> $outputpath/GluCEST-ho-NonMotor-Measures.tsv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific tsv
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-NonMotor.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-NonMotor-GluCEST-measures.tsv
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-NonMotor-GluCEST-measures.tsv
cut -f2-3 --complement $outputpath/$case/$case-ho-NonMotor-GluCEST-measures.tsv >> $outputpath/$case/tmp.tsv
mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-ho-NonMotor-GluCEST-measures.tsv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-ho-NonMotor-GluCEST-measures.tsv >> $outputpath/GluCEST-ho-NonMotor-Measures.tsv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
#######################################################################################################
## Schaefer100 Atlas

#s100 Motor Network (Figure XX): GluCEST Contrast  ****Double check line 141 CEST input file!
#touch $outputpath/GluCEST-s100-MotorNetwork-Measures.tsv
printf "Subject\tMotorNetwork_CEST_mean\tMotorNetwork_CEST_numvoxels\tMotorNetwork_CEST_SD\n" >> $outputpath/GluCEST-s100-MotorNetwork-Measures.tsv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific tsv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-MotorNetwork-GluCEST-measures.tsv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-MotorNetwork-GluCEST-measures.tsv
cut -f2-3 --complement $outputpath/$case/$case-s100-MotorNetwork-GluCEST-measures.tsv >> $outputpath/$case/tmp.tsv
mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-s100-MotorNetwork-GluCEST-measures.tsv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-MotorNetwork-GluCEST-measures.tsv >> $outputpath/GluCEST-s100-MotorNetwork-Measures.tsv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt

#s100 Motor Network (Figure XX): Gray Matter Density
#touch $outputpath/GMDensity-s100-MotorNetwork-Measures.tsv
printf "Subject\tMotorNetwork_GMDensity_mean\tMotorNetwork_GMDensity_numvoxels\tMotorNetwork_GMDensity_SD\n" >> $outputpath/GMDensity-s100-MotorNetwork-Measures.tsv
while read line
do
case=$line
#quantify GM density for each participant & format participant-specific tsv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/fast/$case-2d-FASTGMprob.nii.gz >> $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.tsv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.tsv
cut -f2-3 --complement $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.tsv >> $outputpath/$case/tmp.tsv
mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.tsv
#enter participant GM density data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.tsv >> $outputpath/GMDensity-s100-MotorNetwork-Measures.tsv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt

#S100 Motor Network: SomMotA (Figure 4): GluCEST Contrast ****STILL PROBLEMS
#touch $outputpath/GluCEST-s100-MotorNetwork-SomMotA-Measures.tsv
printf "Subject\tMotorNetwork_Positive_CEST_mean\tMotorNetwork_Positive_CEST_numvoxels\tMotorNetwork_Positive_CEST_SD\n" >> $outputpath/GluCEST-s100-MotorNetwork-SomMotA-Measures.tsv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific tsv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotA.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.tsv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.tsv
cut -f2-3 --complement $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.tsv >> $outputpath/$case/tmp.tsv
mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.tsv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-MotorNetwork-SomMotA-GluCEST-measures.tsv >> $outputpath/GluCEST-s100-MotorNetwork-SomMotA-Measures.tsv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt

#S100 Motor Network: SomMotB (Figure 4): GluCEST Contrast
#touch $outputpath/GluCEST-s100-MotorNetwork-SomMotB-Measures.tsv
printf "Subject\tMotorNetwork_Positive_CEST_mean\tMotorNetwork_Positive_CEST_numvoxels\tMotorNetwork_Positive_CEST_SD\n" >> $outputpath/GluCEST-s100-MotorNetwork-SomMotB-Measures.tsv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific tsv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-MotorAtlas-SomMotB.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.tsv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.tsv
cut -f2-3 --complement $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.tsv >> $outputpath/$case/tmp.tsv
mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.tsv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-MotorNetwork-SomMotB-GluCEST-measures.tsv >> $outputpath/GluCEST-s100-MotorNetwork-SomMotB-Measures.tsv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt

# #######################################################################################################
## NON-Motor MEASURE EXTRACTION ##

#Visual Network Regions (Figure 4): GluCEST Contrast
#touch $outputpath/GluCEST-s100-VisualNetwork-Measures.tsv
printf "Subject\tVisual_CEST_mean\tVisual_CEST_numvoxels\tVisual_CEST_SD\n" >> $outputpath/GluCEST-s100-VisualNetwork-Measures.tsv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific tsv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-VisualAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-VisualNetwork-GluCEST-measures.tsv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-VisualNetwork-GluCEST-measures.tsv
cut -f2-3 --complement $outputpath/$case/$case-s100-VisualNetwork-GluCEST-measures.tsv >> $outputpath/$case/tmp.tsv
mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-s100-VisualNetwork-GluCEST-measures.tsv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-VisualNetwork-GluCEST-measures.tsv >> $outputpath/GluCEST-s100-VisualNetwork-Measures.tsv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt

#All Non-Motor Brain Regions (Figure 4): GluCEST Contrast
#touch $outputpath/GluCEST-s100-NonMotor-Measures.tsv
printf "Subject\tNonMotor_CEST_mean\tNonMotor_CEST_numvoxels\tNonMotor_CEST_SD\n" >> $outputpath/GluCEST-s100-NonMotor-Measures.tsv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific tsv
3dROIstats -mask $cest/$case/atlases/$case-2d-s100-NonMotor.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.tsv
sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.tsv
cut -f2-3 --complement $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.tsv >> $outputpath/$case/tmp.tsv
mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.tsv
#enter participant GluCEST contrast data into master spreadsheet
sed -n "2p" $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.tsv >> $outputpath/GluCEST-s100-NonMotor-Measures.tsv
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt


# #######################################################################################################
# # Sensitivity Analysis ##
#
# #Motor Atlas 50% Overlap Map (Sensitivity Analysis): GluCEST Contrast
# #NEED TO RUN HEATMAP SCRIPT FIRST
# #touch $outputpath/GluCEST-ho-MotorNetwork-Heatmap50-Measures.tsv
# printf "Subject\tMotorNetwork_50_CEST_mean\tMotorNetwork_50_CEST_numvoxels\tMotorNetwork_50_CEST_SD\n" >> $outputpath/GluCEST-ho-MotorNetwork-Heatmap50-Measures.tsv
# while read line
# do
# case=$line
# #quantify GluCEST contrast for each participant & format participant-specific tsv
# 3dROIstats -mask $cest2/$case/atlases/$case-2d-ho-MotorAtlas-50%Heatmap.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-Heatmap50-GluCEST-measures.tsv
# #format participant-specific tsv
# sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-Heatmap50-GluCEST-measures.tsv
# cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-Heatmap50-GluCEST-measures.tsv >> $outputpath/$case/tmp.tsv
# mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-ho-MotorNetwork-Heatmap50-GluCEST-measures.tsv
# #enter participant GluCEST contrast data into master spreadsheet
# sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-Heatmap50-GluCEST-measures.tsv >> $outputpath/GluCEST-ho-MotorNetwork-Heatmap50-Measures.tsv
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
# #######################################################################################################
# # Sensitivity Analysis ##
#
# #Motor Atlas 50% Overlap Map (Sensitivity Analysis): GluCEST Contrast
# #NEED TO RUN HEATMAP SCRIPT FIRST
# #touch $outputpath/GluCEST-s100-MotorNetwork-Heatmap50-Measures.tsv
# printf "Subject\tMotorNetwork_50_CEST_mean\tMotorNetwork_50_CEST_numvoxels\tMotorNetwork_50_CEST_SD\n" >> $outputpath/GluCEST-s100-MotorNetwork-Heatmap50-Measures.tsv
# while read line
# do
# case=$line
# #quantify GluCEST contrast for each participant & format participant-specific tsv
# 3dROIstats -mask $cest2/$case/atlases/$case-2d-s100-MotorAtlas-50%Heatmap.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-MotorNetwork-Heatmap50-GluCEST-measures.tsv
# #format participant-specific tsv
# sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-MotorNetwork-Heatmap50-GluCEST-measures.tsv
# cut -f2-3 --complement $outputpath/$case/$case-s100-MotorNetwork-Heatmap50-GluCEST-measures.tsv >> $outputpath/$case/tmp.tsv
# mv $outputpath/$case/tmp.tsv $outputpath/$case/$case-s100-MotorNetwork-Heatmap50-GluCEST-measures.tsv
# #enter participant GluCEST contrast data into master spreadsheet
# sed -n "2p" $outputpath/$case/$case-s100-MotorNetwork-Heatmap50-GluCEST-measures.tsv >> $outputpath/GluCEST-s100-MotorNetwork-Heatmap50-Measures.tsv
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
# #######################################################################################################
