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
## Harvard-Oxford Total NETWORK MEASURE EXTRACTION - CEST and GMDensity ##

## Motor Network (Figure 2A): GluCEST Contrast

## s100 Motor Network (Figure XX): GluCEST Contrast
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
touch $outputpath/GluCEST-ho-MotorNetwork-M1-Measures.csv
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
touch $outputpath/GluCEST-ho-MotorNetwork-SMA-Measures.csv
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

## NOTE! Change SomMotA and B back to $case-2d-s100-MotorAtlas-SomMotA.nii.gz once it's changed in cest script
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



# #quantify GluCEST contrast for each participant & format participant-specific csv
# # -zerofill -for ROI labels not found, put NaN in output file instead of 0
# # -nomeanout - don't print out mean column; -nzmean&sigma - only use non-zero voxels to calc mean and SD;
# # -nobriklab - don't label subbricks next to index; 1DRformat - use 1D format, which is useful for R functions
# 3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv
# # Content of output:
# # name NZMean_1	NZcount_1	NZSigma_1
# # [$cest]/19970_10827]/19970_10827-GluCEST.nii.gz_0	6.847285	1042	3.042253
#
# #format participant-specific csv
# #   sed -i = edit files in place (makes backup if SUFFIX supplied)
# sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv
# # Content of output:
# # Subject NZMean_1	NZcount_1	NZSigma_1
# # [$cest]/19970_10827]/19970_10827-GluCEST.nii.gz_0	6.847285	1042	3.042253
#
# #   cut: Prints selected parts of lines from each FILE to standard output.
# #   -f = fields selection; also print any line that contains no delimiter character, unless the -s option is specified
# #   complement the set of selected bytes, chars, or fields
# cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
# # Content of output: ...should this be different?
# # Subject NZMean_1	NZcount_1	NZSigma_1
# # [$cest]/19970_10827]/19970_10827-GluCEST.nii.gz_0	6.847285	1042	3.042253
# mv $outputpath/$case/tmp.csv $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv
# #enter participant GluCEST contrast data into master spreadsheet
# #  sed -n suppresses standard output (output for every line); only designated lines explicitly selected are selected for output
# sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv >> $outputpath/GluCEST-ho-MotorNetwork-Measures.csv
# # headers: SubjectMotorNetwork_CEST_meanMotorNetwork_CEST_numvoxelsMotorNetwork_CEST_SD
# # when running one subj at a time w/o while loop, also adds headers again, but will be fixed when running all subj at once
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt


#######################################################################################################
## Sensitivity Analysis ##
#
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
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
#######################################################################################################
## NON-Motor MEASURE EXTRACTION ##

# for atlas in -2d-VisualAtlas-TotalNetwork.nii.gz -2d-ho-NonMotor.nii.gz
# can iterate through the
# #Visual Network Regions (Figure 4): GluCEST Contrast
# touch $outputpath/GluCEST-ho-VisualNetwork-Measures.csv
# echo "Subject	NonMotor_CEST_mean	NonMotor_CEST_numvoxels	NonMotor_CEST_SD" >> $outputpath/GluCEST-ho-VisualNetwork-Measures.csv
# while read line
# do
# case=$line
# #quantify GluCEST contrast for each participant & format participant-specific csv
# 3dROIstats -mask $cest/$case/atlases/$case-2d-VisualAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.csv
# sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.csv
# cut -f2-3 --complement $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
# mv $outputpath/$case/tmp.csv $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.csv
# #enter participant GluCEST contrast data into master spreadsheet
# sed -n "2p" $outputpath/$case/$case-ho-VisualNetwork-GluCEST-measures.csv >> $outputpath/GluCEST-ho-VisualNetwork-Measures.csv
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt


