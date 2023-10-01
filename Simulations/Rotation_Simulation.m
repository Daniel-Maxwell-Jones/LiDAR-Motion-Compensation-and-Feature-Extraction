addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions');
load('myFilter')
sampling_rate = 200;
amplitiude = 45;
duration = 10;
freq = 0.2;

% Specify the mean and standard deviation of the Gaussian noise
mean_noise = 0;        % Mean of the Gaussian noise
std_deviation = 0.1;   % Standard deviation of the Gaussian noise
                                                      
t_IMU = 0:1/sampling_rate:duration;


angularVelZ = amplitiude*(2*pi*freq)*cos(2*pi*freq*t_IMU);

angularVelZ = transpose(angularVelZ);

% Generate Gaussian noise
noise = std_deviation * randn(size(angularVelZ)) + mean_noise;

% Add the noise to the original data
%LinearAccelerationZ = LinearAccelerationZ + noise;

angY = amplitiude*sin(2*pi*freq*t_IMU);
angY = transpose(angY);
angX = zeros(size(t_IMU,2),1);
angZ = zeros(size(t_IMU,2),1);



positions = [angX,angX,angX]; %All zeros

angles = [angX,angY,angZ];

%angZInt = cumtrapz(t,angularVelZ);


%======================================================================
%Creating Scene
rotations = [0 0 0; 0 0 30; 0 0 67; 0 0 21; 0 0 70];

translations = [1.5 0.5 0; 0.3 0.2 0; 1 1.5 0; 0.1 2.5 0; 2 2 0];


lengths = [0.2 0.3 0.1 0.5 0.4];
breadths = [0.3 0.2 0.4 0.2 0.5];
heights = [0.5 0.3 0.3 0.2 0.1];


ptCloud = cubeScene(lengths,breadths,heights,translations,rotations);

[manyPtClouds, t_ptCloud] = createMotionFrames(ptCloud,positions,angles, t_IMU);

%=========================================================================================

frame1 = 1;

frame2 = 2;

figure
pcshow(manyPtClouds{1})

hold on

pcshow(manyPtClouds{2})

%Get the IMU positions related to the two point cloud frames

imu1 = angles(find(t_IMU == t_ptCloud(frame1)),:);

imu2 = angles(find(t_IMU == t_ptCloud(frame2)),:);

imuDiff = imu2-imu1;

tform = rigidtform3d(imuDiff,[0 0 0]);
invtform = invert(tform);
ptCloudRotated = pctransform(manyPtClouds{frame2},invtform);




figure

pcshowpair(ptCloudRotated,manyPtClouds{frame1})







%=================================================================================
%This function takes in a point clouds and simulates movement of the LiDAR
%sensor
function [rotatedPtClouds, t_ptCloud] = createMotionFrames(ptCloud, positions, angles, t_IMU)
       
        rotatedPtClouds{1} = ptCloud;
        j = 2;
        t_ptCloud(1) = t_IMU(1);
        for i = 2:size(positions,1)
            
            if mod(i,20) == 0
                
                tform = rigidtform3d(angles(i,:),positions(i,:));
                rotatedPtClouds{j} = pctransform(ptCloud,tform);
                t_ptCloud(j) = t_IMU(i);
                j = j + 1;
            end
        end


end
 

