pressure_tmp = load('new_pressure.txt');
sensor1_tmp = load('new_strain_1.txt');
sensor2_tmp = load('new_strain_2.txt');
kinect_tmp = load('output_luckyday_2.txt');
t = pressure_tmp(:,1);
pressure = pressure_tmp(:,2);
t_1 = sensor1_tmp(:,1);
sensor1 = sensor1_tmp(:,2);
t_2 = sensor2_tmp(:,1);
sensor2 = sensor2_tmp(:,2);
t_k = kinect_tmp(:,1);
kinect = kinect_tmp(:,end);

fs=2000;

pressure_loess = smooth(pressure,35,'rlowess',2);
sensor1_loess = smooth(sensor1,11,'rlowess',2);
sensor2_loess = smooth(sensor2,11,'rlowess',2);
% kinect_loess = smooth(kinect,35,'rlowess',2);

buffer = [0;pressure_loess(1:11,1)];
flag = zeros(length(pressure_loess),1);
for i = 0:length(pressure_loess)-length(buffer)
    
    buffer = [buffer(2:end);pressure_loess(i+length(buffer))];
    [r,k,b] = regression(t(i+1:i+length(buffer))', buffer');
    
    if k > 10
        flag(i+1:i+length(buffer),1) = -30;
    end
    if k < -10
        flag(i+1:i+length(buffer),1) = 30;
    end
end
% 
% fft = abs(fft(pressure_loess));
% 
% [b,a] = besself(2,1000);
% x = filter(b,a,pressure_loess);
% 
% d = fdesign.lowpass(0.16,1,5,40,50);
% 
% h = design(d);
% 
% newsignal=filter(h,pressure_loess);


subplot(4,1,1);
hold on
plot(t,pressure_loess,'k');
% line([0 80],[200 200],'-r');
plot(t,flag+960,'r');

subplot(4,1,2);
% plot(t,newsignal,'k')
plot(t_1,sensor1_loess,'k');

subplot(4,1,3);
plot(t_2,sensor2_loess,'k');

subplot(4,1,4);
plot(t_k,kinect,'k');
