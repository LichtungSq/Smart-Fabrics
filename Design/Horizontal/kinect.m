kinect_tmp = load('output_hor_strain_mid_1.txt');

t = kinect_tmp(:,1);
data = kinect_tmp(:,end);

loess = smooth(data,15,'loess',2);
% plot(t,loess);

matrix = [t loess];
xlswrite('output_hor_strain_mid_1.csv',matrix,'Sheet1');