# #######################################################################################################
# ## Schaefer100 Atlas
#
# for atlas in ho s100
# do
# #s100 Motor Network (Figure XX): GluCEST Contrast
# touch $outputpath/GluCEST-$atlas-MotorNetwork-Measures.csv
# echo "Subject	MotorNetwork_CEST_mean MotorNetwork_CEST_numvoxels	MotorNetwork_CEST_SD" >> $outputpath/GluCEST-$atlas-MotorNetwork-Measures.csv
# while read line
# do
# case=$line
# #quantify GluCEST contrast for each participant & format participant-specific csv
# 3dROIstats -mask $cest/$case/atlases/$case-2d-$atlas-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-$atlas-GluCEST.nii.gz >> $outputpath/$case/$case-$atlas-MotorNetwork-GluCEST-measures.csv
# sed -i 's/name/Subject/g' $outputpath/$case/$case-$atlas-MotorNetwork-GluCEST-measures.csv
# cut -f2-3 --complement $outputpath/$case/$case-$atlas-MotorNetwork-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
# mv $outputpath/$case/tmp.csv $outputpath/$case/$case-$atlas-MotorNetwork-GluCEST-measures.csv
# #enter participant GluCEST contrast data into master spreadsheet
# sed -n "2p" $outputpath/$case/$case-$atlas-MotorNetwork-GluCEST-measures.csv >> $outputpath/GluCEST-$atlas-MotorNetwork-Measures.csv
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
# done

#
#
# #s100 Motor Network (Figure XX): Gray Matter Density
# touch $outputpath/GMDensity-s100-MotorNetwork-Measures.csv
# echo "Subject	MotorNetwork_GMDensity_mean	MotorNetwork_GMDensity_numvoxels	MotorNetwork_GMDensity_SD" >> $outputpath/GMDensity-s100-MotorNetwork-Measures.csv
# while read line
# do
# case=$line
# #quantify GM density for each participant & format participant-specific csv
# 3dROIstats -mask $cest/$case/atlases/$case-2d-s100-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/fast/$case-2d-FASTGMprob.nii.gz >> $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.csv
# sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.csv
# cut -f2-3 --complement $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.csv >> $outputpath/$case/tmp.csv
# mv $outputpath/$case/tmp.csv $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.csv
# #enter participant GM density data into master spreadsheet
# sed -n "2p" $outputpath/$case/$case-s100-MotorNetwork-GMDensity-measures.csv >> $outputpath/GMDensity-s100-MotorNetwork-Measures.csv
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
#

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
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
#######################################################################################################
## NON-Motor MEASURE EXTRACTION ##


