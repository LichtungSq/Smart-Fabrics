function ReceiveCallback(obj, event, s, h1, h2, h3, h4, ax1, ax2, ax3, ax4,buf_len, buf_data_1, buf_data_filtered_1, startTime, fid)         
   flushinput(s)  
%    /dev/cu.usbmodem1411
%    readasync(s)      
%    buf_len = 11;
%    taps = 5;
%    buf_len = get(gcbl, 'Userdata');
%    buf_data_1 = get(gcbd, 'Userdata');
%    buf_data_filtered_1 = get(gcbf, 'Userdata');
   value_1 = fscanf(s, "%d s1\n");
   value_2 = fscanf(s, "%d s2\n");
   value_3 = fscanf(s, "%d s3\n");
   value_4 = fscanf(s, "%d s4\n");
      
   if ~ischar(value_2) && ~ischar(value_1) && ~ischar(value_3) && ~ischar(value_4)...
          && ~isempty(value_2) && ~isempty(value_1) && ~isempty(value_3) && ~isempty(value_4) 
%        t =  datetime('now','Format','HH:mm:ss.SSSSSS') - startTime;
       currentTime =  datetime('now','Format','HH:mm:ss.SSSSSS');
       diff = datenum(currentTime) - datenum(startTime);
       t = datetime(datevec(diff),'Format','HH:mm:ss.SSSSSS');
       fprintf(fid,'%s, %d\n\t', t, value_1);
       fprintf(fid,'%s, %d\n\t', t, value_2);
       fprintf(fid,'%s, %d\n\t', t, value_3);
       fprintf(fid,'%s, %d\n\t', t, value_4);       
       
       buf_data_1 = [buf_data_1(2:end); value_1];
       if buf_data_1(1) ~= 0
           buf_data_filtered_1 = sgolayfilt(double(buf_data_1),2,7);
       end       

       % Add points to animation
       addpoints(h1, diff*3600*24, buf_data_filtered_1(buf_len));
       addpoints(h2, diff*3600*24, double(value_2));
       addpoints(h3, diff*3600*24, double(value_3));
       addpoints(h4, diff*3600*24, double(value_4));

       ax1.XLim = datenum([diff-seconds(15) diff])*3600*24;
       ax2.XLim = datenum([diff-seconds(15) diff])*3600*24;
       ax3.XLim = datenum([diff-seconds(15) diff])*3600*24;
       ax4.XLim = datenum([diff-seconds(15) diff])*3600*24;

       datetick('x','keeplimits')
       drawnow limitrate
   end 
%    set(gcbl, 'Userdata', buf_len);
%    set(gcbd, 'Userdata', buf_data_1);
%    set(gcbf, 'Userdata', buf_data_filtered_1);   
end
