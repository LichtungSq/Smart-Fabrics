%input: startpoint_1 startpoint_2
% startpoint_1 = ;
% startpoint_2 = ;
% endpoint_1 = ;
% endpoint_2 = ;
% f1(x) = 0.9443 * exp(-0.01823*x) - 0.9853 * exp(-0.1055*x)
% f1(x) = 0.588*exp(0.3993*x)/(9.803+exp(0.4051*x))
% f2(x) = 0.2134*exp(-((x-16.44)/9.778)^2) + 0.4955*exp(-((x-34.2)/17.81)^2)
% f3(x) = 0.0233 * exp(-0.04591*x) - 0.0233
sensor1_tmp = load('new_strain_1.txt');
sensor2_tmp = load('new_strain_2.txt');
pressure_tmp = load('new_pressure.txt');
kinect_tmp = load('output_luckyday_3.txt');


t_1 = sensor1_tmp(:,1);
sensor1 = sensor1_tmp(:,2);
t_2 = sensor2_tmp(:,1);
sensor2 = sensor2_tmp(:,2);
t_k = kinect_tmp(:,1);
kinect = kinect_tmp(:,end);

slope_cmp = 0.2 * t_2;

sensor1_loess = smooth(sensor1,51,'rlowess',2);
sensor2_loess = smooth(sensor2 + slope_cmp,51,'rlowess',2);

% findpeak
startpoint_1 = min(sensor1_loess);
startpoint_2 = min(sensor2_loess);

[mode_1, pressure_per, holding_point] = pre2mode(pressure_tmp);
mode_2 = strain_sensor2mode(sensor2_tmp);
up_point = find(holding_point == 1);
move_locs = find(mode_1 ~= 0);

sensor1_per = 1023.*(sensor1_loess-startpoint_1)/startpoint_1./(1023-sensor1_loess);
sensor2_per = 1023.*(sensor2_loess-startpoint_2)/startpoint_2./(1023-sensor2_loess);

stretch = zeros(length(sensor2),1);
% fun_longer = 0.9443 * exp(-0.01823*x) - 0.9853 * exp(-0.1055*x);

for i = 1:length(sensor2)  
    
    if mode_1(i) > 0 && mode_2(i) > 0
        syms x
        stretch(i) = fsolve(@(x) 0.9443 * exp(-0.01823*x) - 0.9853 * exp(-0.1055*x) - sensor2_per(i), 10);
%         [0 20.6]
    end
    
    if mode_1(i) > 0 && mode_2(i) < 0
        syms x
        stretch(i) = fsolve(@(x) 0.9443 * exp(-0.01823*x) - 0.9853 * exp(-0.1055*x) - sensor2_per(i), 40);
%         [20.6 40.6]
    end
    
    if mode_1(i) < 0 && mode_2(i) > 0
        syms x
        stretch(i) = fsolve(@(x) 0.2134*exp(-((x-16.44)/9.778)^2) + 0.4955*exp(-((x-34.2)/17.81)^2) - sensor2_per(i), 40);
%         [0 32.75]
    end
    
    if mode_1(i) < 0 && mode_2(i) < 0
        syms x
        stretch(i) = fsolve(@(x) 0.2134*exp(-((x-16.44)/9.778)^2) + 0.4955*exp(-((x-34.2)/17.81)^2) - sensor2_per(i), 20);
%         [32.75 41.08]
    end
    
    if abs(mode_1(i)) < 0.1 && pressure_per(i) < -0.15
        j = length(find(up_point <= i));
        k = length(find(move_locs <= i));
        if j > 0
%             compensated_value = sensor2_per(i) - 0.0233 * exp(-0.04591*(t_2(i) - t_2(up_point(j)))) - 0.0233;
            compensated_value = 0;
        else
            compensated_value = 0;
        end
        
        if k > 0
            if move_locs(k) > 0
            syms x
            stretch(i) = fsolve(@(x) 0.9443 * exp(-0.01823*x) - 0.9853 * exp(-0.1055*x) - (sensor2_per(i) + compensated_value), 10);
            else
            syms x
            stretch(i) = fsolve(@(x) 0.2134*exp(-((x-16.44)/9.778)^2) + 0.4955*exp(-((x-34.2)/17.81)^2)...
                - (sensor2_per(i) + compensated_value), 20);
            end
        else
            stretch(i) = fsolve(@(x) 0.9443 * exp(-0.01823*x) - 0.9853 * exp(-0.1055*x) - sensor2_per(i), 10);
        end
    end        
end  



