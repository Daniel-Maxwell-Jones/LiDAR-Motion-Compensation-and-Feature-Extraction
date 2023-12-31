%{
This function takes in a point cloud and calculates the size parameters of
a desired object within the point cloud based off a given label from a list
of labels.
%}
%Author: Daniel Jones
%Date: 29th September 2023

function [dims, confidence] = getRectPrismV2(ptCloud, numNeighbors, threshold ,labels, labelIn)

    
    
    %Select the cluster corresponding to the users input label
    validIndex = find(labels == labelIn);
    sepCluster = select(ptCloud,validIndex);
    validCluster = sepCluster;
    
    %sepCluster = pcdownsample(sepCluster,"gridAverage",0.01);
    
   
    %apply a filter to get rid of outliers
    sepCluster = pcdenoise(sepCluster,"NumNeighbors",numNeighbors,"Threshold",threshold);
    
    %show the effectiveness of filtering by showing before and after
    
    figure
    pcshowpair(validCluster,sepCluster,"MarkerSize",50)
    ax = gca;
    ax.FontSize = 16;
    set(ax, 'FontWeight', 'bold');
    % Set the axis line width (make them thicker)
    ax.LineWidth = 3; % Change this value to your desired line width
    
    % Optionally, set other axis properties, such as labels, titles, etc.
    xlabel('X-axis [m]');
    ylabel('Y-axis [m]');
    zlabel('Z-axis [m]');
    %legend('Before filter','After filter',Color="white");
    %Show the selected cluster
    figure
    pcshow(sepCluster,"MarkerSize",50)
    ax = gca;
    ax.FontSize = 16;
    set(ax, 'FontWeight', 'bold');
    % Set the axis line width (make them thicker)
    ax.LineWidth = 3; % Change this value to your desired line width
    % Optionally, set other axis properties, such as labels, titles, etc.
    xlabel('X-axis [m]');
    ylabel('Y-axis [m]');
    zlabel('Z-axis [m]');
    hold on
   

    %The following code plots the suspected vertices of the rectangular
    %prisms by drawing read lines between each of the vertices.
   
    corners = verticedetector(sepCluster);

    p = verticesPlot(sepCluster, corners);

    plot3([p(1,1), p(2,1)], [p(1,2), p(2,2)], [p(1,3), p(2,3)], 'r', 'LineWidth', 3);
    plot3([p(3,1), p(4,1)], [p(3,2), p(4,2)], [p(3,3), p(4,3)], 'r', 'LineWidth', 3);
    plot3([p(5,1), p(6,1)], [p(5,2), p(6,2)], [p(5,3), p(6,3)], 'r', 'LineWidth', 3);
    plot3([p(7,1), p(8,1)], [p(7,2), p(8,2)], [p(7,3), p(8,3)], 'r', 'LineWidth', 3);
    
    plot3([p(1,1), p(5,1)], [p(1,2), p(5,2)], [p(1,3), p(5,3)], 'r', 'LineWidth', 3);
    plot3([p(1,1), p(7,1)], [p(1,2), p(7,2)], [p(1,3), p(7,3)], 'r', 'LineWidth', 3);
    plot3([p(3,1), p(5,1)], [p(3,2), p(5,2)], [p(3,3), p(5,3)], 'r', 'LineWidth', 3);
    plot3([p(3,1), p(7,1)], [p(3,2), p(7,2)], [p(3,3), p(7,3)], 'r', 'LineWidth', 3);

    plot3([p(2,1), p(6,1)], [p(2,2), p(6,2)], [p(2,3), p(6,3)], 'r', 'LineWidth', 3);
    plot3([p(2,1), p(8,1)], [p(2,2), p(8,2)], [p(2,3), p(8,3)], 'r', 'LineWidth', 3);
    plot3([p(4,1), p(6,1)], [p(4,2), p(6,2)], [p(4,3), p(6,3)], 'r', 'LineWidth', 3);
    plot3([p(4,1), p(8,1)], [p(4,2), p(8,2)], [p(4,3), p(8,3)], 'r', 'LineWidth', 3);
        
    x = p(:,1);
    y = p(:,2);
    z = p(:,3);
    scatter3(x, y, z, 50,'white','filled');

    hold off
    
    %Obtain the confidence of the measurement based on how closely the
    %object represents a rectangle
    ang1 = angBetweenVectors((p(1,1)-p(5,1)), (p(1,1)-p(7,1)), (p(1,2) - p(5,2)), (p(1,2)-p(7,2)));
    ang2 = angBetweenVectors((p(3,1)-p(5,1)), (p(3,1)-p(7,1)), (p(3,2) - p(5,2)), (p(3,2) - p(7,2)));
    ang3 = angBetweenVectors((p(1,1)-p(7,1)),(p(3,1)-p(7,1)),(p(1,2)-p(7,2)),(p(3,2) - p(7,2)));
    ang4 = angBetweenVectors((p(1,1) - p(5,1)),(p(3,1) - p(5,1)),(p(1,2)-p(5,2)),(p(3,2)-p(5,2)));
    
    
    conf1 = closeness_to_90(ang1);

    conf2 = closeness_to_90(ang2);

    conf3 = closeness_to_90(ang3);

    conf4 = closeness_to_90(ang4);

    confidence = (conf1+conf2+conf3+conf4)*100/4;
    %==============================================================
    %Extracting Parameters 
   
    dims = cubedims(sepCluster,corners);
    
    %============================================================