# # #All Non-Motor Brain Regions (Figure 4): GluCEST Contrast
# touch $outputpath/GluCEST-s100-NonMotor-Measures.csv
# echo "Subject	NonMotor_CEST_mean	NonMotor_CEST_numvoxels	NonMotor_CEST_SD" >> $outputpath/GluCEST-s100-NonMotor-Measures.csv
# while read line
# do
# case=$line
# #quantify GluCEST contrast for each participant & format participant-specific csv
# 3dROIstats -mask $cest/$case/atlases/$case-2d-s100-NonMotor.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.csv
# sed -i 's/name/Subject/g' $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.csv
# cut -f2-3 --complement $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
# mv $outputpath/$case/tmp.csv $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.csv
# #enter participant GluCEST contrast data into master spreadsheet
# sed -n "2p" $outputpath/$case/$case-s100-NonMotor-GluCEST-measures.csv >> $outputpath/GluCEST-s100-NonMotor-Measures.csv
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
# # #######################################################################################################
# ## Motor NETWORK HARVARD OXFORD ANATOMICAL SUBREGIONS MEASURE EXTRACTION ##
#
# #delineate cortical Motor network anatomical regions with HO cortical atlas
# while read line
# do
# case=$line
# fslmaths $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii.gz -mul $cest/$case/atlases/$case-2d-HarvardOxford-cort.nii.gz $cest/$case/atlases/$case-2d-ho-MotorAtlas-HO-CorticalRegions.nii.gz
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
#
# #Motor Network Harvard Oxford Cortical Regions (Supplementary Figure S1): GluCEST Contrast
# touch $outputpath/GluCEST-HarvardOxford-Cortical-Motor-Measures.csv
# echo "Subject	Frontal_Pole_mean	Frontal_Pole_numvoxels	Frontal_Pole_SD	Insular_Cortex_mean	Insular_Cortex_numvoxels	Insular_Cortex_SD	SFG_mean	SFG_numvoxels	SFG_SD	MFG_mean	MFG_numvoxels	MFG_SD	IFG_parstriangularis_mean	IFG_parstriangularis_numvoxels	IFG_parstriangularis_SD	IFG_parsopercularis_mean	IFG_parsopercularis_numvoxels	IFG_parsopercularis_SD	Precentral_Gyrus_mean	Precentral_Gyrus_numvoxels	Precentral_Gyrus_SD	Temporal_Pole_mean	Temporal_Pole_numvoxels	Temporal_Pole_SD	Superior_Temporal_Gyrus_ant_mean	Superior_Temporal_Gyrus_ant_numvoxels	Superior_Temporal_Gyrus_ant_SD	Superior_Temporal_Gyrus_post_mean	Superior_Temporal_Gyrus_post_numvoxels	Superior_Temporal_Gyrus_post_SD	Middle_Temporal_Gyrus_ant_mean	Middle_Temporal_Gyrus_ant_numvoxels	Middle_Temporal_Gyrus_ant_SD	Middle_Temporal_Gyrus_post_mean	Middle_Temporal_Gyrus_post_numvoxels	Middle_Temporal_Gyrus_post_SD	Middle_Temporal_Gyrus_temporoocc_mean	Middle_Temporal_Gyrus_temporoocc_numvoxels	Middle_Temporal_Gyrus_temporoocc_SD	Inferior_Temporal_Gyrus_ant_mean	Inferior_Temporal_Gyrus_ant_numvoxels	Inferior_Temporal_Gyrus_ant_SD	Inferior_Temporal_Gyrus_post_mean	Inferior_Temporal_Gyrus_post_numvoxels	Inferior_Temporal_Gyrus_post_SD	Inferior_Temporal_Gyrus_temporocc_mean	Inferior_Temporal_Gyrus_temporocc_numvoxels	Inferior_Temporal_Gyrus_temporocc_SD	Postcentral_Gyrus_mean	Postcentral_Gyrus_numvoxels	Postcentral_Gyrus_SD	Superior_Parietal_Lobule_mean	Superior_Parietal_Lobule_numvoxels	Superior_Parietal_Lobule_SD	Supramarginal_Gyrus_ant_mean	Supramarginal_Gyrus_ant_numvoxels	Supramarginal_Gyrus_ant_SD	Supramarginal_Gyrus_post_mean	Supramarginal_Gyrus_post_numvoxels	Supramarginal_Gyrus_post_SD	Angular_Gyrus_mean	Angular_Gyrus_numvoxels	Angular_Gyrus_SD	Lateral_Occipital_Cortex_sup_mean	Lateral_Occipital_Cortex_sup_numvoxels	Lateral_Occipital_Cortex_sup_SD	Lateral_Occipital_Cortex_inf_mean	Lateral_Occipital_Cortex_inf_numvoxels	Lateral_Occipital_Cortex_inf_SD	Intracalcarine_Cortex_mean	Intracalcarine_Cortex_numvoxels	Intracalcarine_Cortex_SD	Frontal_Medial_Cortex_mean	Frontal_Medial_Cortex_numvoxels	Frontal_Medial_Cortex_SD	Juxtapositional_Lobule_Cortex_mean	Juxtapositional_Lobule_Cortex_numvoxels	Juxtapositional_Lobule_Cortex_SD	Subcallosal_Cortex_mean	Subcallosal_Cortex_numvoxels	Subcallosal_Cortex_SD	Paracingulate_Gyrus_mean	Paracingulate_Gyrus_numvoxels	Paracingulate_Gyrus_SD	Anterior_cingulate_mean	Anterior_cingulate_numvoxels	Anterior_cingulate_SD	Posterior_cingulate_mean	Posterior_cingulate_numvoxels	Posterior_cingulate_SD	Precuneous_Cortex_mean	Precuneous_Cortex_numvoxels	Precuneous_Cortex_SD	Cuneal_Cortex_mean	Cuneal_Cortex_numvoxels	Cuneal_Cortex_SD	OFC_mean	OFC_numvoxels	OFC_SD	Parahippocampal_Gyrus_ant_mean	Parahippocampal_Gyrus_ant_numvoxels	Parahippocampal_Gyrus_ant_SD	Parahippocampal_Gyrus_post_mean	Parahippocampal_Gyrus_post_numvoxels	Parahippocampal_Gyrus_post_SD	Lingual_Gyrus_mean	Lingual_Gyrus_numvoxels	Lingual_Gyrus_SD	Temporal_Fusiform_Cortex_ant_mean	Temporal_Fusiform_Cortex_ant_numvoxels	Temporal_Fusiform_Cortex_ant_SD	Temporal_Fusiform_Cortex_post_mean	Temporal_Fusiform_Cortex_post_numvoxels	Temporal_Fusiform_Cortex_post_SD	Temporal_Occipital_Fusiform_Cortex_mean	Temporal_Occipital_Fusiform_Cortex_numvoxels	Temporal_Occipital_Fusiform_Cortex_SD	Occipital_Fusiform_Gyrus_mean	Occipital_Fusiform_Gyrus_numvoxels	Occipital_Fusiform_Gyrus_SD	Frontal_Operculum_Cortex_mean	Frontal_Operculum_Cortex_numvoxels	Frontal_Operculum_Cortex_SD	Central_Opercular_Cortex_mean	Central_Opercular_Cortex_numvoxels	Central_Opercular_Cortex_SD	Parietal_Operculum_Cortex_mean	Parietal_Operculum_Cortex_numvoxels	Parietal_Operculum_Cortex_SD	Planum_Polare_mean	Planum_Polare_numvoxels	Planum_Polare_SD	Heschls_Gyrus_mean	Heschls_Gyrus_numvoxels	Heschls_Gyrus_SD	Planum_Temporale_mean	Planum_Temporale_numvoxels	Planum_Temporale_SD	Supracalcarine_Cortex_mean	Supracalcarine_Cortex_numvoxels	Supracalcarine_Cortex_SD	Occipital_Pole_mean	Occipital_Pole_numvoxels	Occipital_Pole_SD" >> $outputpath/GluCEST-HarvardOxford-Cortical-Motor-Measures.csv
# while read line
# do
# case=$line
# #quantify GluCEST contrast for each participant & format participant-specific csv
# 3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-HO-CorticalRegions.nii.gz -numROI 48 -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-HarvardOxford-Cortical-Motor-GluCEST-measures.csv
# #format participant-specific csv
# sed -i 's/name/Subject/g' $outputpath/$case/$case-HarvardOxford-Cortical-Motor-GluCEST-measures.csv
# cut -f2-3 --complement $outputpath/$case/$case-HarvardOxford-Cortical-Motor-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
# mv $outputpath/$case/tmp.csv $outputpath/$case/$case-HarvardOxford-Cortical-Motor-GluCEST-measures.csv
# #enter participant GluCEST contrast data into master spreadsheet
# sed -n "2p" $outputpath/$case/$case-HarvardOxford-Cortical-Motor-GluCEST-measures.csv >> $outputpath/GluCEST-HarvardOxford-Cortical-Motor-Measures.csv
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
#
# #delineate subcortical Motor network anatomical regions with HO subcortical atlas
# while read line
# do
# case=$line
# fslmaths $cest/$case/atlases/$case-2d-ho-MotorAtlas-SubCortical.nii.gz -mul $cest/$case/atlases/$case-2d-HarvardOxford-sub.nii.gz $cest/$case/atlases/$case-2d-ho-MotorAtlas-HO-SubCorticalRegions.nii.gz
# fslmaths $cest/$case/atlases/$case-2d-ho-MotorAtlas-HO-SubCorticalRegions.nii.gz -bin $cest/$case/atlases/$case-2d-ho-MotorAtlas-HO-SubCorticalRegions-bin.nii.gz
# fslmaths $cest/$case/atlases/$case-2d-ho-MotorAtlas-SubCortical.nii.gz -sub $cest/$case/atlases/$case-2d-ho-MotorAtlas-HO-SubCorticalRegions-bin.nii.gz $cest/$case/atlases/$case-2d-ho-MotorAtlas-Subcortical-HO-unlabeled.nii.gz #create mask of Motor network midbrain/brainstem voxels that the Harvard Oxford subcortical atlas does not label
# fslmaths $cest/$case/atlases/$case-2d-ho-MotorAtlas-HO-SubCorticalRegions.nii.gz -add $cest/$case/atlases/$case-2d-ho-MotorAtlas-Subcortical-HO-unlabeled.nii.gz $cest/$case/atlases/$case-2d-ho-MotorAtlas-HO-SubCorticalRegions.nii.gz #Add unlabeled midbrain/brainstem voxels to Motor Network HO subcortical atlas
# rm $cest/$case/atlases/$case-2d-ho-MotorAtlas-HO-SubCorticalRegions-bin.nii.gz $cest/$case/atlases/$case-2d-ho-MotorAtlas-Subcortical-HO-unlabeled.nii.gz #remove intermediate files
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt
#
# #Motor Network Harvard Oxford Subcortical Regions (Supplementary Figure S1): GluCEST Contrast
# touch $outputpath/GluCEST-HarvardOxford-SubCortical-Motor-Measures.csv
# echo "Subject	Unlabeled_voxels_mean	Unlabeled_voxels_numvoxels	Unlabeled_voxels_SD	Left_Cerebral_Cortex_mean	Left_Cerebral_Cortex_numvoxels	Left_Cerebral_Cortex__SD	Left_Lateral_Ventrical_mean	Left_Lateral_Ventrical_numvoxels	Left_Lateral_Ventrical_SD	Left_Thalamus_mean	Left_Thalamus_numvoxels	Left_Thalamus_SD	Left_Caudate_mean	Left_Caudate_numvoxels	Left_Caudate_SD	Left_Putamen_mean	Left_Putamen_numvoxels	Left_Putamen_SD	Left_Pallidum_mean	Left_Pallidum_numvoxels	Left_Pallidum_SD	Brain-Stem_mean	Brain-Stem_numvoxels	Brain-Stem_SD	Left_Hippocampus_mean	Left_Hippocampus_numvoxels	Left_Hippocampus_SD	Left_Amygdala_mean	Left_Amygdala_numvoxels	Left_Amygdala_SD	Left_Accumbens_mean	Left_Accumbens_numvoxels	Left_Accumbens_SD	Right_Cerebral_White_Matter_mean	Right_Cerebral_White_Matter_numvoxels	Right_Cerebral_White_Matter_SD	Right_Cerebral_Cortex_mean	Right_Cerebral_Cortex_numvoxels	Right_Cerebral_Cortex_SD	Right_Lateral_Ventricle_mean	Right_Lateral_Ventricle_numvoxels	Right_Lateral_Ventricle_SD	Right_Thalamus_mean	Right_Thalamus_numvoxels	Right_Thalamus_SD	Right_Caudate_mean	Right_Caudate_numvoxels	Right_Caudate_SD	Right_Putamen_mean	Right_Putamen_numvoxels	Right_Putamen_SD	Right_Pallidum_mean	Right_Pallidum_numvoxels	Right_Pallidum_SD	Right_Hippocampus_mean	Right_Hippocampus_numvoxels	Right_Hippocampus_SD	Right_Amygdala_mean	Right_Amygdala_numvoxels	Right_Amygdala_SD	Right_Accumbens_mean	Right_Accumbens_numvoxels	Right_Accumbens_SD" >> $outputpath/GluCEST-HarvardOxford-SubCortical-Motor-Measures.csv
# while read line
# do
# case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
# 3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-HO-SubCorticalRegions.nii.gz -numROI 21 -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-HarvardOxford-SubCortical-Motor-GluCEST-measures.csv
# #format participant-specific csv
# sed -i 's/name/Subject/g' $outputpath/$case/$case-HarvardOxford-SubCortical-Motor-GluCEST-measures.csv
# cut -f2-3 --complement $outputpath/$case/$case-HarvardOxford-SubCortical-Motor-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
# mv $outputpath/$case/tmp.csv $outputpath/$case/$case-HarvardOxford-SubCortical-Motor-GluCEST-measures.csv
# #enter participant GluCEST contrast data into master spreadsheet
# sed -n "2p" $outputpath/$case/$case-HarvardOxford-SubCortical-Motor-GluCEST-measures.csv >> $outputpath/GluCEST-HarvardOxford-SubCortical-Motor-Measures.csv
# done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N3.txt




