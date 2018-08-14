% force_data = xlsread('bare_15_1_60_120_force.xlsx');
per_data = xlsread('previous_direc_10times_blue_15_3_20_20_20_stop5_spe10_pre.xlsx');
% med = xlsread('med_3W15L_drag30_spd15');
% long = xlsread('long_3W15L_drag30_spd15');

% force = force_data(:,1);
% smoothed_forth = smooth(force, 200);
% time_forth = force_data(:,2);

per = smooth(per_data(:,2), 15);
time_per = per_data(:,1);

% 
% force_med = med(:,1);
% smoothed_force_med = smooth(force_med, 45);
% extension_med = med(:,2) * 4;
% 
% force_long = long(:,1);
% smoothed_force_long = smooth(force_long, 45);
% extension_long = long(:,2) * 4;

% N = length(extension);

%% with trean freq analysis
% subplot(211);
% plot(time_forth,smoothed_forth,'k');  
% grid;
% title('Force vs Time');
% xlabel('Time/s'); ylabel('Force/N');

subplot(212);
plot(time_per,per,'k');  
grid;
title('Res vs Time (med)');
xlabel('Time/s'); ylabel('Res Ratio/N');

% subplot(313);
% plot(extension_long,smoothed_force_long,'k');  
% grid;
% title('Force vs Time (long)');
% xlabel('Time/s'); ylabel('Force/N');

% subplot(212);
% plot(time,res_per,'k');  
% xlim([0, 300]);
% grid;
% title('Res vs Time');
% xlabel('Time/s'); ylabel('Res/ohm');
%%
% T = table(time_forth, smoothed_forth,'VariableNames',{'Time','Force'});
% filename_1 = 'edit_l15w3_65_30_force.xlsx';
% % Write table to file 
% writetable(T,filename_1)
% % Print confirmation to command line
% fprintf('Results table with %g voltage measurements saved to file %s\n',...
%     length(time_forth), filename_1)

T = table(time_per, per,'VariableNames',{'Time','Res_percent'});
filename_4 = 'edit_bare_15_1_30_150_per.xlsx';
% Write table to file 
writetable(T,filename_4)
% Print confirmation to command line
fprintf('Results table with %g voltage measurements saved to file %s\n',...
    length(time_per), filename_4)

