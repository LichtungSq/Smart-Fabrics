function [] = hybridDataPlot(bending_start_point, bending_end_point, rotation_start_point, rotation_end_point, handles)
 
% Calibration Scale Information
scale_bending = 140 / (bending_end_point - bending_start_point);
scale_rotation = 90 / (rotation_end_point - rotation_start_point);
 
% Load all sub folders functions
addpath(genpath(pwd));
 
% Program options
TransmitMulticast = false;
EnableHapticFeedbackTest = false;
HapticOnList = {'ViconAP_001';'ViconAP_002'};
bReadCentroids = false;
bReadRays = false;
axisMapping = 'ZUp';
 
% A dialog to stop the loop
MessageBox = msgbox( 'Stop DataStream Client', 'Vicon DataStream SDK' );
 
% Load the SDK
fprintf( 'Loading SDK...' );
Client.LoadViconDataStreamSDK();
fprintf( 'done\n' );
 
% Program options
HostName = 'localhost:801';
 
% Make a new client
MyClient = Client();
 
% Connect to a server
fprintf( 'Connecting to %s ...', HostName );
while ~MyClient.IsConnected().Connected
    % Direct connection
    MyClient.Connect( HostName );
     
    % Multicast connection
    % MyClient.ConnectToMulticast( HostName, '224.0.0.0' );
     
    fprintf( '.' );
end
fprintf( '\n' );

% Enable some different data types
MyClient.EnableSegmentData();
MyClient.EnableMarkerData();
MyClient.EnableUnlabeledMarkerData();
MyClient.EnableDeviceData();
if bReadCentroids
    MyClient.EnableCentroidData();
end
if bReadRays
    MyClient.EnableMarkerRayData();
end
 
fprintf( 'Segment Data Enabled: %s\n',          AdaptBool( MyClient.IsSegmentDataEnabled().Enabled ) );
fprintf( 'Marker Data Enabled: %s\n',           AdaptBool( MyClient.IsMarkerDataEnabled().Enabled ) );
fprintf( 'Unlabeled Marker Data Enabled: %s\n', AdaptBool( MyClient.IsUnlabeledMarkerDataEnabled().Enabled ) );
fprintf( 'Device Data Enabled: %s\n',           AdaptBool( MyClient.IsDeviceDataEnabled().Enabled ) );
fprintf( 'Centroid Data Enabled: %s\n',         AdaptBool( MyClient.IsCentroidDataEnabled().Enabled ) );
fprintf( 'Marker Ray Data Enabled: %s\n',       AdaptBool( MyClient.IsMarkerRayDataEnabled().Enabled ) );
 
% Set the streaming mode
MyClient.SetStreamMode( StreamMode.ClientPull );
% MyClient.SetStreamMode( StreamMode.ClientPullPreFetch );
% MyClient.SetStreamMode( StreamMode.ServerPush );
 
% Set the global up axis
if axisMapping == 'XUp'
    MyClient.SetAxisMapping( Direction.Up, ...
        Direction.Forward,      ...
        Direction.Left ); % X-up
elseif axisMapping == 'YUp'
    MyClient.SetAxisMapping( Direction.Forward, ...
        Direction.Up,    ...
        Direction.Right );    % Y-up
else
    MyClient.SetAxisMapping( Direction.Forward, ...
        Direction.Left,    ...
        Direction.Up );    % Z-up
end
 
Output_GetAxisMapping = MyClient.GetAxisMapping();
fprintf( 'Axis Mapping: X-%s Y-%s Z-%s\n', Output_GetAxisMapping.XAxis.ToString(), ...
    Output_GetAxisMapping.YAxis.ToString(), ...
    Output_GetAxisMapping.ZAxis.ToString() );
 
 
% Discover the version number
Output_GetVersion = MyClient.GetVersion();
fprintf( 'Version: %d.%d.%d\n', Output_GetVersion.Major, ...
    Output_GetVersion.Minor, ...
    Output_GetVersion.Point );
 
if TransmitMulticast
    MyClient.StartTransmittingMulticast( 'localhost', '224.0.0.0' );
end
 
 
% Global Variables for distance
distance = 0;
 
[origin_x,origin_y,origin_z] = deal(0);
[target_x,target_y,target_z] = deal(0);
 
% Global Variables for rotation
[origin_w,origin_X,origin_Y,origin_Z] = deal(0);
[target_w,target_X,target_Y,target_Z] = deal(0);
 
[rotation_X,rotation_Y,rotation_Z] = deal(0);
 
% initial start point
Counter = 1;
startTime = datetime('now');
 
% access to the axisX
hvax = handles.viconPlotX;
axes(hvax);
realtime_angle_X = animatedline;
hvax.YGrid = 'on';
hvax.YLim = [-180 180];
 
