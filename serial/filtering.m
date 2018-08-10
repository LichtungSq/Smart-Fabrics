pressure_tmp = load('new_pressure.txt');
sensor1_tmp = load('new_strain_1.txt');
sensor2_tmp = load('new_strain_2.txt');
kinect_tmp = load('output_ruibo_2.txt');
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
sensor1_loess = smooth(sensor1,35,'rlowess',2);
sensor2_loess = smooth(sensor2,35,'rlowess',2);
% kinect_loess = smooth(kinect,35,'rlowess',2);

buffer = [0;pressure_loess(1:24,1)];
flag = zeros(length(pressure_loess),1);
for i = 0:length(pressure_loess)-length(buffer)
    
    buffer = [buffer(2:end);pressure_loess(i+length(buffer))];
    [r,k,b] = regression(t(i+1:i+length(buffer))', buffer');
    
    if k > 20
        flag(i+1:i+length(buffer),1) = -10;
    end
    if  k < -20
        flag(i+1:i+length(buffer),1) = 10;
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

figure(1)
% subplot(4,1,1);
hold on
plot(t,pressure_loess,'k');
% line([0 80],[200 200],'-r');
plot(t,flag+80,'r');
% subplot(4,1,2);
% plot(t,newsignal,'k');
% subplot(4,1,3);
figure(2)
plot(t_1,sensor1_loess,'k');
% subplot(4,1,4);
figure(3)
plot(t_2,sensor2_loess,'k');
figure(4)
plot(t_k,kinect,'k');
