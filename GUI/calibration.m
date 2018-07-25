function [calibrated_val_bending, calibrated_val_rotation] = calibration()

a = arduino;
% list = seriallist;
% 
% s = serial(list(3));
% set(s, 'DataBits', 8);
% set(s, 'StopBits', 1);
% set(s, 'BaudRate', 115200);
% set(s, 'timeout', 10);
% set(s, 'terminator', 'LF');
% set(s, 'Parity', 'none');
% 
% fopen(s);

waitbarH = waitbar(0, 'Sampling the data...', 'Name', 'Calibration');

bending = 0;
rotation = 0;

N = 100;

v_1 = 0;

buf_len = 50;
index = 1:buf_len;

buff_data_bending = zeros(buf_len, 1);
buff_data_filtered_bending = zeros(buf_len, 1);

buff_data_rotation = zeros(buf_len, 1);
buff_data_filtered_rotation = zeros(buf_len, 1);


taps = 15;

for k = 1:N
    bending = readVoltage(a, 'A1');
    rotation = readVoltage(a, 'A0');
    
%     data = fgetl(s);
%     if isempty(data)
%         continue;
%     end
%     data = regexp(data, '\s*', 'split');
%     bending = str2double(data(1,1)) / 1024 * 3.3;
%     rotation = str2double(data(1,2)) / 1024 * 3.3;
   
    buff_data_bending = [buff_data_bending(2:end); bending];
    buff_data_filtered_bending = mean(buff_data_bending(buf_len : -1 : buf_len-taps+1));
    
    buff_data_rotation = [buff_data_rotation(2:end); rotation];
    buff_data_filtered_rotation = mean(buff_data_rotation(buf_len : -1 : buf_len-taps+1));
%     
    waitbar(k/N, waitbarH); 
end

calibrated_val_bending = buff_data_filtered_bending;
calibrated_val_rotation = buff_data_filtered_rotation;

% fclose(instrfind);

close(waitbarH);

clear a;

end

