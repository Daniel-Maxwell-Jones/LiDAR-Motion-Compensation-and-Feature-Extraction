
addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions')
numNeighbors = 500;

threshold = 1;

%===================================================
%Creating scene

%Densities of the point cloud objects
densities = [200 400 600 800 1000 1200 1400 1600 1800 2000 3000 4000 5000 6000 7000 8000 9000 11000 12000 13000];
%Error of the point cloud objects
error = [0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05];
%
rotations = [0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45; 0 0 45];
translations = [1 2 0; 2 2 0; 3 2 0; 4 2 0; 5 2 0; 6 2 0; 7 2 0; 8 2 0; 9 2 0; 10 2 0; 11 2 0; 12 2 0; 13 2 0; 14 2 0; 15 2 0; 16 2 0; 17 2 0; 18 2 0; 19 2 0; 20 2 0]; 
%{
lengths = [0.2 0.3 0.1 0.5 0.4];
breadths = [0.3 0.2 0.4 0.2 0.5];
heights = [0.5 0.3 0.3 0.2 0.1];
%}
lengths = [0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4];
breadths = [0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3];
heights = [0.3 0.3 0.3  0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3];


ptCloud = cubeScene(lengths,breadths,heights,translations,rotations,densities, error,6);
figure
pcshow(ptCloud)
ax = gca;

% Set the axis line width (make them thicker)
ax.LineWidth = 3; % Change this value to your desired line width

% Optionally, set other axis properties, such as labels, titles, etc.
xlabel('X-axis [m]');
ylabel('Y-axis [m]');
zlabel('Z-axis [m]');

%=======================================================================
tic;
[labelsOut, segmentedPtCloud]= getClusters(ptCloud,referenceVector=[0,0,0],minDistance=0.3,maxDistance=0.01);
gettingClusters = toc;
userLabel = 1;
k = 1;
b = zeros(20,1);
l = zeros(20,1);
h = zeros(20,1);
t = zeros(20,1);
c = zeros(20,1);

while userLabel < 21



    
    if userLabel == 0 
        break;
    end
    tic;
    [dims, confidence] = getRectPrismV2(segmentedPtCloud,numNeighbors,threshold,labelsOut,userLabel);
    
    sprintf("Confidence: %2f",confidence)
    gettingDimensions = toc;
    t_total = gettingDimensions + gettingClusters;
    %{
    % Specify the Excel file path

    excelFilePath = 'Static_Experiment_Simulation_lowFilt1.xlsx';

    % Load existing data from the Excel file
    try
        existingData = xlsread(excelFilePath);
    catch
        % If the file doesn't exist or is empty, create a new matrix
        existingData = [];
    end
    
    % Generate the new row of data (modify this part according to your data)
    newRowData = [densities(k), numNeighbors, threshold, confidence, t_total, dims(1), dims(2), dims(3)]; % Example data
    
    % Append the new row to the existing data
    updatedData = [existingData; newRowData];
    
    % Write the updated data back to the Excel file
    xlswrite(excelFilePath, updatedData);
    %}
    

    k = k + 1;
    userLabel = userLabel + 1;
    b(userLabel) = dims(1);
    l(userLabel) = dims(2);
    h(userLabel) = dims(3);
    c(userLabel) = confidence;
    t(userLabel) = t_total;
    
end
b_lowfilt = abs(b(2:end)-0.3)*100/0.3;
l_lowfilt = abs(l(2:end)-0.4)*100/0.4;
h_lowfilt = abs(h(2:end)-0.3)*100/0.3;
c_lowfilt = c;
t_lowfilt = t;



%save('Static_Simulation_Results_lowFilt.mat','b_lowfilt',"l_lowfilt","h_lowfilt","c_lowfilt","t_lowfilt")


figure
plot(densities,abs(b(2:end)-0.3)*100/0.3)

figure
plot(densities,abs(l(2:end)-0.4)*100/0.4)

figure
plot(densities,abs(h(2:end)-0.3)*100/0.3)
%}
%==========================================================================
%Functions
%==========================================================================