% 
% access to the axisY
hvay = handles.viconPlotY;
axes(hvay);
realtime_angle_Y = animatedline;
hvay.YGrid = 'on';
hvay.YLim = [-180 180];
 
% 
% access to the axisZ
hvaz = handles.viconPlotZ;
axes(hvaz);
realtime_angle_Z = animatedline;
hvaz.YGrid = 'on';
hvaz.YLim = [-180 180];
 
% Arduino Part
a = arduino;
 
% register a cleanup function
finishup = onCleanup(@() exitprogram(a));
 
v_1 = 0;
v_2 = 0;
v_hybrid_1 = 0;
 
pre_angle_bending = 0;
 
buf_len = 100;
index = 1:buf_len;
 
sg_buf_len = 31;
 
val = 0;
 
buff_data_1 = zeros(buf_len, 1);
buff_data_filtered_1 = zeros(buf_len, 1);
buff_data_2 = zeros(buf_len, 1);
buff_data_filtered_2 = zeros(buf_len, 1);
 
sg_buff_data = zeros(sg_buf_len, 1);
sg_buff_data_filtered = zeros(sg_buf_len, 1);
 
taps = 15;
 
% access to the axis
hax = handles.anglePlot;
axes(hax);
h_voltage_1 = animatedline('Color','r');
hax.YGrid = 'on';
hax.YLim = [-180 360];
 
