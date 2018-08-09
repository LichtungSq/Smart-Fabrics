delete(instrfindall);
s = serial('COM4');        
set(s,'BaudRate',115200);    

fopen(s);

fid_v1 = fopen('./data_with_kinect_1/new_strain_1.txt','a+');
fid_v2 = fopen('./data_with_kinect_1/new_strain_2.txt','a+');
fid_p = fopen('./data_with_kinect_1/new_pressure.txt','a+');
fid_h = fopen('./data_with_kinect_1/new_strain_3.txt','a+');

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
t.TimerFcn = {@siqi_callback, s, h_voltage_1, ax, startTime, fid_v1, fid_v2, fid_p, fid_h};

% A dialog to stop the loop
MessageBox = msgbox( 'Stop DataStream Client', 'Test data save' );

start(t);

while ~ishandle( MessageBox )
   stop(t);
   fclose(fid_v1);
   fclose(fid_v2);
   fclose(fid_p);
   fclose(fid_h);
   fclose(s);
   delete(instrfindall);
end

