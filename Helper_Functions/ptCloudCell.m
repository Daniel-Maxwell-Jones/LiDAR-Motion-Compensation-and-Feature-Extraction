%{
This function is used to extract point cloud data from ROS1 bag files. In
order to do this one must input the the file path of the desired bag file
as well as the index of the starting frame, number of frames and the step between frames. The
function will then output the desired point cloud frames as a cell array
and as a singular merged point cloud. The associated time stamps of the
frames will be output as well.
%}
%Author: Daniel Jones
%Date:  29th September 2023


function [timeStamps,manyPtClouds, ptCloudMerge] = ptCloudCell(bagPath,startIndex,numFrames,step)

    ptCloudBag = rosbag(bagPath); %Select the ros bag
    ptCloudMsgs = select(ptCloudBag,'Topic','livox/lidar'); %Change according to LiDAR used
    
    length = floor(numFrames/step); %Preallocating the length of the arrays
    timeStamps = zeros(length,1);
    manyPtClouds = cell(length,1);
    
    j = 1; %Separate counting variable to iterate through arrays
    
    for i = startIndex:step:startIndex + numFrames - 1
        
        msg = readMessages(ptCloudMsgs, i); %Select specific LiDAR reading
        timeStamps(j) = msg{1}.Header.Stamp.Sec + msg{1}.Header.Stamp.Nsec * 1e-9; %Retrieve the time step
        
        ptCloud = pointCloud(readXYZ(msg{1})); %Create a point cloud object according to XYZ values of points
        ptCloud = pcdenoise(ptCloud); %Apply a initial filter to remove drastically outlying points
        manyPtClouds{j} = ptCloud;
        j = j + 1;
        
        %The code below creates a merged point cloud of the selected frames
        if i == startIndex
            
            ptCloudMerge = ptCloud;
            
        else
    
            ptCloudMerge = pcmerge(ptCloud,ptCloudMerge,0.01);

        end
    end

end