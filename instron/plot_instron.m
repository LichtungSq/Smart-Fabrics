short = xlsread('short_3W15L_drag30_spd15.xlsx');
med = xlsread('med_3W15L_drag30_spd15');
long = xlsread('long_3W15L_drag30_spd15');

force_short = short(:,1);
smoothed_force_short = smooth(force_short, 45);
extension_short = short(:,2) * 4;

force_med = med(:,1);
smoothed_force_med = smooth(force_med, 45);
extension_med = med(:,2) * 4;

force_long = long(:,1);
smoothed_force_long = smooth(force_long, 45);
extension_long = long(:,2) * 4;

% N = length(extension);

%% with trean freq analysis
subplot(311);
plot(extension_short,smoothed_force_short,'k');  
grid;
title('Force vs Time (short)');
xlabel('Time/s'); ylabel('Force/N');

subplot(312);
plot(extension_med,smoothed_force_med,'k');  
grid;
title('Force vs Time (med)');
xlabel('Time/s'); ylabel('Force/N');

subplot(313);
plot(extension_long,smoothed_force_long,'k');  
grid;
title('Force vs Time (long)');
xlabel('Time/s'); ylabel('Force/N');

% subplot(212);
% plot(time,res_per,'k');  
% xlim([0, 300]);
% grid;
% title('Res vs Time');
% xlabel('Time/s'); ylabel('Res/ohm');