hbx = handles.rotationPlot;
axes(hbx);
h_voltage_2 = animatedline('Color','b');
hbx.YGrid = 'on';
hbx.YLim = [-180 360];

 
% Loop until the message box is dismissed
while ishandle( MessageBox )
% while ~getappdata(hf, 'vicon_plot')
    Counter = Counter + 1;
     
    % Get a frame
    fprintf( '\n' );
    fprintf( '\n' );
    fprintf( 'Waiting for new frame...' );
    while MyClient.GetFrame().Result.Value ~= Result.Success
        fprintf( '.' );
    end% while
    fprintf( '\n' );
     
    % Get the frame number
    Output_GetFrameNumber = MyClient.GetFrameNumber();
    fprintf( 'Frame Number: %d\n', Output_GetFrameNumber.FrameNumber );
     
    % Get the frame rate
    Output_GetFrameRate = MyClient.GetFrameRate();
    fprintf( 'Frame rate: %g\n', Output_GetFrameRate.FrameRateHz );
     
    for FrameRateIndex = 1:MyClient.GetFrameRateCount().Count
        FrameRateName  = MyClient.GetFrameRateName( FrameRateIndex ).Name;
        FrameRateValue = MyClient.GetFrameRateValue( FrameRateName ).Value;
         
        fprintf( '%s: %gHz\n', FrameRateName, FrameRateValue );
    end% for
     
    fprintf( '\n' );
    % Get the timecode
    Output_GetTimecode = MyClient.GetTimecode();
    fprintf( 'Timecode: %dh %dm %ds %df %dsf %s %d %d %d\n\n',    ...
        Output_GetTimecode.Hours,                  ...
        Output_GetTimecode.Minutes,                ...
        Output_GetTimecode.Seconds,                ...
        Output_GetTimecode.Frames,                 ...
        Output_GetTimecode.SubFrame,               ...
        AdaptBool( Output_GetTimecode.FieldFlag ), ...
        Output_GetTimecode.Standard.Value,         ...
        Output_GetTimecode.SubFramesPerFrame,      ...
        Output_GetTimecode.UserBits );
     
    % Get the latency
    fprintf( 'Latency: %gs\n', MyClient.GetLatencyTotal().Total );
     
    for LatencySampleIndex = 1:MyClient.GetLatencySampleCount().Count
        SampleName  = MyClient.GetLatencySampleName( LatencySampleIndex ).Name;
        SampleValue = MyClient.GetLatencySampleValue( SampleName ).Value;
         
        fprintf( '  %s %gs\n', SampleName, SampleValue );
    end% for
    fprintf( '\n' );
     
    % Count the number of subjects
    SubjectCount = MyClient.GetSubjectCount().SubjectCount;
    fprintf( 'Subjects (%d):\n', SubjectCount );
    for SubjectIndex = 1:SubjectCount
        fprintf( '  Subject #%d\n', SubjectIndex - 1 );
         
        % Get the subject name
        SubjectName = MyClient.GetSubjectName( SubjectIndex ).SubjectName;
        fprintf( '    Name: %s\n', SubjectName );
         
        % Get the root segment
        RootSegment = MyClient.GetSubjectRootSegmentName( SubjectName ).SegmentName;
        fprintf( '    Root Segment: %s\n', RootSegment );
         
        % Count the number of segments
        SegmentCount = MyClient.GetSegmentCount( SubjectName ).SegmentCount;
        fprintf( '    Segments (%d):\n', SegmentCount );
        for SegmentIndex = 1:SegmentCount
            fprintf( '      Segment #%d\n', SegmentIndex - 1 );
             
            % Get the segment name
            SegmentName = MyClient.GetSegmentName( SubjectName, SegmentIndex ).SegmentName;
            fprintf( '        Name: %s\n', SegmentName );
             
            % Get the segment parent
            SegmentParentName = MyClient.GetSegmentParentName( SubjectName, SegmentName ).SegmentName;
            fprintf( '        Parent: %s\n',  SegmentParentName );
             
            % Get the segment's children
            ChildCount = MyClient.GetSegmentChildCount( SubjectName, SegmentName ).SegmentCount;
            fprintf( '     Children (%d):\n', ChildCount );
            for ChildIndex = 1:ChildCount
                ChildName = MyClient.GetSegmentChildName( SubjectName, SegmentName, ChildIndex ).SegmentName;
                fprintf( '       %s\n', ChildName );
            end% for
             
            % Get the static segment translation
            Output_GetSegmentStaticTranslation = MyClient.GetSegmentStaticTranslation( SubjectName, SegmentName );
            origin_x = Output_GetSegmentStaticTranslation.Translation( 1 );
            origin_y = Output_GetSegmentStaticTranslation.Translation( 2 );
            origin_z =  Output_GetSegmentStaticTranslation.Translation( 3 );
             
            % Get the static segment rotation in EulerXYZ co-ordinates
            Output_GetSegmentStaticRotationEulerXYZ = MyClient.GetSegmentStaticRotationEulerXYZ( SubjectName, SegmentName );
            origin_X = Output_GetSegmentStaticRotationEulerXYZ.Rotation( 1 );
            origin_Y = Output_GetSegmentStaticRotationEulerXYZ.Rotation( 2 );
            origin_Z = Output_GetSegmentStaticRotationEulerXYZ.Rotation( 3 );
             
            fprintf( '        Static Rotation EulerXYZ: (%g, %g, %g)\n',               ...
                             Output_GetSegmentStaticRotationEulerXYZ.Rotation( 1 ),  ...
                             Output_GetSegmentStaticRotationEulerXYZ.Rotation( 2 ),  ...
                             Output_GetSegmentStaticRotationEulerXYZ.Rotation( 3 ) );
 
            % Get the local segment translation
            Output_GetSegmentLocalTranslation = MyClient.GetSegmentLocalTranslation( SubjectName, SegmentName );   
            target_x = Output_GetSegmentLocalTranslation.Translation( 1 );
            target_y = Output_GetSegmentLocalTranslation.Translation( 2 );
            target_z = Output_GetSegmentLocalTranslation.Translation( 3 );
             
            % Get the local segment rotation in EulerXYZ co-ordinates
            Output_GetSegmentLocalRotationEulerXYZ = MyClient.GetSegmentLocalRotationEulerXYZ( SubjectName, SegmentName );
            target_X = Output_GetSegmentLocalRotationEulerXYZ.Rotation( 1 );
            target_Y = Output_GetSegmentLocalRotationEulerXYZ.Rotation( 2 );
            target_Z = Output_GetSegmentLocalRotationEulerXYZ.Rotation( 3 );
             
            % Get the local segment rotation in EulerXYZ co-ordinates
            Output_GetSegmentLocalRotationEulerXYZ = MyClient.GetSegmentLocalRotationEulerXYZ( SubjectName, SegmentName );
            fprintf( '        Local Rotation EulerXYZ: (%g, %g, %g) %s\n',                 ...
                         Output_GetSegmentLocalRotationEulerXYZ.Rotation( 1 ),       ...
                         Output_GetSegmentLocalRotationEulerXYZ.Rotation( 2 ),       ...
                         Output_GetSegmentLocalRotationEulerXYZ.Rotation( 3 ),       ...
                         AdaptBool( Output_GetSegmentLocalRotationEulerXYZ.Occluded ) );
     
            ratio_main = getappdata(0,'main_ratio');
            ratio_side = getappdata(0,'side_ratio');
                  
            v_1 = readVoltage(a, 'A0');
            buff_data_1 = [buff_data_1(2:end) ; v_1];
            buff_data_filtered_1 = mean(buff_data_1(buf_len : -1 : buf_len-taps+1));
