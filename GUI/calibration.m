function [calibrated_v1, calibrated_v2, calibrated_p, calibrated_h] = calibration(s)
    flushinput(s);

    set(s, 'DataBits', 8);
    set(s, 'StopBits', 1);
    set(s, 'BaudRate', 9600);
    set(s, 'timeout', 10);
    set(s, 'terminator', 'LF');
    set(s, 'Parity', 'none');
    
    waitbarH = waitbar(0, 'Sampling the data...', 'Name', 'Calibration');

    N = 100;
    taps = 40;
    buf_len = 50;

    buf_data = zeros(buf_len, 4);

    for k = 1:N
       value_1 = fscanf(s, "%da\n");
       value_2 = fscanf(s, "%db\n");
       value_3 = fscanf(s, "%dc\n");
       value_4 = fscanf(s, "%dd\n");

    %     data = fgetl(s);
    %     if isempty(data)
    %         continue;
    %     end
    %     data = regexp(data, '\s*', 'split');
    %     bending = str2double(data(1,1)) / 1024 * 3.3;
    %     rotation = str2double(data(1,2)) / 1024 * 3.3;

        buf_data(:,1) = [buf_data(2:end,1); value_1];
        buf_data(:,2) = [buf_data(2:end,2); value_2];
        buf_data(:,3) = [buf_data(2:end,3); value_3];
        buf_data(:,4) = [buf_data(2:end,4); value_4];
        buf_data_filtered = mean(buf_data(taps : -1 : 1,:));

        waitbar(k/N, waitbarH); 
    end

    calibrated_v1 = buf_data_filtered(1,1);
    calibrated_v2 = buf_data_filtered(1,2);
    calibrated_p = buf_data_filtered(1,3);
    calibrated_h = buf_data_filtered(1,4);

    close(waitbarH);
    fclose(s);
end

