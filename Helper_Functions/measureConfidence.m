function confidence = measureConfidence(x1, x2, y1, y2)
        
         
    A = [x1, y1];  % Replace x1 and y1 with the components of vector A
    B = [x2, y2];  % Replace x2 and y2 with the components of vector B
    
    % Calculate the dot product
    dot_product = dot(A, B);
    
    % Calculate the magnitudes of the vectors
    magnitude_A = norm(A);
    magnitude_B = norm(B);
    
    % Calculate the angle in radians
    angle_radians = acos(dot_product / (magnitude_A * magnitude_B));
    
    % Convert the angle to degrees
    angle_degrees = angle_radians * (180 / pi);
    
    fprintf('The angle between A and B is %.2f degrees\n', angle_degrees);
    confidence = 1;

end