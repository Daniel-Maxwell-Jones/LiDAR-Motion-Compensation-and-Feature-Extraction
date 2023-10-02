%{
This function separates a given point cloud into segmented objects based
off of Euclidean distance. Each of these objects is colour coded and
plotted.
%}
%Author: Daniel Jones
%Date: 29th September 2023

function [labelsOut,ptCloudOut] = getClusters(ptCloud)
    %====================================================================
    %Removing points in the ground plane to allow for segmentation
    %====================================================================
    maxDistance = 0.04; %refers to the max distance that a point can be separate from a the plane

    referenceVector = [0,0,1]; %k unit vector in order to select ground plane

    maxAngularDistance = 5; %This to allow for a little variation

    MaxNumTrials = 2000;
    
    %Fit a plane using RANSAC and then removing all points in the ground
    %plane.
    [model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,maxDistance,referenceVector,maxAngularDistance,MaxNumTrials=MaxNumTrials);
   
    remainPtCloud = select(ptCloud,outlierIndices);
    
    %====================================================================
    %Clustering of Objects
    %====================================================================
    %Setting the minimum distance between points before they are considered
    %part of the same object
    minDistance = 0.04; 
    %Setting the minimum number of points in a cluster for it to be
    %considered an object
    minPoints = 700;
    

    %Segmenting the given point cloud based on Euclidean distance
    [labels,numClusters] = pcsegdist(remainPtCloud,minDistance, 'NumClusterPoints',minPoints);


    %Plotting and colour each of the segmented objects

    idxValidPoints = find(labels);
    labelColorIndex = labels(idxValidPoints);
    remainPtCloud = select(remainPtCloud,idxValidPoints);
    
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
    hold off
    ptCloudOut = remainPtCloud;
end

