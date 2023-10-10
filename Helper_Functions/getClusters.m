%{
This function separates a given point cloud into segmented objects based
off of Euclidean distance. Each of these objects is colour coded and
plotted.
%}
%Author: Daniel Jones
%Date: 29th September 2023

function [labelsOut,ptCloudOut] = getClusters(ptCloud,options)
    arguments
        ptCloud pointCloud
        options.maxDistance = 0.04; %refers to the max distance that a point can be separate from a the plane
        options.referenceVector (1,3) = [0, 0, 1]; %k unit vector in order to select ground plane
        options.maxAngularDistance = 5; %This to allows for a little variation
        options.minDistance = 0.04; 
        options.minPoints = 400;
    end

    %====================================================================
    %Removing points in the ground plane to allow for segmentation
    %====================================================================
    maxDistance = options.maxDistance; 

    referenceVector = options.referenceVector; 

    maxAngularDistance = options.maxAngularDistance; 

    MaxNumTrials = 2000;
    
    %Fit a plane using RANSAC and then removing all points in the ground
    %plane.
    if referenceVector == [0 0 0]
    
        [model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,maxDistance,MaxNumTrials=MaxNumTrials);
    else

        [model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,maxDistance,referenceVector,maxAngularDistance,MaxNumTrials=MaxNumTrials);
    end
    
    remainPtCloud = select(ptCloud,outlierIndices);
   %{
    figure
    pcshow(remainPtCloud,MarkerSize=50)
    title("Objects")
    floor = select(ptCloud,inlierIndices);
    figure
    pcshow(floor,MarkerSize=50)
    title("Floor")
    %}
    %====================================================================
    %Clustering of Objects
    %====================================================================
    %Setting the minimum distance between points before they are considered
    %part of the same object
    minDistance = options.minDistance; 
    %Setting the minimum number of points in a cluster for it to be
    %considered an object
    minPoints = options.minPoints;
    

    %Segmenting the given point cloud based on Euclidean distance
    [labels,numClusters] = pcsegdist(remainPtCloud,minDistance, 'NumClusterPoints',minPoints);


    %Plotting and colour each of the segmented objects

    idxValidPoints = find(labels);
    labelColorIndex = labels(idxValidPoints);
    remainPtCloud = select(remainPtCloud,idxValidPoints);
    %remainPtCloud = pcdenoise(remainPtCloud);
    labelsOut = labelColorIndex;
    colour = hsv(numClusters);
    
    legendLabels = cell(numClusters,1);
    
    figure
    for k = 1:max(labelColorIndex)

        cluster = select(remainPtCloud,find(labelColorIndex == k));

        cluster.Color = colour(k,:);
        
        pcshow(cluster,"MarkerSize",10)
        legendLabels{k} = sprintf("Object %d", k);
        hold on
        

    end 
    legend(legendLabels,"Color","white")
    % Get the current axes handle
    ax = gca;
    
    % Set the axis line width (make them thicker)
    ax.LineWidth = 2; % Change this value to your desired line width
    
    % Optionally, set other axis properties, such as labels, titles, etc.
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Z-axis');
    hold off
    ptCloudOut = remainPtCloud;
end

