
%This is the script used to validate the feature extraction component of the algorithm from static reference frames 
%Author: Daniel Jones
%Date: 29th September 2023
tic;
numFrames = 50;
numNeighbors = 100;
threshold = 1;

addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions')
addpath("C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\Data\Static_Data")


[timeStamps, manyPtClouds, ptCloudMess] = ptCloudCell("2023-09-12-11-47-32.bag",10,numFrames,1);

figure
pcshow(ptCloudMess)
ptCloudArray = [manyPtClouds{1},manyPtClouds{2},manyPtClouds{3},manyPtClouds{4},manyPtClouds{5},manyPtClouds{6},manyPtClouds{7},manyPtClouds{8},manyPtClouds{9},manyPtClouds{10}];
ax = gca;
ax.FontSize = 14;
set(ax, 'FontWeight', 'bold');
% Set the axis line width (make them thicker)
ax.LineWidth = 3; % Change this value to your desired line width

% Optionally, set other axis properties, such as labels, titles, etc.
xlabel('X-axis [m]');
ylabel('Y-axis [m]');
zlabel('Z-axis [m]');


%ptCloudICP = ICPCompensation(manyPtClouds,1,numFrames);

%Reducing area of interest by inspection

roi = [1.5,5,-2,2,-inf,1];

indices = findPointsInROI(ptCloudMess,roi);

ptCloudICP = select(ptCloudMess,indices);



[labelsOut, segmentedPtCloud]= getClusters(ptCloudICP,referenceVector=[0,0,0]);
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
    t_total = gettingDimensions + gettingClusters;
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
