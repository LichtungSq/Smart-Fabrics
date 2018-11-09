fs = 1000;

gt_X = xlsread('vicon_X60.xlsx');
gt_Y = xlsread('vicon_Y60.xlsx');
gt_Z = xlsread('vicon_Z60.xlsx');


% pred_angle = [raw_pred_angle(5:end);0;0;0;0];

time_stamp = gt_X(:,1);

gt_angle_X = gt_X(:,2);
gt_angle_Y = gt_Y(:,2);
gt_angle_Z = gt_Z(:,2);
% pred_angle = (raw_pred_angle_horizontal) + 50;

% differ = abs(pred_angle - gt_angle_Y);
% 
% [x,f] = ecdf(differ);

subplot 311;

% plot(time_stamp, pred_angle,'Color','r');
% % xlim([10 100]);
% hold on
% plot(time_stamp, raw_pred_angle_horizontal,'Color','g');
% hold on
plot(time_stamp, gt_angle_X, 'Color','b');
ylim([-90 90])
hold on

subplot 312;
plot(time_stamp, gt_angle_Y, 'Color','b');
ylim([-90 90])

subplot 313;
plot(time_stamp, gt_angle_Z, 'Color','b');
ylim([-90 90])
% % xlim([10 100]);
% hold on
% plot(time_stamp, differ);
% xlim([10 100]);

% subplot 212;
% plot(f,x);
