numFrames = 20;
numNeighbors = 100;
threshold = 1;

frame1 = 10;
frame2 = 20;

addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\Data\Dynamic_data');
addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions')
load('2023-09-25-13-19-56.mat')
[t_PointCloud,manyPtClouds,ptCloudMess] = ptCloudCell('2023-09-25-13-19-56.bag',1, numFrames, 1);
t_IMU = timeOmegaY-timeOmegaY(1);



t_PointCloud = t_PointCloud - t_PointCloud(1);

angX = cumtrapz(t_IMU,omegaX);
angX = rad2deg(angX);

angY = cumtrapz(t_IMU,omegaY);
angY = rad2deg(angY);

angZ = cumtrapz(t_IMU,omegaZ);
angZ = rad2deg(angZ);

angles = [angX angY angZ];


velX = cumtrapz(t_IMU,accX);
posX = cumtrapz(t_IMU,velX);

velY = cumtrapz(t_IMU,accY);
posY = cumtrapz(t_IMU,velY);

velZ = cumtrapz(t_IMU,accZ);
posZ = cumtrapz(t_IMU,velZ);



tform = IMUCompensation(t_PointCloud(frame1),t_PointCloud(frame2),angles,t_IMU);
%tform = invert(tform);
figure
pcshowpair(manyPtClouds{frame1},manyPtClouds{frame2})

pt = pctransform(manyPtClouds{frame2},tform);
figure
pcshowpair(manyPtClouds{frame1},pt);

[tform,movingreg] = pcregistericp()