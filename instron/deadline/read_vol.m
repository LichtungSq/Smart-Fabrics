%% 

a = arduino;

%% Read the analog input from Arduino

res_rest = 200;

v_1 = readVoltage(a, 'A0');
res_origin = res_rest / (5 / v_1 - 1);

fprintf('The voltage of A0 is:\n  %.4f V\n',v_1);
fprintf('The orginal resistance is:\n  %.4f ohm\n',res_origin);

%% Acquire and display live data
figure(1)
h_voltage_1 = animatedline;
ax = gca;
ax.YGrid = 'on';
ax.YLim = [0 5];

figure(2)
h_res = animatedline;
cx = gca;
cx.YGrid = 'on';
cx.YLim = [0 10];

res_rest = 200;

v_1 = readVoltage(a, 'A0');
res_origin = res_rest / (5 / v_1 - 1);

fprintf('The voltage of A0 is:\n  %.4f V\n',v_1);
fprintf('The orginal resistance is:\n  %.4f ohm\n',res_origin);

stop = false;
startTime = datetime('now');

buf_len = 15;
index = 1:buf_len;
% 
buff_data_vol = zeros(buf_len, 1);
buff_data_filtered_vol = zeros(buf_len, 1);

buff_data_per = zeros(buf_len, 1);
buff_data_filtered_per = zeros(buf_len, 1);

flag = 0; % moving

difference = 0;

taps = 5;

while ~stop
    % Read current voltage value
    
% %     v_1 = 0.9 * readVoltage(a, 'A0')  + 0.1 * v_1;
    v_2 = readVoltage(a, 'A0');
    buff_data_vol = [buff_data_vol(2:end) ; v_2]; 
    buff_data_filtered_vol = mean(buff_data_vol(buf_len : -1 : buf_len-taps+1));
% %     difference = max(diff(buff_data_1));
%     
    res = res_rest / (5 / v_2 - 1);
    res_percent = (res - res_origin) / res_origin;
    buff_data_per = [buff_data_per(2:end) ; res_percent]; 
    buff_data_filtered_per = mean(buff_data_per(buf_len : -1 : buf_len-taps+1));
  
%     buff_data_filtered_1 = v_1;
    % Calculate temperature from voltage (based on data sheet)
    % Get current time
    t =  datetime('now') - startTime;
    
    % Add points to animation
    addpoints(h_voltage_1, datenum(t), buff_data_filtered_vol);
    addpoints(h_res, datenum(t), buff_data_filtered_per);
%     addpoints(h_diff, datenum(t), difference);
    
    % Update axes
    ax.XLim = datenum([t-seconds(15) t]);
    cx.XLim = datenum([t-seconds(15) t]);
%     dx.XLim = datenum([t-seconds(15) t]);
    
    datetick('x','keeplimits')
    drawnow
    % Check stop condition
    stop = readDigitalPin(a,'D12');
end


%% Draw the plot
[timeLogs, volLogs_1] = getpoints(h_voltage_1);
[timeLogs, resLogs_percent] = getpoints(h_res);
% [timeLogs, resLogs_diff] = getpoints(h_diff);

timeSecs = (timeLogs-timeLogs(1))*24*3600;
% 

smoothedVol = smooth(volLogs_1, 5);
smoothedPer = smooth(resLogs_percent, 5);

figure(1)
plot(timeSecs,volLogs_1)
% hold on
% plot(timeSecs,smoothedVol, 'g')
% hold on
% plot(timeSecs,smoothedVol_3, 'b')
xlabel('Elapsed time (sec)')
ylabel('Voltage (V)')

figure(2)
plot(timeSecs,resLogs_percent)
% hold on
% plot(timeSecs,smoothedPer, 'r')
xlabel('Elapsed time (sec)')
ylabel('R/R_origin (%)')

% figure(3)
% plot(timeSecs,resLogs_diff)
% xlabel('Elapsed time (sec)')
% ylabel('Diff')

%% Save to file
T = table(timeSecs', smooth(volLogs_1, 5),'VariableNames',{'Time','Voltage_0'});
filename_1 = 'luckyday_vol_30_30.xlsx';
% Write table to file 
writetable(T,filename_1)
% Print confirmation to command line
fprintf('Results table with %g voltage measurements saved to file %s\n',...
    length(timeSecs), filename_1)

T = table(timeSecs', smooth(resLogs_percent, 5),'VariableNames',{'Time','Res_percent'});
filename_4 = 'luckyday_per_30_30.xlsx';
% Write table to file 
writetable(T,filename_4)
% Print confirmation to command line
fprintf('Results table with %g voltage measurements saved to file %s\n',...
    length(timeSecs), filename_4)
