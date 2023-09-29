addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\Data\Dynamic_data');
addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions')

[manyPtClouds,ptCloudMess] = ptCloudCell('2023-09-25-13-06-56.bag',50,10,1);

figure
pcshow(ptCloudMess,"MarkerSize",20)

ptCloudICP = ICPCompensation(manyPtClouds,1,10);

figure
pcshow(ptCloudICP,"MarkerSize",20);
xlabel("x-axis")
ylabel("y-axis")
zlabel("z-axis")



[labelsOut, segmentedPtCloud]= getClusters(ptCloudICP);

userLabel = 1;

while userLabel ~= 0


    userLabel = input('Enter the number of the object: ');
    
    if userLabel == 0 
        break;
    end
    getRectPrismV2(segmentedPtCloud,20,labelsOut,userLabel);

end
