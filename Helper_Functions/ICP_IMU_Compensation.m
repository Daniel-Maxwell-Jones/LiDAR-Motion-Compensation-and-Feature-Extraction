%{
This function takes in a cell array of point clouds as well as a start
index and number of frames that you wish to concantenate. It also makes use
of the IMU data as well as the corresponding time stamps. It will then
combine these frames using ICP registration with an intitial transformation 
being made from IMU data.
%}

%Author: Daniel Jones
%Date: 2nd October 2023


function combinedptCloud = ICP_IMU_Compensation(manyPtClouds,t_ptCloud, IMU, t_IMU, startIndex, numFrames)
 
    %Setting this variable to an empty array to trigger initial
    %conditions in following for loops.
    combined = [];
    
   
    for i = startIndex:startIndex+numFrames-1
       
    
        if isempty(combined) %If empty assign first point cloud to the combined point cloud
            combined = manyPtClouds{i};
            t0 = t_ptCloud(i); %Obtain the time stamp of the reference point cloud to which the rest will be registered with
        else
            
            initTform = IMUCompensation(t0,t_ptCloud(i),IMU,t_IMU); %Obtain the intial transfor from the IMU DATA
            
            %Now perform ICP registration using the initial transform
            [tform, ptCloudtform] = pcregistericp(manyPtClouds{i},combined,"Metric","planeToPlane","InitialTransform",initTform); 
            
            %Add the latest frame to the combined point cloud
            combined = pcmerge(ptCloudtform, combined, 0.01);
    
        end
    end

    combinedptCloud = combined;

end