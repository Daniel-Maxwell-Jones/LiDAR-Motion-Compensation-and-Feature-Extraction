%{
This is the script used to validate the motion compensation aspect of the
algorithm 
%}

addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\Data\Dynamic_data');
addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions')
load('2023-09-25-13-06-56.mat')
[t_PointCloud,manyPtClouds,ptCloudMess] = ptCloudCell('2023-09-25-13-06-56.bag',50,10,1);
t_IMU = timeOmegaY-timeOmegaY(1);

t_PointCloud = t_PointCloud - t_PointCloud(1);

angX = cumtrapz(t_IMU,omegaX);
angX = rad2deg(angX);

angY = cumtrapz(t_IMU,omegaY);
angY = rad2deg(angY);

angZ = cumtrapz(t_IMU,omegaZ);
angZ = rad2deg(angZ);

angles = [angX angY angZ];








figure
pcshow(ptCloudMess,"MarkerSize",20)

ptCloudICP = ICP_IMU_Compensation(manyPtClouds,t_PointCloud,angles,t_IMU,1,10);

%ptCloudICP = ICPCompensation(manyPtClouds,1,10);

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
