% 847 369 404 721
data_2 = xlsread('pre_1_layer_per.xlsx',1,'B2:B847')-0.038435+0.0095731-0.0017727;
data_1 = xlsread('pre_1_layer_per.xlsx',1,'A2:A847')-19.96-5.0387-2.9581;
sgf = sgolayfilt(data_2,1,11);
matrix = [data_1 sgf];
xlswrite('pre_1_layer_sg.csv',matrix,'Sheet1');
