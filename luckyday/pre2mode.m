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
        flag(i+1:i+length(buffer),1) = -30;
    end
    if k < -10
        flag(i+1:i+length(buffer),1) = 30;
    end
end

hold on
plot(t,pressure_loess,'k');
% line([0 80],[200 200],'-r');
plot(t,flag+960,'r');