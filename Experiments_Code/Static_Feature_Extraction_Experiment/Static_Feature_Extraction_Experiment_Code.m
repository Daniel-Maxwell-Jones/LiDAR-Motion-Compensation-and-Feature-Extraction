addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions')
addpath("C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\Data\Static_Data")
[manyPtClouds,ptCloudMess] = ptCloudCell("2023-09-12-11-47-32.bag",1,20,1);

ptCloudICP = ICPCompensation(manyPtClouds,1,10);

[labelsOut, segmentedPtCloud]= getClusters(ptCloudICP);

userLabel = 1;

while userLabel ~= 0


    userLabel = input('Enter the number of the object: ');
    
    if userLabel == 0 
        break;
    end
    getRectPrismV2(segmentedPtCloud,20,labelsOut,userLabel);

end
