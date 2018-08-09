pressure_tmp = load('new_pressure.txt');
sensor1_tmp = load('new_strain_1.txt');
sensor2_tmp = load('new_strain_2.txt');
t = pressure_tmp(:,1);
pressure = pressure_tmp(:,2);
t_1 = sensor1_tmp(:,1);
sensor1 = sensor1_tmp(:,2);
t_2 = sensor2_tmp(:,1);
sensor2 = sensor2_tmp(:,2);
fs=2000;

pressure_loess = smooth(pressure,35,'rlowess',2);
sensor1_loess = smooth(sensor1,35,'rlowess',2);
sensor2_loess = smooth(sensor2,35,'rlowess',2);
% fft = abs(fft(pressure_loess));

% [b,a] = besself(2,1000);
% x = filter(b,a,pressure_loess);

% 设计低通滤波器

d = fdesign.lowpass(0.16,1,5,40,50);

h = design(d);

%对信号进行低通滤波并画出波形

newsignal=filter(h,pressure_loess);

figure(1)
subplot(4,1,1);
plot(t,pressure_loess,'r');
subplot(4,1,2);
plot(t,newsignal,'k');
subplot(4,1,3);
plot(t_1,sensor1_loess,'g');
subplot(4,1,4);
plot(t_2,sensor2_loess,'k');
