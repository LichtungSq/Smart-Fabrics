
fs=2000;

t=0:(1/fs):1;

fc1=20;

fc2=193;

signal=cos(2*pi*fc1*t)+0.2*cos(2*pi*fc2*t+2);

% 设计低通滤波器

d = fdesign.lowpass(50,100,1,40,fs);

h = design(d);

%对信号进行低通滤波并画出波形

newsignal=filter(h,signal);

figure;

subplot(211);

plot(t,signal);

title('滤波前信号');

subplot(212);

plot(t,newsignal);

title('滤波后信号');

