A_t = timeSecs(2:497)-0.5432;
A = smoothedPer(2:497);
B_t = timeSecs(996) - timeSecs(498:996);
B = smoothedPer(498:996,1);
B_t = fliplr(B_t);
B = flipud(B);
% f(x) = 0.9443 * exp(-0.01823*x) - 0.9853 * exp(-0.1055*x)
% f(x) = 0.2134*exp(-((x-16.44)/9.778)^2) + 0.4955*exp(-((x-34.2)/17.81)^2)
C_t = timeSecs(386:end)-32.7646;
C = smoothedPer(386:end)-0.5726;
C_loess = smooth(C,15,'rlowess',2);
plot(C_t,C_loess);
% f(x) = 0.0233 * exp(-0.04591*x) - 0.0233

loess = smooth(smoothedPer,21,'rlowess',2);
plot(timeSecs,smoothedPer);
matrix = [timeSecs' loess];
xlswrite('relaxation.csv',matrix,'Sheet1');