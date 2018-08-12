kinect_tmp = load('output_left_pressure_1.txt');

t = kinect_tmp(1:1150,1);
data = kinect_tmp(1:1150,end);

loess = smooth(data,17,'loess',2);
% plot(t,loess);

matrix = [t-3 loess];
xlswrite('output_left_pressure_1.csv',matrix,'Sheet1');