## Motor NETWORK MEASURE EXTRACTION ##

#Motor Network (Figure 2A): GluCEST Contrast
touch $outputpath/GluCEST-ho-MotorNetwork-Measures.csv
echo "Subject	MotorNetwork_CEST_mean	MotorNetwork_CEST_numvoxels	MotorNetwork_CEST_SD" >> $outputpath/GluCEST-ho-MotorNetwork-Measures.csv
while read line
do
case=$line
#quantify GluCEST contrast for each participant & format participant-specific csv
# -zerofill -for ROI labels not found, put NaN in output file instead of 0
# -nomeanout - don't print out mean column; -nzmean&sigma - only use non-zero voxels to calc mean and SD;
# -nobriklab - don't label subbricks next to index; 1DRformat - use 1D format, which is useful for R functions
3dROIstats -mask $cest/$case/atlases/$case-2d-ho-MotorAtlas-TotalNetwork.nii.gz -zerofill NaN -nomeanout -nzmean -nzsigma -nzvoxels -nobriklab -1DRformat $cest/$case/$case-GluCEST.nii.gz >> $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv
# Content of output:
# name NZMean_1	NZcount_1	NZSigma_1
# [$cest]/19970_10827]/19970_10827-GluCEST.nii.gz_0	6.847285	1042	3.042253

