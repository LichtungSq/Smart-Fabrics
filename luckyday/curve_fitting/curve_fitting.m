A_t = timeSecs(2:497)-0.5432;
A = smoothedPer(2:497);
B_t = timeSecs(996) - timeSecs(498:996);
B = smoothedPer(498:996,1);
B_t = fliplr(B_t);
B = flipud(B);
% f1(x) = 0.9443 * exp(-0.01823*x) - 0.9853 * exp(-0.1055*x)
% f1(x) = 0.588*exp(0.3993*x)/(9.803+exp(0.4051*x))
% f2(x) = 0.2134*exp(-((x-16.44)/9.778)^2) + 0.4955*exp(-((x-34.2)/17.81)^2)
C_t = timeSecs(386:end)-32.7646;
C = smoothedPer(386:end)-0.5726;
C_loess = smooth(C,15,'rlowess',2);
plot(C_t,C_loess);
% f3(x) = 0.0233 * exp(-0.04591*x) - 0.0233

% loess = smooth(smoothedPer,21,'rlowess',2);
% y = 0.0233*exp(-0.04591*(timeSecs'-32.7646))+0.5493;
% hold on
% plot(timeSecs,smoothedPer);
% plot(timeSecs,y);
% matrix = [timeSecs' loess];
% matrix_1 = [timeSecs' y];
% xlswrite('relaxation.csv',matrix,'Sheet1');
% xlswrite('curve.csv',matrix_1,'Sheet1');