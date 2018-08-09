%% 

a=arduino;

%% Read the analog input from Arduino
% 
res_rest = 270;

v_1 = readVoltage(a, 'A0');
res_origin = res_rest / (5 / v_1 - 1);

fprintf('The voltage of A0 is:\n  %.4f V\n',v_1);
fprintf('The orginal resistance is:\n  %.4f ohm\n',res_origin);

%% Acquire and display live data
figure(1)
h_voltage_1 = animatedline;
ax = gca;
ax.YGrid = 'on';
ax.YLim = [0 3.3];

figure(2)
h_res = animatedline;
cx = gca;
cx.YGrid = 'on';
cx.YLim = [0 3];

% figure(3)
% h_diff = animatedline;
% dx= gca;
% dx.YGrid = 'on';
% dx.YLim = [0 1];

res_rest = 270;

v_1 = readVoltage(a, 'A0');
res_origin = res_rest / (5 / v_1 - 1);

fprintf('The voltage of A0 is:\n  %.4f V\n',v_1);
fprintf('The orginal resistance is:\n  %.4f ohm\n',res_origin);

stop = false;
startTime = datetime('now');

buf_len = 15;
index = 1:buf_len;

flag_len = 2;
buff_flag = zeros(flag_len, 1);

buff_data_1 = zeros(buf_len, 1);
buff_data_filtered_1 = zeros(buf_len, 1);

buff_data_2 = zeros(buf_len, 1);
buff_data_filtered_2 = zeros(buf_len, 1);

flag = 0; % moving

difference = 0;

taps = 5;

MessageBox = msgbox( 'Stop DataStream Client', 'Test data save' );

while ishandle( MessageBox )
    % Read current voltage value
    
%     v_1 = 0.9 * readVoltage(a, 'A0')  + 0.1 * v_1;
    v_1 = readVoltage(a, 'A0');
    buff_data_1 = [buff_data_1(2:end) ; v_1]; 
    buff_data_filtered_1 = mean(buff_data_1(buf_len : -1 : buf_len-taps+1));
    difference = max(diff(buff_data_1));
    
    res = res_rest / (5 / v_1 - 1);
    res_percent = (res - res_origin) / res_origin;
  
%     buff_data_filtered_1 = v_1;
    % Calculate temperature from voltage (based on data sheet)
    % Get current time
    t =  datetime('now') - startTime;
    
    % Add points to animation
    addpoints(h_voltage_1, datenum(t), v_1);
    addpoints(h_res, datenum(t), res_percent);
%     addpoints(h_diff, datenum(t), difference);
    
    % Update axes
    ax.XLim = datenum([t-seconds(15) t]);
    cx.XLim = datenum([t-seconds(15) t]);
%     dx.XLim = datenum([t-seconds(15) t]);
    
    datetick('x','keeplimits')
    drawnow
    % Check stop condition
%     stop = readDigitalPin(a,'D12');
end


%% Draw the plot
[timeLogs, volLogs_1] = getpoints(h_voltage_1);
[timeLogs, resLogs_percent] = getpoints(h_res);
% [timeLogs, resLogs_diff] = getpoints(h_diff);

timeSecs = (timeLogs-timeLogs(1))*24*3600;

smoothedVol_1 = smooth(volLogs_1, 25);
smoothedVol_2 = smooth(volLogs_1, 15);
smoothedVol_3 = smooth(volLogs_1, 5);

figure(1)
plot(timeSecs,volLogs_1)
hold on
plot(timeSecs,smoothedVol_1, 'r')
hold on
plot(timeSecs,smoothedVol_2, 'g')
hold on
plot(timeSecs,smoothedVol_3, 'b')
xlabel('Elapsed time (sec)')
ylabel('Voltage (V)')

figure(2)
plot(timeSecs,resLogs_percent)
xlabel('Elapsed time (sec)')
ylabel('R/R_origin (%)')

% figure(3)
% plot(timeSecs,resLogs_diff)
% xlabel('Elapsed time (sec)')
% ylabel('Diff')

%% Save to file

T = table(timeSecs', volLogs_1','VariableNames',{'Time','Voltage_0'});
filename_1 = 'LPF_previous_direc_10times_blue_15_3_20_20_20_stop5_spe10_vol.xlsx';
% Write table to file 
writetable(T,filename_1)
% Print confirmation to command line
fprintf('Results table with %g voltage measurements saved to file %s\n',...
    length(timeSecs), filename_1)

T = table(timeSecs', resLogs_percent','VariableNames',{'Time','Res_percent'});
filename_4 = 'LPF_previous_direc_10times_blue_15_3_20_20_20_stop5_spe10_pre.xlsx';
% Write table to file 
writetable(T,filename_4)
% Print confirmation to command line
fprintf('Results table with %g voltage measurements saved to file %s\n',...
    length(timeSecs), filename_4)
