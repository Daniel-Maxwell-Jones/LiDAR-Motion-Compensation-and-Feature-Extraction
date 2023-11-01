# Function Descriptions

Given here are brief descriptions of the Helper functions created for this project. The code itself is commented on as well.

## ptCloudCell(bagPath,startIndex,numFrames,step)

This function is used to extract point cloud data from ROS1 bag files. In
order to do this one must input the the file path of the desired bag file
as well as the index of the starting frame, the number of frames and the step between frames. The
function will then output the desired point cloud frames as a cell array
and as a singular merged point cloud. The associated time stamps of the
frames will be output as well.

## ICP_IMU_Compensation(manyPtCliouds,IMU,t_IMU,startIndex, numFrames)

This function takes in a cell array of point clouds as well as a start
index and a number of frames that you wish to concatenate. It also makes use
of the IMU data as well as the corresponding time stamps. It will then
combine these frames using ICP registration with an initial transformation 
being made from IMU data.

## getClusters(ptCloud,options)

This function separates a given point cloud into segmented objects based
on Euclidean distance. Each of these objects is colour-coded and
plotted. As optional inputs, you can adjust the maximum distance used by the RANSAC algorithm and the minimum distances used by the Euclidean clustering algorithm. One can also adjust the 


## getRectPrismV2(ptCloud, numNeighbors, threshold ,labels, labelIn)

This function takes in a point cloud and calculates the size parameters of
a desired object within the point cloud based off a given label from a list
of labels.
