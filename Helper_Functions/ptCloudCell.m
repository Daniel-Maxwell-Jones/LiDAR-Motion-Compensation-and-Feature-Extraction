function [manyPtClouds, ptCloudMerge] = ptCloudCell(bagPath,startIndex,numFrames,step)

    ptCloudBag = rosbag(bagPath);
    ptCloudMsgs = select(ptCloudBag,'Topic','livox/lidar');
    
    length = floor(numFrames/step);
    

    manyPtClouds = cell(floor(numFrames/step),1);
    j = 1;
    
    for i = startIndex:step:startIndex + numFrames - 1
        
        msg = readMessages(ptCloudMsgs, i);
        ptCloud = pointCloud(readXYZ(msg{1}));
        ptCloud = pcdenoise(ptCloud);
        manyPtClouds{j} = ptCloud;
        j = j + 1;
        
        
        if i == startIndex
            
            ptCloudMerge = ptCloud;
            
        else
    
            ptCloudMerge = pcmerge(ptCloud,ptCloudMerge,0.01);
        end
    end

end