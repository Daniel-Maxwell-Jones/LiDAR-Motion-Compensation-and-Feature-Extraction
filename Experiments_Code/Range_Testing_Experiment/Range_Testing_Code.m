
%This is the script used to validate the feature extraction component of the algorithm from varying distances 
%Author: Daniel Jones
%Date: 29th September 2023
tic;
numFrames = 50; %at 100 frames the noise points from the floor plane affect clustering
numNeighbors = 100;
threshold = 1;

addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions')
addpath("C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\Data\Range_Data")


[timeStamps, manyPtClouds, ptCloudMess] = ptCloudCell("2023-09-27-10-12-45.bag",1,numFrames,1);

roi = [20,59,-20,20,-inf,inf];

indices = findPointsInROI(ptCloudMess,roi);

ptCloudMess = select(ptCloudMess,indices);

tform = rigidtform3d([-2 3 0],[0 0 0]);
ptCloudMess = pctransform(ptCloudMess,tform);
figure 
pcshow(ptCloudMess)
ax = gca;
ax.FontSize = 14;
set(ax, 'FontWeight', 'bold');
% Set the axis line width (make them thicker)
ax.LineWidth = 3; % Change this value to your desired line width

% Optionally, set other axis properties, such as labels, titles, etc.
xlabel('X-axis [m]');
ylabel('Y-axis [m]');
zlabel('Z-axis [m]');

[labelsOut, segmentedPtCloud]= getClusters(ptCloudMess,minPoints=50,maxDistance=0.1,minDistance=0.5);
gettingClusters = toc;
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
    %{
    t_total = gettingDimensions + gettingClusters;
    
    % Specify the Excel file path

    excelFilePath = 'Range_Experiment_LowFilt_Dist3.xlsx';

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
