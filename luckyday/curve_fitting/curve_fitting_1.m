A_t = timeSecs(2:413)-0.6125;
% A_t = timeSecs(2:end);
A = smoothedPer(2:413)-0.005;
% A = smoothedPer(2:end);
A = smooth(A,45,'rlowess',2);

t = (0:0.01:33);
y = (0.3781*exp(0.5616*t)./(94.81+exp(0.5667*t))).^0.5;

hold on
plot(t, y);
plot(A_t, A);

matrix = [A_t' A];
matrix_1 = [t' y'];
xlswrite('relaxation_new.csv',matrix,'Sheet1');
xlswrite('curve_new.csv',matrix_1,'Sheet1');