fs = 1000;

pred = xlsread('pred_angle.xlsx');
gt = xlsread('angle_X.xlsx');

time_stamp = pred(1:end,1);
raw_pred_angle = pred(1:end,2);

pred_angle = [raw_pred_angle(5:end);0;0;0;0];

gt_angle = gt(1:end,2);


pred_angle = pred_angle;

differ = abs(pred_angle - gt_angle);

[x,f] = ecdf(differ);

subplot 211;

plot(time_stamp, pred_angle);
xlim([0 100]);
hold on
plot(time_stamp, gt_angle);
xlim([0 100]);
hold on
% plot(time_stamp, differ);
% xlim([0 100]);

subplot 212;
plot(f,x);
