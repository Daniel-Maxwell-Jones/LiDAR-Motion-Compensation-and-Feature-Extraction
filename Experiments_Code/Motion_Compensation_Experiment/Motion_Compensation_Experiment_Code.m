%{
This is the script used to validate the motion compensation aspect of the
algorithm 
%}
%Author: Daniel Jones
%Date: 4th October 2023
tic;
numFrames = 15;
numNeighbors = 100;
threshold = 1;

addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\Data\Dynamic_data');
addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions')
load('2023-09-25-13-19-56.mat')
[t_PointCloud,manyPtClouds,ptCloudMess] = ptCloudCell('2023-09-25-13-19-56.bag',55, numFrames, 1);
t_IMU = timeOmegaY-timeOmegaY(1);

t_PointCloud = t_PointCloud - t_PointCloud(1);

angX = cumtrapz(t_IMU,omegaX);
angX = rad2deg(angX);

angY = cumtrapz(t_IMU,omegaY);
angY = rad2deg(angY);

angZ = cumtrapz(t_IMU,omegaZ);
angZ = rad2deg(angZ);

angles = [angX angY angZ];

figure
pcshow(ptCloudMess,"MarkerSize",20)

%ptCloudICP = ICP_IMU_Compensation(manyPtClouds,t_PointCloud,angles,t_IMU,1, numFrames);

ptCloudICP = ICPCompensation(manyPtClouds,1,numFrames);


figure
pcshow(ptCloudICP,"MarkerSize",20);
xlabel("x-axis")
ylabel("y-axis")
zlabel("z-axis")


roi = [1.5,5,-2,2,-inf,1];

indices = findPointsInROI(ptCloudICP,roi);

ptCloudICP = select(ptCloudICP,indices);
%ptCloudICP = pcdenoise(ptCloudICP,"NumNeighbors",numNeighbors,"Threshold",threshold);

[labelsOut, segmentedPtCloud]= getClusters(ptCloudICP,referenceVector=[0 0 0],minDistance=0.03);
gettingClusters = toc;
userLabel = 1;

while userLabel ~= 0


    userLabel = input('Enter the number of the object: ');
    
    if userLabel == 0 
        break;
    end
    tic;
   [dims, confidence] = getRectPrismV2(segmentedPtCloud,numNeighbors,threshold,labelsOut,userLabel);
    gettingDimensions = toc;
   sprintf("Confidence: %2f",confidence)
    
    % Specify the Excel file path
    
    excelFilePath = 'Motion_Experiment_HighFilt.xlsx';
    t_total = gettingClusters + gettingClusters;
    %{
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
