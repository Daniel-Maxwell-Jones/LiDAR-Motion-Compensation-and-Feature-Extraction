function tform = IMUCompensation(ptT1, ptT2, IMU, t_IMU)


    
    imu1Index = find(t_IMU<=ptT1);
    imu1Index = imu1Index(end);
    imu2Index = find(t_IMU<=ptT2);
    imu2Index = imu2Index(end);
    
    imu1 = IMU(imu1Index,:);
    imu2 = IMU(imu2Index,:);
    
    imuDiff = imu2 - imu1;
    
    tform = rigidtform3d(imuDiff,[0 0 0]);


end