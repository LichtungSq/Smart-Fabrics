% 777
data_2 = xlsread('test_day_hor_strain_mid_per.xlsx',1,'B2:B777');
data_1 = xlsread('test_day_hor_strain_mid_per.xlsx',1,'A2:A777');

loess = smooth(data_2,15,'rloess',2);
% plot(data_1,loess);

matrix = [data_1 loess];
xlswrite('test_day_hor_strain_mid_per.csv',matrix,'Sheet1');
