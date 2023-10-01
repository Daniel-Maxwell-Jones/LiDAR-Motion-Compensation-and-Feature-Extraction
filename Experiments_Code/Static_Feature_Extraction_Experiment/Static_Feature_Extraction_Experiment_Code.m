
%This is the script used to validate the feature extraction component of the algorithm from static reference frames 
%Author: Daniel Jones
%Date: 29th September 2023

addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions')
addpath("C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\Data\Static_Data")


[timeStamps, manyPtClouds, ptCloudMess] = ptCloudCell("2023-09-12-11-47-32.bag",1,20,1);

ptCloudICP = ICPCompensation(manyPtClouds,1,10);

%Reducing area of interest by inspection
roi = [0,5,-2,2,-inf,1];

indices = findPointsInROI(ptCloudICP,roi);

ptCloudICP = select(ptCloudICP,indices);


[labelsOut, segmentedPtCloud]= getClusters(ptCloudICP);

userLabel = 1;

while userLabel ~= 0


    userLabel = input('Enter the number of the object: ');
    
    if userLabel == 0 
        break;
    end
    [dims, confidence] = getRectPrismV2(segmentedPtCloud,20,labelsOut,userLabel);

   sprintf("Confidence: %2f",confidence)

end