function cubeOut = cubeGen(length,breadth, height, trans, rots)
        error = 0.02;
       
        %First create the top and the bottom
        %==========================================================================
        % Define the parameters of the plane
        planePoint = [length/2, breadth/2, 0];  % A point on the plane (center of the plane)
        planePoint2 = [length/2, breadth/2, height];
        
        % Define the number of random points you want to generate
        numPoints = 1000;
        
        % Generate random coordinates within the specified plane
        randomX = planePoint(1) + (rand(numPoints, 1) - 0.5) * length;
        randomY = planePoint(2) + (rand(numPoints, 1) - 0.5) * breadth;
        randomZ = planePoint(3) * ones(numPoints, 1);  % Points are constrained to the plane
       

        randomX2 = planePoint2(1) + (rand(numPoints, 1) - 0.5) * length;
        randomY2 = planePoint2(2) + (rand(numPoints, 1) - 0.5) * breadth;
        randomZ2 = planePoint2(3) * ones(numPoints, 1);  % Points are constrained to the plane
        randomZ2 = randomZ2 + error*(-1+2*rand(size(randomZ)));
        % Create a point cloud object from the random coordinates


        bottom = pointCloud([randomX, randomY, randomZ]);

        top = pointCloud([randomX2, randomY2, randomZ2]);

        cubeOut = pcmerge(top,bottom,0.01);

        %==========================================================================

        % Define the parameters of the plane
        planePoint3 = [length/2, 0, height/2];  % A point on the plane (center of the plane)
        planePoint4 = [length/2, breadth, height/2];
        
        % Define the number of random points you want to generate
        numPoints = 1000;
        
        % Generate random coordinates within the specified plane
        randomX3 = planePoint3(1) + (rand(numPoints, 1) - 0.5) * length;
        randomY3 =  planePoint3(2) * ones(numPoints, 1);  % Points are constrained to the plane
        randomZ3 = planePoint3(3) + (rand(numPoints, 1) - 0.5) * height;
        randomY3 = randomY3 + error*(-1+2*rand(size(randomY3)));

        randomX4 = planePoint4(1) + (rand(numPoints, 1) - 0.5) * length;
        randomY4 =  planePoint4(2) * ones(numPoints, 1);  % Points are constrained to the plane
        randomZ4 = planePoint4(3) + (rand(numPoints, 1) - 0.5) * height;
        randomY4 = randomY4 + error*(-1+2*rand(size(randomY4)));
        % Create a point cloud object from the random coordinates


        side1 = pointCloud([randomX3, randomY3, randomZ3]);

        side2 = pointCloud([randomX4, randomY4, randomZ4]);
        
        sidemerge = pcmerge(side1,side2,0.01);
        cubeOut = pcmerge(cubeOut,sidemerge,0.01);

        %==========================================================================
        % Define the parameters of the plane
        planePoint5 = [0, breadth/2, height/2];  % A point on the plane (center of the plane)
        planePoint6 = [length, breadth/2, height/2];
        
        % Define the number of random points you want to generate
        numPoints = 1000;
        
        % Generate random coordinates within the specified plane
        randomX5 = planePoint5(1) * ones(numPoints, 1);
        randomY5 =  planePoint5(2) + (rand(numPoints, 1) - 0.5) * breadth;  % Points are constrained to the plane
        randomZ5 = planePoint5(3) + (rand(numPoints, 1) - 0.5) * height;
        randomX5 = randomX5 + error*(-1+2*rand(size(randomX5)));

        randomX6 = planePoint6(1) * ones(numPoints, 1);
        randomY6 = planePoint6(2) + (rand(numPoints, 1) - 0.5) * breadth;   % Points are constrained to the plane
        randomZ6 = planePoint6(3) + (rand(numPoints, 1) - 0.5) * height;
        randomX6 = randomX6 + error*(-1+2*rand(size(randomX6)));
        % Create a point cloud object from the random coordinates


        side3 = pointCloud([randomX5, randomY5, randomZ5]);

        side4 = pointCloud([randomX6, randomY6, randomZ6]);
        
        sidemerge2 = pcmerge(side3,side4,0.01);

        
        cubeOut = pcmerge(cubeOut,sidemerge2,0.01);



        tform = rigidtform3d(rots,trans);

        cubeOut = pctransform(cubeOut,tform);
        



end


function cubeSceneOut = cubeScene(lengths, breadths, heights, translations, rotations)



        for i = 1: size(translations,1)
            if i == 1
                
                cubeSceneOut = cubeGen(lengths(i), breadths(i), heights(i), translations(i,:),rotations(i,:));


            else
                cube = cubeGen(lengths(i), breadths(i), heights(i), translations(i,:), rotations(i,:));
            
                cubeSceneOut = pcmerge(cubeSceneOut, cube, 0.01);
            end
        end

end

