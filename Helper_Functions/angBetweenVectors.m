%{
This function takes in two vectors in a 2D plane and returns the angle
between them. each xi and yi represent the x and y components of the
vectors.
%}
%Author: Daniel Jones
%Date: 2nd October 2023

function angle = angBetweenVectors(x1, x2, y1, y2)
        
         
    A = [x1, y1]; 
    B = [x2, y2];  
    
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
    angle = angle_degrees;

end