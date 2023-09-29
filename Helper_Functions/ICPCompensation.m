function combinedptCloud = ICPCompensation(manyPtClouds, startIndex, numFrames)
 
    combined = [];
    
    tform = [];
    for i = startIndex:startIndex+numFrames-1
       
    
        if isempty(combined)
            combined = manyPtClouds{i};
        else
            
            if isempty(tform)
    
                [tform, ptCloudtform] = pcregistericp(manyPtClouds{i},combined,"Metric","planeToPlane"); 
    
    
            else
    
                [tform, ptCloudtform] = pcregistericp(manyPtClouds{i},combined,"Metric","planeToPlane","InitialTransform",tform); 
                  
    
            end
    
            combined = pcmerge(ptCloudtform, combined, 0.01);
            %combined = pcdenoise(combined,"NumNeighbors",100,"Threshold",1);
    
        end
    end

    combinedptCloud = combined;



end