function flag = strain_sensor2mode(strain_tmp)
% flag -- time*1
t = strain_tmp(:,1);
strain = strain_tmp(:,2);
<<<<<<< HEAD
strain_loess = smooth(strain,17,'rlowess',2);
=======
strain_loess = smooth(strain,15,'rlowess',2);

>>>>>>> d4fe90dd61f80aae8dff866d2ea8dbba49b37e01

buffer = [0;strain_loess(1:7,1)];
flag = zeros(length(strain_loess),1);
for i = 0:length(strain_loess)-length(buffer)
    
    buffer = [buffer(2:end);strain_loess(i+length(buffer))];
    [r,k,b] = regression(t(i+1:i+length(buffer))', buffer');
    
    if k > 20
        flag(i+1:i+length(buffer),1) = 1;
    end
    if k < -20
        flag(i+1:i+length(buffer),1) = -1;
    end
end

<<<<<<< HEAD
hold on
plot(t,strain_loess-930,'k');
% line([0 80],[200 200],'-r');
plot(t,flag,'r');
=======
% figure(2)
% hold on
% plot(t,strain_loess,'k');
% % line([0 80],[200 200],'-r');
% plot(t,flag+600,'r');
>>>>>>> d4fe90dd61f80aae8dff866d2ea8dbba49b37e01
