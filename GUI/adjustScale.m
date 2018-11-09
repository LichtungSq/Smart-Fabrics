function outputMatrix = adjustScale(inputMatrix, end_point, minVal, maxVal)

inputMatrix(inputMatrix > end_point) = endpoint;

minmum = min(min(inputMatrix));
maxmum = max(max(inputMatrix));

outputMatrix = (inputMatrix - minmum)/(maxmum - minmum);
outputMatrix = minVal + outputMatrix * (maxVal - minVal);

end
