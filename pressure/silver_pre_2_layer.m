% 847 369 404 721
data_2 = xlsread('silver_pre_2_layer_per.xlsx',1,'B2:B404')-0.050818;
data_1 = xlsread('silver_pre_2_layer_per.xlsx',1,'A2:A404')-5.385;
sgf = sgolayfilt(data_2,1,17);
matrix = [data_1*1.05/10 sgf*0.92];
xlswrite('silver_pre_2_layer_sg.csv',matrix,'Sheet1');