%             buff_data_filtered_1 = v_1;

            v_2 = readVoltage(a, 'A1');
            buff_data_2 = [buff_data_2(2:end) ; v_2];
            buff_data_filtered_2 = mean(buff_data_2(buf_len : -1 : buf_len-taps+1));

            rotation_X = (target_X - origin_X) / pi * 180;
            rotation_Y = (target_Y - origin_Y) / pi * 180;
            rotation_Z = (target_Z - origin_Z) / pi * 180;
             
            fprintf('Real time rotation XYZ is (%g, %g, %g)\n\n', rotation_X, rotation_Y, rotation_Z);
 
            distance = sqrt((target_x - origin_x)^2 ...
                + (target_y - origin_y)^2 ...
                + (target_z - origin_z)^2);
             
            fprintf('Real time distance is %g mm\n', distance);
             
            % Get current time
            t =  datetime('now') - startTime;
             
            % Add points to animation
            addpoints(realtime_angle_X, datenum(t), rotation_X);
            addpoints(realtime_angle_Y, datenum(t), rotation_Y);
            addpoints(realtime_angle_Z, datenum(t), rotation_Z); 
             
            pre_angle_bending = (buff_data_filtered_1 - bending_start_point) * 100;
            pre_angle_rotation = (buff_data_filtered_2 - rotation_start_point) * 200;
           
            % Add points to animation
            addpoints(h_voltage_1, datenum(t), pre_angle_bending);
            addpoints(h_voltage_2, datenum(t), pre_angle_rotation);
 
            % Update axes
            hvax.XLim = datenum([t-seconds(15) t]);
            hvay.XLim = datenum([t-seconds(15) t]);
            hvaz.XLim = datenum([t-seconds(15) t]);
            
            % Update axes
            hax.XLim = datenum([t-seconds(15) t]);
            hbx.XLim = datenum([t-seconds(15) t]);
           
            datetick('x','keeplimits')
            drawnow limitrate
             
        end% SegmentIndex
    end% SubjectIndex
end% while true
 
if TransmitMulticast
    MyClient.StopTransmittingMulticast();
end
 
% Disconnect and dispose
MyClient.Disconnect();
 
% Draw the plot
[timeLogs, angle_X] = getpoints(realtime_angle_X);
[timeLogs, angle_Y] = getpoints(realtime_angle_Y);
[timeLogs, angle_Z] = getpoints(realtime_angle_Z);
 
[timeLogs, h_voltage_1] = getpoints(h_voltage_1);
[timeLogs, h_voltage_2] = getpoints(h_voltage_2);
timeSecs = (timeLogs-timeLogs(1))*24*3600;
 
% Write to file angle_X
T = table(timeSecs', angle_X','VariableNames',{'Time','angle_X'});
filename_1 = './position/angle_X.xlsx';
% Write table to file 
writetable(T,filename_1)
% Print confirmation to command line
fprintf('Results table with %g voltage measurements saved to file %s\n',...
    length(timeSecs), filename_1)
 
% Write to file angle_Y
T = table(timeSecs', angle_Y','VariableNames',{'Time','angle_Y'});
filename_2 = './position/angle_Y.xlsx';
% Write table to file 
writetable(T,filename_2)
% Print confirmation to command line
fprintf('Results table with %g voltage measurements saved to file %s\n',...
    length(timeSecs), filename_2)
 
% Write to file angle_Z
T = table(timeSecs', angle_Z','VariableNames',{'Time','angle_Z'});
filename_3 = './position/angle_Z.xlsx';
% Write table to file 
writetable(T,filename_3)
% Print confirmation to command line
fprintf('Results table with %g voltage measurements saved to file %s\n',...
    length(timeSecs), filename_3)
 
% Write to file voltage 1
T = table(timeSecs', h_voltage_1','VariableNames',{'Time','h_voltage_1'});
filename_4 = './position/voltage_1.xlsx';
% Write table to file 
writetable(T,filename_4)
% Print confirmation to command line
fprintf('Results table with %g voltage measurements saved to file %s\n',...
    length(timeSecs), filename_4)
 
% Write to file voltage 2
T = table(timeSecs', h_voltage_2','VariableNames',{'Time','h_voltage_2'});
filename_5 = './position/voltage_2.xlsx';
% Write table to file 
writetable(T,filename_5)
% Print confirmation to command line
fprintf('Results table with %g voltage measurements saved to file %s\n',...
    length(timeSecs), filename_5)
 
 
% Write to file pred_angle
% T = table(timeSecs', h_angle_pred','VariableNames',{'Time','h_angle_pred'});
% filename_6 = './wrist_new/pred_angle.xlsx';
% % Write table to file 
% writetable(T,filename_6)
% % Print confirmation to command line
% fprintf('Results table with %g voltage measurements saved to file %s\n',...
%     length(timeSecs), filename_6)
%  
% Unload the SDK
fprintf( 'Unloading SDK...' );
Client.UnloadViconDataStreamSDK();
fprintf( 'done\n' );
end