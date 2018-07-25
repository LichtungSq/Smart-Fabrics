function ReceiveCallback(obj, event, s, h, ax, startTime, fid)      
   flushinput(s)   
%    readasync(s)   
%    value_1 = fscanf(s, "%d s1");  
   
%    buf_len = 11;
%    taps = 5;
   value_1 = fscanf(s, "%d s1");
   value_2 = fscanf(s, "%d s2");
   value_3 = fscanf(s, "%d s3");
   value_4 = fscanf(s, "%d s4");
   
   if ~isempty(value_2)
       currentTime =  datetime('now','Format','HH:mm:ss.SSSSSS') - startTime;
       diff = datenum(currentTime) - datenum(startTime);
       t = datetime(datevec(diff),'Format','HH:mm:ss.SSSSSS');
       fprintf(fid,'%s, %d\n\t', t, value_2);

        % Add points to animation
       addpoints(h, datenum(t), double(value_2));
    %     addpoints(h, datenum(t), value_2);
    %     addpoints(h, datenum(t), value_3);
    %     addpoints(h, datenum(t), value_4);

       ax.XLim = datenum([t-seconds(15) t]);

       datetick('x','keeplimits')
       drawnow limitrate
   end
%    value_3 = fscanf(s, "%d s3");
%    value_4 = fscanf(s, "%d s4");
  
end
