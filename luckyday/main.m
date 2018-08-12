sensor1_tmp = load('new_strain_1.txt');
sensor2_tmp = load('new_strain_2.txt');
kinect_tmp = load('output_luckyday_2.txt');
pressure_tmp = load('new_pressure.txt');

t_1 = sensor1_tmp(:,1);
sensor1 = sensor1_tmp(:,2);
t_2 = sensor2_tmp(:,1);
sensor2 = sensor2_tmp(:,2);
t_k = kinect_tmp(:,1);
kinect = kinect_tmp(:,end);

sensor1_loess = smooth(sensor1,11,'rlowess',2);
sensor2_loess = smooth(sensor2,11,'rlowess',2);

mode = pre2mode(pressure_tmp);