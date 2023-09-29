sampling_rate = 200;
amplitiude = 1;
duration = 3;
freq = 1;

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
plot(positionZ)

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

figure
pcshow(messyMan)


%combined = ICPCompensation(manyPtClouds,1,5);

%figure
%pcshow(combined)

%getRectPrism(combined, 0, 0, 20, 3, 2)

%Functions
%=================================================================================
%This function takes in a point clouds and simulates movement of the LiDAR
%sensor
function rotatedPtClouds = createMotionFrames(ptCloud, translations, rotations)
 
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

function corners = verticedetector(ptCloud)
%returns this indices of the extremities within the input ptCloud
    
    XminIndex = NaN;
    XmaxIndex = NaN;
    YminIndex = NaN;
    YmaxIndex = NaN; 
    ZminIndex = NaN; 
    ZmaxIndex = NaN;
    
    xmin = ptCloud.XLimits(1);
    xmax = ptCloud.XLimits(2);

    ymin = ptCloud.YLimits(1);
    ymax = ptCloud.YLimits(2);

    zmin = ptCloud.ZLimits(1);
    zmax = ptCloud.ZLimits(2);
    
    for i = 1:size(ptCloud.Location,1) %store if a point = an extremity

        if ptCloud.Location(i,1) == xmin

            XminIndex = i;
 
        end

        if ptCloud.Location(i,1) == xmax

            XmaxIndex = i;
           
        end

        if ptCloud.Location(i,2) == ymin

            YminIndex = i;
           
        end

        if ptCloud.Location(i,2) == ymax

            YmaxIndex = i;
           
        end

        if ptCloud.Location(i,3) == zmin

            ZminIndex = i;
            
        end

        if ptCloud.Location(i,3) == zmax

            ZmaxIndex = i;

        end

    end
    
    corners = [XminIndex, XmaxIndex, YminIndex, YmaxIndex, ZminIndex, ZmaxIndex];
end

%==============================================================
%Gets euclidian distance based off of pythagoras
function dist = eucliddist(p1,p2) %Assumes p = [x,y]

    dist = sqrt((p1(1) - p2(1))^2 + (p1(2) - p2(2))^2);
    
end

%==============================================================
%Under the assumption object is a cube in nature, this function extracts
%its parameters
function dims = cubedims(ptCloud, corners)

    %dim = [breadth, length, Area1, Area2, Area3, Volume]  

    %Firstly lets get the points from the corner indices

    height = abs(ptCloud.Location(corners(5),3)-ptCloud.Location(corners(6),3)); %This is the difference in z coords
    points = zeros(4,2);
    for i = 1:4 %This puts all of the points in the x-y plane into an array
        
        points(i,1:2) = ptCloud.Location(corners(i),1:2);

    end

    %Now to arrange the points

    lengths = zeros(6);

    for j = 1:3

        lengths(j) = eucliddist(points(1,:), points(j+1,:));
        

    end

    for k = 2:3

        lengths(k+2) = eucliddist(points(2,:),points(k+1,:));
        

    end
    
    lengths(6) = eucliddist(points(3,:),points(4,:));
    
    lengths = sort(lengths);
    
    
    breadthxy = (lengths(1)+lengths(2))/2;

    lengthxy = (lengths(3)+lengths(4))/2;

    area1 = breadthxy*lengthxy;

    area2 = lengthxy*height;

    area3 = breadthxy*height;

    vol = lengthxy*breadthxy*height;
    

    dims = [breadthxy, lengthxy, height, area1, area2, area3, vol];

    sprintf('Breadth: %.2f \nLength: %.2f \nHeight: %.2f \nArea1: %.2f \nArea2: %.2f \nArea3: %.2f \nVolume: %.2f', dims(1), dims(2), dims(3),dims(4), dims(5),dims(6),dims(7))
    
end

%=========================================================================
%Getting the points of the vertices

function vertices = verticesPlot(ptCloud, corners)
    
    vertices = zeros(8,3);
    vertices(1,:) = ptCloud.Location(corners(1),:);
    vertices(1,3) = ptCloud.Location(corners(5),3);

    vertices(2,:) = ptCloud.Location(corners(1),:);
    vertices(2,3) = ptCloud.Location(corners(6),3);

    vertices(3,:) = ptCloud.Location(corners(2),:);
    vertices(3,3) = ptCloud.Location(corners(5),3);
    
    vertices(4,:) = ptCloud.Location(corners(2),:);
    vertices(4,3) = ptCloud.Location(corners(6),3);

    vertices(5,:) = ptCloud.Location(corners(3),:);
    vertices(5,3) = ptCloud.Location(corners(5),3);

    vertices(6,:) = ptCloud.Location(corners(3),:);
    vertices(6,3) = ptCloud.Location(corners(6),3);

    vertices(7,:) = ptCloud.Location(corners(4),:);
    vertices(7,3) = ptCloud.Location(corners(5),3);

    vertices(8,:) = ptCloud.Location(corners(4),:);
    vertices(8,3) = ptCloud.Location(corners(6),3);





end

%=========================================================================

