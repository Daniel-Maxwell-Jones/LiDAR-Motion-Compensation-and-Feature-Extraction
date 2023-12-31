addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions');
load('myFilter')
sampling_rate = 200;
amplitiude_Rot = 0.2;
amplitiude_Trans = 0;
duration = 10;
freq_Rot = 0.5;
freq_Trans = 0.1;
numNeighbors = 10;
threshold = 1;
% Specify the mean and standard deviation of the Gaussian noise
mean_noise = 0;        % Mean of the Gaussian noise
std_deviation = 0.1;   % Standard deviation of the Gaussian noise
                                                      
t_IMU = 0:1/sampling_rate:duration;


angularVelY = amplitiude_Rot*(2*pi*freq_Rot)*cos(2*pi*freq_Rot*t_IMU);

angularVelY = transpose(angularVelY);

angYTruth = amplitiude_Rot*sin(2*pi*freq_Rot*t_IMU);
angYTruth = transpose(angYTruth);

linearAccZ = -amplitiude_Trans*(2*pi*freq_Trans)^2*sin(2*pi*freq_Trans*t_IMU);
linearAccZ = transpose(linearAccZ);
linearVelZ = cumtrapz(t_IMU,linearAccZ);

linearPosZ = cumtrapz(t_IMU,linearVelZ);

linearPosZTruth = amplitiude_Trans*sin(2*pi*freq_Trans*t_IMU);
linearPosZTruth = transpose(linearPosZTruth);

% Generate Gaussian noise
noise_Rot = std_deviation * randn(size(angularVelY)) + mean_noise;

noise_Trans = std_deviation * randn(size(linearAccZ)) + mean_noise;

% Add the noise to the original data
%LinearAccelerationZ = LinearAccelerationZ + noise;

