% 847 369 404 721
data_2 = xlsread('thick_pre_2_layer_per.xlsx',1,'B2:B721')-0.0036857;
data_1 = xlsread('thick_pre_2_layer_per.xlsx',1,'A2:A721')-9.9823;
sgf = sgolayfilt(data_2,1,17);
matrix = [data_1*0.6/10 sgf];
xlswrite('thick_pre_2_layer_sg.csv',matrix,'Sheet1');
