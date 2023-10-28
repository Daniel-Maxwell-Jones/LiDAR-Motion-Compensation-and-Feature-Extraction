%{
This function assists in reading a specific range from a column in an excel spreadsheet and reading
into an array.
%}
%Author: Daniel Jones
%Date = 18th October 2023


function columnData = excel2Array(filename, column, startRow, endRow)
    
    % Read the specified range of rows from the given column
    data = xlsread(filename);
    columnData = data(startRow:endRow, column - 'A' + 1); % Convert column letter to column index

end
