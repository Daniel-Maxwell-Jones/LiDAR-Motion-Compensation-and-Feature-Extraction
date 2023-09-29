%{
This function separates a given point cloud into segmented objects based
off of Euclidean distance. Each of these objects is colour coded and
plotted.
%}
%Author: Daniel Jones
%Date: 29th September 2023

function [labelsOut,ptCloudOut] = getClusters(ptCloud)
   %====================================================================
    %{
    %==============================================================
    %Reducing area of interest by inspection
    roi = [0,5,-2,2,-inf,1];

    indices = findPointsInROI(ptCloud,roi);

    ptCloud = select(ptCloud,indices);
    %==============================================================

    %}
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

    minDistance = 0.04;
    minPoints = 700;

    [labels,numClusters] = pcsegdist(remainPtCloud,minDistance, 'NumClusterPoints',minPoints);

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

