delete(instrfindall);
s = serial('/dev/cu.usbmodem1411');        
set(s,'BaudRate',115200);    

fopen(s);

fid = fopen('Data_k.txt','a+');

figure(1)
h_voltage_1 = animatedline;
ax = gca;
ax.YGrid = 'on';
ax.YLim = [0 255];

startTime = datetime('now','Format','HH:mm:ss.SSSSSS');

buf_len = 11;

buff_data_per = zeros(buf_len, 1);
buff_data_filtered_per = zeros(buf_len, 1);

t =  timer('StartDelay', 0, 'Period', 0.01, 'ExecutionMode', 'fixedRate');
t.StartFcn = @(x,y)disp('Hello World!');
t.StopFcn = @(x,y)disp('Hello World!');
t.TimerFcn = {@ReceiveCallback, s, h_voltage_1, ax, startTime, fid};
start(t)

fclose(fid);