function dims = getRectPrism(bagPath, numFrames, startIndex, numNeighbors, labelIn, sim)
   %====================================================================
   %Extracting and concantenating point cloud
    
    if sim == 0
        bag = rosbag(bagPath);
    
        msgs = select(bag, 'Topic', 'livox/lidar');
    
    
        concatenatedCloud = [];
    
        for i = startIndex:startIndex+numFrames-1
            msg = readMessages(msgs, i);
            ptCloud = pointCloud(readXYZ(msg{1}));
        
            if isempty(concatenatedCloud)
                concatenatedCloud = ptCloud;
            else
                concatenatedCloud = pcmerge(concatenatedCloud, ptCloud, 0.01); % Adjust merge distance as needed
            end
        end
    
        ptCloud = concatenatedCloud;

    else
        
        ptCloud = bagPath;

    end

    %==============================================================
    %Reducing area of interest by inspection
    %{
    roi = [0,5,-2,2,-inf,1];

    indices = findPointsInROI(ptCloud,roi);

    ptCloud = select(ptCloud,indices);

    %}
    %==============================================================
    %Removing the floor

    %figure;

    %pcshow(ptCloud)


    maxDistance = 0.04;

    referenceVector = [0,0,1];

    maxAngularDistance = 5;

    MaxNumTrials = 2000;

    [model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,maxDistance,referenceVector,maxAngularDistance,MaxNumTrials=MaxNumTrials);
   
    remainPtCloud = select(ptCloud,outlierIndices);

    %==============================================================
    %Clustering of Objects

    minDistance = 0.1;
    minPoints = 500;

    [labels,numClusters] = pcsegdist(remainPtCloud,minDistance, 'NumClusterPoints',minPoints);

    figure;

    pcshow(remainPtCloud.Location,labels)

    colormap(hsv(numClusters))

    title('Point Cloud Clusters')

    %==============================================================
    %Cluster Separator 
    %{
    sprintf('There are %.2d clusters identified.',numClusters)

    labelIn = input("Choose a Cluster: ");
    %}
    validIndex = find(labels == labelIn);

    validCluster = select(remainPtCloud,validIndex);

    
    %Lets do some downsampling
    
    sepCluster = pcdownsample(validCluster,"gridAverage",0.01);
    
    %Lets add a filter
        
    sepCluster = pcdenoise(sepCluster,"NumNeighbors",numNeighbors,"Threshold",1);
    
    figure
    pcshowpair(validCluster,sepCluster,"MarkerSize",50)

    figure
    pcshow(sepCluster,"MarkerSize",50)
    hold on
    corners = verticedetector(sepCluster);
%{
    cornerPlot = select(denoisedValidCluster,corners);
    cornerPlot.Color = 'white';
    pcshow(cornerPlot,"MarkerSize",500)
%}
    hold on
    

    p = verticesPlot(sepCluster, corners);

    plot3([p(1,1), p(2,1)], [p(1,2), p(2,2)], [p(1,3), p(2,3)], 'r', 'LineWidth', 2);
    plot3([p(3,1), p(4,1)], [p(3,2), p(4,2)], [p(3,3), p(4,3)], 'r', 'LineWidth', 2);
    plot3([p(5,1), p(6,1)], [p(5,2), p(6,2)], [p(5,3), p(6,3)], 'r', 'LineWidth', 2);
    plot3([p(7,1), p(8,1)], [p(7,2), p(8,2)], [p(7,3), p(8,3)], 'r', 'LineWidth', 2);
    
    plot3([p(1,1), p(5,1)], [p(1,2), p(5,2)], [p(1,3), p(5,3)], 'r', 'LineWidth', 2);
    plot3([p(1,1), p(7,1)], [p(1,2), p(7,2)], [p(1,3), p(7,3)], 'r', 'LineWidth', 2);
    plot3([p(3,1), p(5,1)], [p(3,2), p(5,2)], [p(3,3), p(5,3)], 'r', 'LineWidth', 2);
    plot3([p(3,1), p(7,1)], [p(3,2), p(7,2)], [p(3,3), p(7,3)], 'r', 'LineWidth', 2);

    plot3([p(2,1), p(6,1)], [p(2,2), p(6,2)], [p(2,3), p(6,3)], 'r', 'LineWidth', 2);
    plot3([p(2,1), p(8,1)], [p(2,2), p(8,2)], [p(2,3), p(8,3)], 'r', 'LineWidth', 2);
    plot3([p(4,1), p(6,1)], [p(4,2), p(6,2)], [p(4,3), p(6,3)], 'r', 'LineWidth', 2);
    plot3([p(4,1), p(8,1)], [p(4,2), p(8,2)], [p(4,3), p(8,3)], 'r', 'LineWidth', 2);
    
    x = p(:,1);
    y = p(:,2);
    z = p(:,3);
    scatter3(x, y, z, 50,'white','filled');
    
    hold off



    %==============================================================
    %Extracting Parameters 
   
    dims = cubedims(sepCluster,corners);
    
    %============================================================
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

function combinedptCloud = ICPCompensation(manyPtClouds, startIndex, numFrames)
 
    combined = [];
    
    tform = [];
    for i = startIndex:startIndex+numFrames-1
       
    
        if isempty(combined)
            combined = manyPtClouds{i};
        else
            
            if isempty(tform)
    
                [tform, ptCloudtform] = pcregistericp(manyPtClouds{i},combined,"Metric","planeToPlane"); 
    
    
            else
    
                [tform, ptCloudtform] = pcregistericp(manyPtClouds{i},combined,"Metric","planeToPlane","InitialTransform",tform); 
                  
    
            end
    
            combined = pcmerge(ptCloudtform, combined, 0.01);
            %combined = pcdenoise(combined,"NumNeighbors",100,"Threshold",1);
    
        end
    end

    combinedptCloud = combined;



end