angularVelY = angularVelY + noise_Rot;
linearAccZ = linearAccZ + noise_Trans;
%{
figure
plot(t_IMU,angularVelY,LineWidth=3)
xlabel("time [s]")
ylabel("Angular velocity [rad/s]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');

figure
plot(t_IMU,linearAccZ,LineWidth=3)
xlabel("time [s]")
ylabel("Linear Acceleration [m/s^2]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%}
angY = cumtrapz(t_IMU,angularVelY);
angX = zeros(size(t_IMU,2),1);
angZ = zeros(size(t_IMU,2),1);
%{
figure
plot(t_IMU,angY,LineWidth=3)
xlabel("time [s]")
ylabel("Angular position [rad]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');

figure
plot(t_IMU,linearPosZ,LineWidth=3)
xlabel("time [s]")
ylabel("Linear Position [m]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%}
positions = [angX,angX,linearPosZTruth];

angles = [angX,angYTruth,angZ];
IMU = [angX,angY,angZ,angX,angX,linearPosZ];
IMU_Truth = [angles positions];
%angZInt = cumtrapz(t,angularVelZ);


%======================================================================
%Creating Scene

densities = [1000 800 2000 400 100];

error = [0 0.01 0.02 0.03 0.04];
rotations = [0 0 0; 0 0 30; 0 0 67; 0 0 21; 0 0 70];

translations = [1 0.3 0; 2 1 0; 1.5 1.5 0; 1 2.5 0; 0.4 2 0];


lengths = [0.1 0.3 0.4 0.3 0.2];
breadths = [0.2 0.1 0.4 0.5 0.5];
heights = [0.5 0.3 0.4 0.7 0.5];


ptCloud = cubeScene(lengths,breadths,heights,translations,rotations,densities,error);

[manyPtClouds, t_ptCloud] = createMotionFrames(ptCloud,positions,angles, t_IMU);
numFrames = 101;
player = pcplayer([0 5],[-5 5],[-2 4],AxesVisibility="off",MarkerSize=50);
i = 1;
while isOpen(player)
     
     ptCloud = manyPtClouds{i};
     view(player,ptCloud);


     if i == numFrames
        
         i = 1;

     else

        i = i + 1;
        
     end

     pause(0.08)
end 




%{
figure
pcshow(pccat([manyPtClouds{1}, manyPtClouds{3}, manyPtClouds{5}, manyPtClouds{7}, manyPtClouds{9}, manyPtClouds{11}, manyPtClouds{13}, manyPtClouds{15}, manyPtClouds{17}, manyPtClouds{19}]))
ax = gca;
ax.FontSize = 20;
set(ax, 'FontWeight', 'bold');
ax.LineWidth = 5; % Change this value to your desired line width

% Optionally, set other axis properties, such as labels, titles, etc.
xlabel('X-axis [m]');
ylabel('Y-axis [m]');
zlabel('Z-axis [m]');




%=========================================================================================

ptCloudICP = ICP_IMU_Compensation(manyPtClouds,t_ptCloud,IMU,t_IMU,1,10);
figure
pcshow(ptCloudICP,MarkerSize=50)
ax = gca;
ax.FontSize = 20;
ax.LineWidth = 5; % Change this value to your desired line width
set(ax, 'FontWeight', 'bold');

% Optionally, set other axis properties, such as labels, titles, etc.
xlabel('X-axis [m]');
ylabel('Y-axis [m]');
zlabel('Z-axis [m]');


[labelsOut, segmentedPtCloud]= getClusters(ptCloudICP,referenceVector=[0,0,0],minDistance=0.2,maxDistance=0.01);

userLabel = 1;

while userLabel ~= 0


    userLabel = input('Enter the number of the object: ');
    
    if userLabel == 0 
        break;
    end
    tic;
    [dims, confidence] = getRectPrismV2(segmentedPtCloud,numNeighbors,threshold,labelsOut,userLabel);
    
    sprintf("Confidence: %2f",confidence)
    gettingDimensions = toc;
    %t_total = gettingDimensions + gettingClusters;
    %{
    % Specify the Excel file path

    excelFilePath = 'Static_Experiment_Spreadsheet3.xlsx';

    % Load existing data from the Excel file
    try
        existingData = xlsread(excelFilePath);
    catch
        % If the file doesn't exist or is empty, create a new matrix
        existingData = [];
    end
    
    % Generate the new row of data (modify this part according to your data)
    newRowData = [numFrames, numNeighbors, threshold, confidence, t_total, dims(1), dims(2), dims(3)]; % Example data
    
    % Append the new row to the existing data
    updatedData = [existingData; newRowData];
    
    % Write the updated data back to the Excel file
    xlswrite(excelFilePath, updatedData);
    %}
end


%}

%}
%=================================================================================
%This function takes in a point clouds and simulates movement of the LiDAR
%sensor
function [rotatedPtClouds, t_ptCloud] = createMotionFrames(ptCloud, positions, angles, t_IMU)
        angles = angles*180/(pi);
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
 
function cubeOut = cubeGen(length,breadth, height, trans, rots,numPoints,error)
        
       
        %First create the top and the bottom
        %==========================================================================
        % Define the parameters of the plane
        planePoint = [length/2, breadth/2, 0];  % A point on the plane (center of the plane)
        planePoint2 = [length/2, breadth/2, height];
        

       
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


function cubeSceneOut = cubeScene(lengths, breadths, heights, translations, rotations, densities, errors)

        numPoints = 20000;
        length = 2.5;
        breadth = 3;
        

        for i = 1: size(translations,1)
            if i == 1
                
                cubeSceneOut = cubeGen(lengths(i), breadths(i), heights(i), translations(i,:),rotations(i,:), densities(i), errors(i));


            else
                cube = cubeGen(lengths(i), breadths(i), heights(i), translations(i,:), rotations(i,:), densities(i), errors(i));
            
                cubeSceneOut = pcmerge(cubeSceneOut, cube, 0.01);
            end
        end
                
        planePoint = [1.25, 1.5, 0];  % A point on the plane (center of the plane)
        randomX = planePoint(1) + (rand(numPoints, 1) - 0.5) * length;
        randomY = planePoint(2) + (rand(numPoints, 1) - 0.5) * breadth;
        randomZ = planePoint(3) * ones(numPoints, 1);  % Points are constrained to the plane

        ground = pointCloud([randomX, randomY, randomZ]);
        cubeSceneOut = pcmerge(ground,cubeSceneOut,0.01);



end
