bag = rosbag('2023-09-25-13-27-08.bag');

msgs = select(bag, 'Topic', 'livox/imu');

length = msgs.NumMessages;

omegaZ = zeros(length,1);
omegaY = zeros(length,1);
omegaX = zeros(length,1);

accX = zeros(1,length);
accY = zeros(1,length);
accZ = zeros(1,length);

timeOmegaY = zeros(length,1);

for i = 1:length
    
    IMUReading = readMessages(msgs,i);
    
    omegaX(i) = IMUReading{1}.AngularVelocity.X;
    omegaY(i) = IMUReading{1}.AngularVelocity.Y;
    omegaZ(i) = IMUReading{1}.AngularVelocity.Z;

    accX(i) = IMUReading{1}.LinearAcceleration.X;
    accY(i) = IMUReading{1}.LinearAcceleration.Y;
    accZ(i) = IMUReading{1}.LinearAcceleration.Z;
    
    timeOmegaY(i) = IMUReading{1}.Header.Stamp.Sec + IMUReading{1}.Header.Stamp.Nsec * 1e-9;

end


save('2023-09-25-13-27-08.mat', 'timeOmegaY','accX','accY','accZ','omegaX','omegaY','omegaZ');