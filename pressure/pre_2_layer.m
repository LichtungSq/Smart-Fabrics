% 847 369 404 721
data_2 = xlsread('pre_2_layer_per.xlsx',1,'B2:B369');
data_1 = xlsread('pre_2_layer_per.xlsx',1,'A2:A369');
sgf = sgolayfilt(data_2,1,17);
matrix = [data_1/10 sgf];
xlswrite('pre_2_layer_sg.csv',matrix,'Sheet1');
