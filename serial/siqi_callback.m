function siqi_callback(obj, event, s, h, ax, startTime, fid_v1, fid_v2, fid_p, fid_h)      
   flushinput(s); 
%    readasync(s)   
%    value_1 = fscanf(s, "%d s1");  
   
%    buf_len = 11;
%    taps = 5;
   value_1 = fscanf(s, "%da\n");
   value_2 = fscanf(s, "%db\n");
   value_3 = fscanf(s, "%dc\n");
%    value_4 = fscanf(s, "%dd\n");
   
   if ~isempty(value_1) && ~isempty(value_2) && ~isempty(value_3) && ... 
           ~ischar(value_1) && ~ischar(value_2) && ~ischar(value_3)
       
        currentTime =  datetime('now','Format','HH:mm:ss.SSSSSS');
        diff = datenum(currentTime) - datenum(startTime);
        t = datetime(datevec(diff),'Format','HH:mm:ss.SSSSSS');   
       
        % Add points to animation

        addpoints(h, diff*3600*24, value_3);

        fprintf(fid_v1,'%.6f, %4.4f\n', diff*3600*24, value_1);
        fprintf(fid_v2,'%.6f, %4.4f\n', diff*3600*24, value_2);
        fprintf(fid_p,'%.6f, %4.4f\n', diff*3600*24, value_3);
%         fprintf(fid_h,'%.6f, %4.4f\n', diff*3600*24, value_4);
     

       ax.XLim = datenum([diff-seconds(15) diff])*3600*24;


        datetick('x','keeplimits');
        drawnow limitrate;
   end
%    value_3 = fscanf(s, "%d s3");
%    value_4 = fscanf(s, "%d s4");
  
end
