kinect_data = load("output_ruibo_1.txt");

time = kinect_data(:,1);
angle = kinect_data(:,end);

% N = length(extension);

%% with trean freq analysis
plot(time, angle, 'k');  
grid;
title('Kinect Angle');
xlabel('Time/s'); ylabel('Angle/degree');