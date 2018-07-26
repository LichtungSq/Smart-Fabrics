function ReceiveCallback(obj, event, s, h1, h2, h3, h4, ax1, ax2, ax3, ax4,...
    v1_start_point, v2_start_point, p_start_point, h_start_point, startTime, fid_v1, fid_v2, fid_p, fid_h)         
   flushinput(s)  
   global buffer
%    /dev/cu.usbmodem1411
%    readasync(s)      
%    buf_len = 11;
%    taps = 5;
%    buf_len = get(gcbl, 'Userdata');
%    buf_data_1 = get(gcbd, 'Userdata');
%    buf_data_filtered_1 = get(gcbf, 'Userdata');
   value_1 = fscanf(s, "%da\n");
   value_2 = fscanf(s, "%db\n");
   value_3 = fscanf(s, "%dc\n");
   value_4 = fscanf(s, "%dd\n");
      
   if ~ischar(value_2) && ~ischar(value_1) && ~ischar(value_3) && ~ischar(value_4)...
          && ~isempty(value_2) && ~isempty(value_1) && ~isempty(value_3) && ~isempty(value_4)
%       
       if value_1 > v1_start_point
           value_1 = 100*((255-v1_start_point)*value_1/v1_start_point/(255-value_1)-1);
       else
           value_1 = 0;
       end
       if value_2 > v2_start_point
           value_2 = 100*((255-v2_start_point)*value_2/v2_start_point/(255-value_2)-1);
       else
           value_2 = 0; 
       end
       if value_3 < p_start_point
           value_3 = 100*(1-(255-p_start_point)*value_3/p_start_point/(255-value_3));
       else
           value_3 = 0;
       end
       if value_4 > h_start_point
           value_4 = 100*((255-h_start_point)*value_4/h_start_point/(255-value_4)-1);
       else
           value_4 = 0;
       end

       currentTime =  datetime('now','Format','HH:mm:ss.SSSSSS');
       diff = datenum(currentTime) - datenum(startTime);
       t = datetime(datevec(diff),'Format','HH:mm:ss.SSSSSS');
       fprintf(fid_v1,'%s, %4.4f\n\t', t, value_1);
       fprintf(fid_v2,'%s, %4.4f\n\t', t, value_2);
       fprintf(fid_p,'%s, %4.4f\n\t', t, value_3);
       fprintf(fid_h,'%s, %4.4f\n\t', t, value_4);       
       
       buffer.buf_data(:,1) = [buffer.buf_data(2:end,1); value_1];
       buffer.buf_data(:,2) = [buffer.buf_data(2:end,2); value_2];
       buffer.buf_data(:,3) = [buffer.buf_data(2:end,3); value_3];
       buffer.buf_data(:,4) = [buffer.buf_data(2:end,4); value_4];
       
       if buffer.buf_data(1,1) ~= 0
           buffer.buf_data_filtered(:,1) = sgolayfilt(double(buffer.buf_data(:,1)),1,11);
       end
       if buffer.buf_data(1,2) ~= 0
           buffer.buf_data_filtered(:,2) = sgolayfilt(double(buffer.buf_data(:,2)),1,11);
       end 
       if buffer.buf_data(1,3) ~= 0
           buffer.buf_data_filtered(:,3) = sgolayfilt(double(buffer.buf_data(:,3)),1,11);
       end 
       if buffer.buf_data(1,4) ~= 0
           buffer.buf_data_filtered(:,4) = sgolayfilt(double(buffer.buf_data(:,4)),1,11);
       end
       
       buffer.buf_data_filtered(buffer.buf_data_filtered > 200) = 200;

%        Add points to animation
       addpoints(h1, diff*3600*24, buffer.buf_data_filtered(buffer.buf_len,1));
       addpoints(h2, diff*3600*24, buffer.buf_data_filtered(buffer.buf_len,2));
       addpoints(h3, diff*3600*24, buffer.buf_data_filtered(buffer.buf_len,3));
       addpoints(h4, diff*3600*24, buffer.buf_data_filtered(buffer.buf_len,4));

%        addpoints(h1, diff*3600*24, value_1);
%        addpoints(h2, diff*3600*24, value_2);
%        addpoints(h3, diff*3600*24, value_3);
%        addpoints(h4, diff*3600*24, value_4);


       ax1.XLim = datenum([diff-seconds(15) diff])*3600*24;
       ax2.XLim = datenum([diff-seconds(15) diff])*3600*24;
       ax3.XLim = datenum([diff-seconds(15) diff])*3600*24;
       ax4.XLim = datenum([diff-seconds(15) diff])*3600*24;

       datetick('x','keeplimits')
       drawnow limitrate
   end
%    data = struct('len',25,'buf_1',buf_data_1,'buf_filtered_1', buf_data_filtered_1);
%    obj.Userdata = data;
%    set(gcbl, 'Userdata', buf_len);
%    set(gcbd, 'Userdata', buf_data_1);
%    set(gcbf, 'Userdata', buf_data_filtered_1);   
end
