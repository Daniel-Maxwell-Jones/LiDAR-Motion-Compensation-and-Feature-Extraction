
%This is the script used to validate the feature extraction component of the algorithm from static reference frames 
%Author: Daniel Jones
%Date: 29th September 2023

addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions')
addpath("C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\Data\Range_Data")


[timeStamps, manyPtClouds, ptCloudMess] = ptCloudCell("2023-09-27-10-10-22.bag",1,15,1);

figure
pcshow(ptCloudMess)

ptCloudICP = ICPCompensation(manyPtClouds,1,15);

%Reducing area of interest by inspection
%{
roi = [-1,5,-2,2,-inf,1];

indices = findPointsInROI(ptCloudICP,roi);

ptCloudICP = select(ptCloudICP,indices);

%}

[labelsOut, segmentedPtCloud]= getClusters(ptCloudICP);

userLabel = 1;

while userLabel ~= 0


    userLabel = input('Enter the number of the object: ');
    
    if userLabel == 0 
        break;
    end
    [dims, confidence] = getRectPrismV2(segmentedPtCloud,100,labelsOut,userLabel);

   sprintf("Confidence: %2f",confidence)

end