%This function generates a simulated point cloud object
function cubeOut = cubeGen(length,breadth, height, trans, rots,numPoints,error,noiseScale)
        % Parameters for the triangular distribution
        a = -1;  % Lower bound
        b = 0;  % Mode (peak)
        c = 1; % Upper bound

        triangular_dist = makedist('Triangular', 'a', a, 'b', b, 'c', c);
       
        %First create the top and the bottom
        %==========================================================================

        % Define the parameters of the plane
        planePoint = [length/2, breadth/2, 0];  % A point on the plane (center of the plane)
        planePoint2 = [length/2, breadth/2, height];
        

       
        % Generate random coordinates within the specified plane
        randomX = planePoint(1) + (rand(numPoints, 1) - 0.5) * length;
        randomY = planePoint(2) + (rand(numPoints, 1) - 0.5) * breadth;
        randomZ = planePoint(3) * ones(numPoints, 1);  % Points are constrained to the plane
       

        %randomX2 = planePoint2(1) + (rand(numPoints, 1) - 0.5) * length;
        randomX2 = 0.7*abs(random(triangular_dist,numPoints, 1) - 0.5) * length;
        noiseX2 = randomX2(1:noiseScale:end);
        noiseX2 = noiseX2 + error*(-1+2*rand(size(noiseX2)));
        

        randomY2 = planePoint2(2) + (rand(numPoints, 1) - 0.5) * breadth;
        noiseY2 = randomY2(1:noiseScale:end);
        noiseY2 = noiseY2 + error*(-1+2*rand(size(noiseY2)));
        

        randomZ2 = planePoint2(3) * ones(numPoints, 1);  % Points are constrained to the plane
        noiseZ2 = randomZ2(1:noiseScale:end);
        noiseZ2 = noiseZ2 + error*(-1+2*rand(size(noiseZ2)));
       
        % Create a point cloud object from the random coordinates


        bottom = pointCloud([randomX, randomY, randomZ]);

        top = pointCloud([randomX2, randomY2, randomZ2]);
        topNoise = pointCloud([noiseX2, noiseY2, noiseZ2]);
        
        %ptClouds = [bottom top topNoise];
        ptClouds = [top topNoise];

        cubeOut = pccat(ptClouds);

        %==========================================================================

        % Define the parameters of the plane
        planePoint3 = [length/2, 0, height/2];  % A point on the plane (center of the plane)
        planePoint4 = [length/2, breadth, height/2];
        
    
      
        
        % Generate random coordinates within the specified plane
        %randomX3 = planePoint3(1) + (rand(numPoints, 1) - 0.5) * length;
        randomX3 = 0.7*abs(random(triangular_dist,numPoints, 1) - 0.5) * length;
        
        noiseX3 = randomX3(1:noiseScale:end);
        noiseX3 = noiseX3 + error*(-1+2*rand(size(noiseX3)));
     

        randomY3 = planePoint3(2) * ones(numPoints, 1);  % Points are constrained to the plane
        noiseY3 = randomY3(1:noiseScale:end);
        noiseY3 = noiseY3 + error*(-1+2*rand(size(noiseY3)));
    

        randomZ3 = planePoint3(3) + (rand(numPoints, 1) - 0.5) * height;
        noiseZ3 = randomZ3(1:noiseScale:end);
        noiseZ3 = noiseZ3 + error*(-1+2*rand(size(noiseZ3)));
       
      

        %randomX4 = planePoint4(1) + (rand(numPoints, 1) - 0.5) * length;
        randomX4 = 0.7*abs(random(triangular_dist,numPoints, 1) - 0.5) * length;
        noiseX4 = randomX4(1:noiseScale:end);
        noiseX4 = noiseX4 + error*(-1+2*rand(size(noiseX4)));
   

        randomY4 =  planePoint4(2) * ones(numPoints, 1);  % Points are constrained to the plane
        noiseY4 = randomY4(1:noiseScale:end);
        noiseY4 = noiseY4 + error*(-1+2*rand(size(noiseY4)));
  

        randomZ4 = planePoint4(3) + (rand(numPoints, 1) - 0.5) * height;
        noiseZ4 = randomZ4(1:noiseScale:end);
        noiseZ4 = noiseZ4 + error*(-1+2*rand(size(noiseZ4)));
    

        % Create a point cloud object from the random coordinates


        side1 = pointCloud([randomX3, randomY3, randomZ3]);

        side1Noise1 = pointCloud([noiseX3,noiseY3,noiseZ3]);


        side2 = pointCloud([randomX4, randomY4, randomZ4]);

        side1Noise2 = pointCloud([noiseX4,noiseY4,noiseZ4]);
        
        %pointClouds = [side1, side1Noise1, side2, side1Noise2, cubeOut];
        pointClouds = [side1, side1Noise1, cubeOut];

        cubeOut = pccat(pointClouds);

        %==========================================================================
        % Define the parameters of the plane
        planePoint5 = [0, breadth/2, height/2];  % A point on the plane (center of the plane)
        planePoint6 = [length, breadth/2, height/2];
        
        % Define the number of random points you want to generate

        
        % Generate random coordinates within the specified plane
        randomX5 = planePoint5(1) * ones(numPoints, 1);
        noiseX5 = randomX5(1:noiseScale:end);
        noiseX5 = noiseX5 + error*(-1+2*rand(size(noiseX5)));
      

        randomY5 =  planePoint5(2) + (rand(numPoints, 1) - 0.5) * breadth;  % Points are constrained to the plane
        noiseY5 = randomY5(1:noiseScale:end);
        noiseY5 = noiseY5 + error*(-1+2*rand(size(noiseY5)));
     
        
        randomZ5 = planePoint5(3) + (rand(numPoints, 1) - 0.5) * height;
        noiseZ5 = randomZ5(1:noiseScale:end);
        noiseZ5 = noiseZ5 + error*(-1+2*rand(size(noiseZ5)));
      

        randomX6 = planePoint6(1) * ones(numPoints, 1);
        noiseX6 = randomX6(1:noiseScale:end);
        noiseX6 = noiseX6 + error*(-1+2*rand(size(noiseX6)));
      

        randomY6 = planePoint6(2) + (rand(numPoints, 1) - 0.5) * breadth;   % Points are constrained to the plane
        noiseY6 = randomY6(1:noiseScale:end);
        noiseY6 = noiseY6 + error*(-1+2*rand(size(noiseY6)));
       

        %randomZ6 = planePoint6(3) + (rand(numPoints, 1) - 0.5) * height;
        randomZ6 = 0.7*abs(random(triangular_dist,numPoints, 1) - 0.5) * height;
        noiseZ6 = randomZ6(1:noiseScale:end);
        noiseZ6 = noiseZ6 + error*(-1+2*rand(size(noiseZ6)));
      
        % Create a point cloud object from the random coordinates


        side3 = pointCloud([randomX5, randomY5, randomZ5]);

        sideNoise3 = pointCloud([noiseX5,noiseY5,noiseZ5]);

        side4 = pointCloud([randomX6, randomY6, randomZ6]);

        sideNoise4 = pointCloud([noiseX6,noiseY6,noiseZ6]);
        
        %pointClouds = [side3, sideNoise3, side4, sideNoise4, cubeOut];
        pointClouds = [side3, sideNoise3,cubeOut];
        cubeOut = pccat(pointClouds);


        tform = rigidtform3d(rots,trans);

        cubeOut = pctransform(cubeOut,tform);
        


end



function cubeSceneOut = cubeScene(lengths, breadths, heights, translations, rotations, densities, errors,noiseScale)

        numPoints = 100000;
        length = 25;
        breadth = 3;
        

        for i = 1: size(translations,1)
            if i == 1
                
                cubeSceneOut = cubeGen(lengths(i), breadths(i), heights(i), translations(i,:),rotations(i,:), densities(i), errors(i),noiseScale);


            else
                cube = cubeGen(lengths(i), breadths(i), heights(i), translations(i,:), rotations(i,:), densities(i), errors(i),noiseScale);
            
                cubeSceneOut = pcmerge(cubeSceneOut, cube, 0.01);
            end
        end
         
        planePoint = [10, 1.5, 0];  % A point on the plane (center of the plane)
        randomX = planePoint(1) + (rand(numPoints, 1) - 0.5) * length;
        randomY = planePoint(2) + (rand(numPoints, 1) - 0.5) * breadth;
        randomZ = planePoint(3) * ones(numPoints, 1);  % Points are constrained to the plane

        ground = pointCloud([randomX, randomY, randomZ]);
        cubeSceneOut = pcmerge(ground,cubeSceneOut,0.01);
  


end