end
%====================================================================
function corners = verticedetector(ptCloud)
%returns this indices of the extremities within the input ptCloud
    
    XminIndex = NaN;
    XmaxIndex = NaN;
    YminIndex = NaN;
    YmaxIndex = NaN; 
    ZminIndex = NaN; 
    ZmaxIndex = NaN;
    
    xmin = ptCloud.XLimits(1);
    xmax = ptCloud.XLimits(2);

    ymin = ptCloud.YLimits(1);
    ymax = ptCloud.YLimits(2);

    zmin = ptCloud.ZLimits(1);
    zmax = ptCloud.ZLimits(2);
    
    for i = 1:size(ptCloud.Location,1) %store if a point = an extremity

        if ptCloud.Location(i,1) == xmin

            XminIndex = i;
 
        end

        if ptCloud.Location(i,1) == xmax

            XmaxIndex = i;
           
        end

        if ptCloud.Location(i,2) == ymin

            YminIndex = i;
           
        end

        if ptCloud.Location(i,2) == ymax

            YmaxIndex = i;
           
        end

        if ptCloud.Location(i,3) == zmin

            ZminIndex = i;
            
        end

        if ptCloud.Location(i,3) == zmax

            ZmaxIndex = i;

        end

    end
    
    corners = [XminIndex, XmaxIndex, YminIndex, YmaxIndex, ZminIndex, ZmaxIndex];
end

%==============================================================
%Gets euclidian distance based off of pythagoras
function dist = eucliddist(p1,p2) %Assumes p = [x,y]

    dist = sqrt((p1(1) - p2(1))^2 + (p1(2) - p2(2))^2);
    
end

%==============================================================
%Under the assumption object is a cube in nature, this function extracts
%its parameters
function dims = cubedims(ptCloud, corners)

    %dim = [breadth, length, Area1, Area2, Area3, Volume]  

    %Firstly lets get the points from the corner indices

    height = abs(ptCloud.Location(corners(5),3)-ptCloud.Location(corners(6),3)); %This is the difference in z coords
    points = zeros(4,2);
    for i = 1:4 %This puts all of the points in the x-y plane into an array
        
        points(i,1:2) = ptCloud.Location(corners(i),1:2);

    end

    %Now to arrange the points

    lengths = zeros(6);

    for j = 1:3

        lengths(j) = eucliddist(points(1,:), points(j+1,:));
        

    end

    for k = 2:3

        lengths(k+2) = eucliddist(points(2,:),points(k+1,:));
        

    end
    
    lengths(6) = eucliddist(points(3,:),points(4,:));
    
    lengths = sort(lengths);
    
    
    breadthxy = (lengths(1)+lengths(2))/2;

    lengthxy = (lengths(3)+lengths(4))/2;

    area1 = breadthxy*lengthxy;

    area2 = lengthxy*height;

    area3 = breadthxy*height;

    vol = lengthxy*breadthxy*height;
    

    dims = [breadthxy, lengthxy, height, area1, area2, area3, vol];

    sprintf('Breadth: %.2f \nLength: %.2f \nHeight: %.2f \nArea1: %.2f \nArea2: %.2f \nArea3: %.2f \nVolume: %.2f' , dims(1), dims(2), dims(3),dims(4), dims(5),dims(6),dims(7))
    
end
%==============================================================
%Turns the indices of the corners into xyz coordinates
function vertices = verticesPlot(ptCloud, corners)

    vertices = zeros(8,3);
    vertices(1,:) = ptCloud.Location(corners(1),:);
    vertices(1,3) = ptCloud.Location(corners(5),3);

    vertices(2,:) = ptCloud.Location(corners(1),:);
    vertices(2,3) = ptCloud.Location(corners(6),3);

    vertices(3,:) = ptCloud.Location(corners(2),:);
    vertices(3,3) = ptCloud.Location(corners(5),3);
    
    vertices(4,:) = ptCloud.Location(corners(2),:);
    vertices(4,3) = ptCloud.Location(corners(6),3);

    vertices(5,:) = ptCloud.Location(corners(3),:);
    vertices(5,3) = ptCloud.Location(corners(5),3);

    vertices(6,:) = ptCloud.Location(corners(3),:);
    vertices(6,3) = ptCloud.Location(corners(6),3);

    vertices(7,:) = ptCloud.Location(corners(4),:);
    vertices(7,3) = ptCloud.Location(corners(5),3);

    vertices(8,:) = ptCloud.Location(corners(4),:);
    vertices(8,3) = ptCloud.Location(corners(6),3);

end


function closeness = closeness_to_90(number)
    % Calculate the absolute difference between the number and 90
    diff_to_90 = abs(number - 90);
    
    % Normalize the difference to a value between 0 and 1
    normalized_diff = 1 - min(diff_to_90 / 90, 1);
    
    % Assign the closeness value
    closeness = normalized_diff;
end