#format participant-specific csv
#   sed -i = edit files in place (makes backup if SUFFIX supplied)
sed -i 's/name/Subject/g' $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv
# Content of output:
# Subject NZMean_1	NZcount_1	NZSigma_1
# [$cest]/19970_10827]/19970_10827-GluCEST.nii.gz_0	6.847285	1042	3.042253

#   cut: Prints selected parts of lines from each FILE to standard output.
#   -f = fields selection; also print any line that contains no delimiter character, unless the -s option is specified
#   complement the set of selected bytes, chars, or fields
cut -f2-3 --complement $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv >> $outputpath/$case/tmp.csv
# Content of output: ...should this be different?
# Subject NZMean_1	NZcount_1	NZSigma_1
# [$cest]/19970_10827]/19970_10827-GluCEST.nii.gz_0	6.847285	1042	3.042253
mv $outputpath/$case/tmp.csv $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv
#enter participant GluCEST contrast data into master spreadsheet
#  sed -n suppresses standard output (output for every line); only designated lines explicitly selected are selected for output
sed -n "2p" $outputpath/$case/$case-ho-MotorNetwork-GluCEST-measures.csv >> $outputpath/GluCEST-ho-MotorNetwork-Measures.csv
# headers: SubjectMotorNetwork_CEST_meanMotorNetwork_CEST_numvoxelsMotorNetwork_CEST_SD
# when running one subj at a time w/o while loop, also adds headers again, but will be fixed when running all subj at once
done < /project/bbl_projects/MotorGluCEST/sandbox/GluCEST_Motor_Caselist_N46.txt
