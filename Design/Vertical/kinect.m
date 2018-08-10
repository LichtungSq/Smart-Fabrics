kinect_tmp = load('output_ver_strain_right.txt');

t = kinect_tmp(:,1);
data = kinect_tmp(:,end);

loess = smooth(data,15,'loess',2);
% plot(t,loess);

matrix = [t loess];
xlswrite('output_ver_strain_right.csv',matrix,'Sheet1');
