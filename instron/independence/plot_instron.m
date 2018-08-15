force_data = xlsread('course_l15w2_30_30_force.xlsx');
per_data = xlsread('course_l15w2_30_30_per.xlsx');
% med = xlsread('med_3W15L_drag30_spd15');
% long = xlsread('long_3W15L_drag30_spd15');

force = force_data(:,1);
smoothed_forth = smooth(force, 200);
time_forth = force_data(:,2) * 4;

per = smooth(per_data(:,2), 45);
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
subplot(211);
plot(time_forth,smoothed_forth,'k');  
grid;
title('Force vs Time');
xlabel('Time/s'); ylabel('Force/N');

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
