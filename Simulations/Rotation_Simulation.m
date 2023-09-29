
load('myFilter')
sampling_rate = 200;
amplitiude = 1;
duration = 10;
freq = 0.2;

% Specify the mean and standard deviation of the Gaussian noise
mean_noise = 0;        % Mean of the Gaussian noise
std_deviation = 0.1;   % Standard deviation of the Gaussian noise
                                                      
t = 0:1/sampling_rate:duration;


LinearAccelerationZ = -amplitiude*(2*pi*freq)^2*sin(2*pi*freq*t);

LinearAccelerationZ = transpose(LinearAccelerationZ);

% Generate Gaussian noise
noise = std_deviation * randn(size(LinearAccelerationZ)) + mean_noise;

% Add the noise to the original data
LinearAccelerationZ = LinearAccelerationZ + noise;

positionZ = amplitiude*sin(2*pi*freq*t);
positionZ = transpose(positionZ);
positionX = zeros(size(t,2),1);
positionY = zeros(size(t,2),1);

figure
plot(t,LinearAccelerationZ)
hold on
LinearAccelerationZFilt = filter(myFilt,LinearAccelerationZ);

figure
plot(t,LinearAccelerationZFilt)

positions = [positionX,positionY,positionZ];

angularVelocity = [positionY,positionY,positionY];


rotations = [0 0 0; 0 0 30; 0 0 67; 0 0 21; 0 0 70];

translations = [1.5 0.5 0; 0.3 0.2 0; 1 1.5 0; 0.1 2.5 0; 2 2 0];


lengths = [0.2 0.3 0.1 0.5 0.4];
breadths = [0.3 0.2 0.4 0.2 0.5];
heights = [0.5 0.3 0.3 0.2 0.1];


ptCloud = cubeScene(lengths,breadths,heights,translations,rotations);

manyPtClouds = createMotionFrames(ptCloud,positions,angularVelocity);




messyMan = manyPtClouds{1};
for i = 1:3
    
    messyMan = pcmerge(messyMan,manyPtClouds{i},0.01);

end

%figure
%pcshow(messyMan)


%combined = ICPCompensation(manyPtClouds,1,5);

%figure
%pcshow(combined)

%getRectPrism(combined, 0, 0, 20, 3, 2)

%Functions
%=================================================================================
%This function takes in a point clouds and simulates movement of the LiDAR
%sensor
function rotatedPtClouds = createMotionFrames(ptCloud, translations, rotations)
        rotatedPtClouds = cell(size(translations,1));
        rotatedPtClouds{1} = ptCloud;
        j = 2;
        for i = 2:size(translations,1)
            
            if mod(i,20) == 0
           
                tform = rigidtform3d(rotations(i,:),translations(i,:));
                rotatedPtClouds{j} = pctransform(ptCloud,tform); 
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

