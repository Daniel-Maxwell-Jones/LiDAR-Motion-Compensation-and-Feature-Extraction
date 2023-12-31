%{
This function is used to format the IMU data in the desired way to be used
be the other functions. It also stores the IMU data in a .mat file to save
on code run speed.
%}
%Author: Daniel Jones
%Date: 2nd October 2023

bag = rosbag('2023-09-25-13-27-08.bag');

msgs = select(bag, 'Topic', 'livox/imu');

length = msgs.NumMessages;

omegaZ = zeros(length,1);
omegaY = zeros(length,1);
omegaX = zeros(length,1);

accX = zeros(1,length);
accY = zeros(1,length);
accZ = zeros(1,length);

time = zeros(length,1);

%Obtaining accelerations, angular velocites and time stamps and storing it
%in a separate file.

for i = 1:length
    
    IMUReading = readMessages(msgs,i);
    
    omegaX(i) = IMUReading{1}.AngularVelocity.X;
    omegaY(i) = IMUReading{1}.AngularVelocity.Y;
    omegaZ(i) = IMUReading{1}.AngularVelocity.Z;

    accX(i) = IMUReading{1}.LinearAcceleration.X;
    accY(i) = IMUReading{1}.LinearAcceleration.Y;
    accZ(i) = IMUReading{1}.LinearAcceleration.Z;
    
    time(i) = IMUReading{1}.Header.Stamp.Sec + IMUReading{1}.Header.Stamp.Nsec * 1e-9;

end


save('2023-09-25-13-27-08.mat', 'timeO','accX','accY','accZ','omegaX','omegaY','omegaZ');