% 877
data_2 = xlsread('test_day_vertical_strain_right_per.xlsx',1,'B2:B877');
data_1 = xlsread('test_day_vertical_strain_right_per.xlsx',1,'A2:A877');

loess = smooth(data_2,15,'loess',2);
% plot(data_1,loess);

matrix = [data_1 loess];
xlswrite('test_day_vertical_strain_right_per.csv',matrix,'Sheet1');
