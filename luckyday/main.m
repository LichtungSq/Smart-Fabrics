%input: startpoint_1 startpoint_2

sensor1_tmp = load('new_strain_1.txt');
sensor2_tmp = load('new_strain_2.txt');
pressure_tmp = load('new_pressure.txt');
kinect_tmp = load('output_luckyday_2.txt');

t_1 = sensor1_tmp(:,1);
sensor1 = sensor1_tmp(:,2);
t_2 = sensor2_tmp(:,1);
sensor2 = sensor2_tmp(:,2);
t_k = kinect_tmp(:,1);
kinect = kinect_tmp(:,end);

sensor1_loess = smooth(sensor1,11,'rlowess',2);
sensor2_loess = smooth(sensor2,11,'rlowess',2);

mode_1 = pre2mode(pressure_tmp);
% mode_2 = strain_sensor2mode(sensor2_tmp);

% sensor1_per = ((1023-startpoint_1)*sensor1_loess/startpoint_1/(1023-sensor1_loess)-1);
% sensor2_per = ((1023-startpoint_2)*sensor2_loess/startpoint_2/(1023-sensor2_loess)-1);

% if mode_1 == 30 && mode_2 == 30
    