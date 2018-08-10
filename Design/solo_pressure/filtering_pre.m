% 757 950 814
data_2 = xlsread('test_day_pressure_right_per.xlsx',1,'B2:B814');
data_1 = xlsread('test_day_pressure_right_per.xlsx',1,'A2:A814');

loess = smooth(data_2,17,'loess',2);
% plot(data_1,loess);

matrix = [data_1 loess];
xlswrite('test_day_pressure_right_per.csv',matrix,'Sheet1');
