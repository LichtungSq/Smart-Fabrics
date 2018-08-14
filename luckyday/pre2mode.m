function flag = pre2mode(pressure_tmp)
% flag -- time*1
t = pressure_tmp(:,1);
pressure = pressure_tmp(:,2);
pressure_loess = smooth(pressure,35,'rlowess',2);


buffer = [0;pressure_loess(1:11,1)];
flag = zeros(length(pressure_loess),1);
for i = 0:length(pressure_loess)-length(buffer)
    
    buffer = [buffer(2:end);pressure_loess(i+length(buffer))];
    [r,k,b] = regression(t(i+1:i+length(buffer))', buffer');
    
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
