
function combinedptCloud = ICP_IMU_Compensation(manyPtClouds,t_ptCloud, IMU, t_IMU, startIndex, numFrames)
 
    combined = [];
    
   
    for i = startIndex:startIndex+numFrames-1
       
    
        if isempty(combined)
            combined = manyPtClouds{i};
            t0 = t_ptCloud(i);
        else
            
            initTform = IMUCompensation(t0,t_ptCloud(i),IMU,t_IMU);
            [tform, ptCloudtform] = pcregistericp(manyPtClouds{i},combined,"Metric","planeToPlane","InitialTransform",initTform); 
            
            %{
            if isempty(tform)
    
                [tform, ptCloudtform] = pcregistericp(manyPtClouds{i},combined,"Metric","planeToPlane"); 
    
    
            else
    
                [tform, ptCloudtform] = pcregistericp(manyPtClouds{i},combined,"Metric","planeToPlane","InitialTransform",tform); 
                  
    
            end
            %}
            combined = pcmerge(ptCloudtform, combined, 0.01);
            %combined = pcdenoise(combined,"NumNeighbors",100,"Threshold",1);
    
        end
    end

    combinedptCloud = combined;



end