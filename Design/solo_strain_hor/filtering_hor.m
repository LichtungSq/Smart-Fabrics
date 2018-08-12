% 777 822 787
data_2 = xlsread('test_day_hor_strain_low_per.xlsx',1,'B2:B822');
data_1 = xlsread('test_day_hor_strain_low_per.xlsx',1,'A2:A822');

loess = smooth(data_2,15,'rloess',2);
% plot(data_1,loess);

matrix = [data_1 loess];
xlswrite('test_day_hor_strain_low_per.csv',matrix,'Sheet1');
