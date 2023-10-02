
%{
This function takes in the time stamps between to point that one which to
register as well as a series on IMU data and their corresponding time
stamps. It then produces an affine transformation matrix based on the IMU
readings to return the second point cloud to the position of the first.
%}

function tform = IMUCompensation(ptT1, ptT2, IMU, t_IMU)


    %Find the IMU timestamps corresponding to the chosen point clouds
    imu1Index = find(t_IMU<=ptT1);
    imu1Index = imu1Index(end);
    imu2Index = find(t_IMU<=ptT2);
    imu2Index = imu2Index(end);
    
    imu1 = IMU(imu1Index,:);
    imu2 = IMU(imu2Index,:);
    
    %Obtain the difference between those IMU readings
    imuDiff = imu2 - imu1;
    
    tform = rigidtform3d(imuDiff,[0 0 0]);


end