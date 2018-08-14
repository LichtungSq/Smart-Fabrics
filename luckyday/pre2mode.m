function [flag, pressure_per, holding_point] = pre2mode(pressure_tmp)
% flag -- time*1
t = pressure_tmp(:,1);
pressure = pressure_tmp(:,2);
pressure_loess = smooth(pressure,35,'rlowess',2);
startpoint = max(pressure_loess);
% disp(startpoint);
pressure_per = 1023.*(pressure_loess-startpoint)/startpoint./(1023-pressure_loess);

buffer = [0;pressure_loess(1:10,1)];
flag = zeros(length(pressure_loess),1);
for i = 0:length(pressure_loess)-length(buffer)
    
    buffer = [buffer(2:end);pressure_loess(i+length(buffer))];
    [r,k,b] = regression(t(i+1:i+length(buffer))', buffer');
    
<<<<<<< HEAD
    if k > 10
        flag(i+1:i+length(buffer),1) = -1;
    end
    if k < -10
        flag(i+1:i+length(buffer),1) = 1;
    end
end

pressure_loess = 0.01 * pressure_loess-9.7;

hold on
plot(t,pressure_loess,'k');
% line([0 80],[200 200],'-r');
plot(t,flag,'r');

%%%
T = table(t, pressure_loess,'VariableNames',{'Time','Pressure'});
filename_1 = 'pressure.xlsx';
% Write table to file 
writetable(T,filename_1)
% Print confirmation to command line
fprintf('Results table with %g voltage measurements saved to file %s\n',...
    length(t), filename_1)

T = table(t, flag,'VariableNames',{'Time','Flag'});
filename_4 = 'flags.xlsx';
% Write table to file 
writetable(T,filename_4)
% Print confirmation to command line
fprintf('Results table with %g voltage measurements saved to file %s\n',...
    length(t), filename_4)
=======
    if k > 8
        flag(i+1:i+length(buffer),1) = -30;
    end
    if k < -8
        flag(i+1:i+length(buffer),1) = 30;
    end
end

holding_point = zeros(length(pressure),1);
holding_tmp = zeros(length(pressure),1);
% for i = 1:length(pressure)
%     if flag(i) == 0 && pressure_per(i) < -0.5
%         holding_tmp(i) = 1;
%         if i > 1 && holding_tmp(i-1) == 0
%             holding_point(i) = 1;
%         end
%     else
%         if holding_tmp(i-1) == 1
%             holding_point(i) = -1;
%         end
%     end 
% end
for i = 1:length(pressure)
    if flag(i) == 0 && pressure_per(i) < -0.5
        holding_tmp(i) = 1;
    end    
end

for i = 2:length(pressure)
    if holding_tmp(i) == 1 && holding_tmp(i-1) ==0 && holding_tmp(i+1) ==0
        holding_tmp(i) = 0;        
    end    
end

for i = 2:length(pressure)
    if  holding_tmp(i) == 1 
        if holding_tmp(i-1) == 0
            holding_point(i) = 1;
        end
    else
        if holding_tmp(i-1) == 1
            holding_point(i) = -1;
        end
    end 
end

figure(1)
hold on
plot(t,pressure_per,'k');
plot(t,holding_point,'r');
% % line([0 80],[200 200],'-r');
% % plot(t,flag+960,'r');
>>>>>>> d4fe90dd61f80aae8dff866d2ea8dbba49b37e01
