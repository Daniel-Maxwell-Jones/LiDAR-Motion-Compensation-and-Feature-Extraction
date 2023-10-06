%{
This function takes in a cell array of point clouds as well as a start
index and number of frames that you wish to concantenate. It will then
combine these frames using purely ICP registration.
%}

%Author: Daniel Jones
%Date: 2nd October 2023

function combinedptCloud = ICPCompensation(manyPtClouds, startIndex, numFrames)
    
%Setting each of these variables to empty arrays to trigger initial
 %conditions in following for loops
    combined = [];  
    tform = []; 

    for i = startIndex:startIndex+numFrames-1
       
        if isempty(combined) %If empty assign first point cloud to the combined point cloud
            combined = manyPtClouds{i};
        else
            
            if isempty(tform) %If there is no transform yet perform ICP registration without initial transform
    
                [tform, ptCloudtform] = pcregistericp(manyPtClouds{i},combined,"Metric","planeToPlane","MaxIterations",300); 
    
    
            else %Use the previous transformation to peform ICP registration between the combined point cloud and the next frame
    
                [tform, ptCloudtform] = pcregistericp(manyPtClouds{i},combined,"Metric","planeToPlane","InitialTransform",tform,"MaxIterations",300); 
                  
            end
                
            combined = pcmerge(ptCloudtform, combined, 0.01); %Add the latest frame to the combined point cloud
            
    
        end
    end

    combinedptCloud = combined;



end