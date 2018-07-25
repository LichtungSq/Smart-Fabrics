function varargout = HUB_1(varargin)
% HUB MATLAB code for HUB.fig
%      HUB, by itself, creates a new HUB or raises the existing
%      singleton*.
%
%      H = HUB returns the handle to a new HUB or the handle to
%      the existing singleton*. siqisiqi
%
%      HUB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HUB.M with the given input arguments.
%
%      HUB('Property','Value',...) creates a new HUB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HUB_OpeningFcn gets called.  An
%      unrecognized property name or invalidViconData(handles); value makes property application
%      stop.  All inputs are passed to HUB_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HUB

% Last Modified by GUIDE v2.5 23-Jul-2018 15:31:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HUB_OpeningFcn, ...
                   'gui_OutputFcn',  @HUB_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HUB is made visible.
function HUB_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HUB (see VARARGIN)

% Choose default command line output for HUB
handles.output = hObject;

setappdata(handles.btn_start_vicon,'vicon_plot',1);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HUB wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HUB_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in btn_start_vicon.
function btn_start_vicon_Callback(hObject, eventdata, handles)
% hObject    handle to btn_start_vicon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% toggle(handles.btn_start_vicon,'vicon_plot');
fopen(handles.s);
handles.fid = fopen('Data_k.txt','a+');

bending_start_point = getappdata(0,'bending_start_point');
bending_end_point = getappdata(0,'bending_end_point');
rotation_start_point = getappdata(0,'rotation_start_point');
rotation_end_point = getappdata(0,'rotation_end_point');
% hybridDataPlot(bending_start_point, bending_end_point, rotation_start_point, rotation_end_point, handles);

% access to the s1
axes(handles.s1);
h_voltage_1 = animatedline('Color','r');
handles.s1.YGrid = 'on';
handles.s1.YLim = [0 255];
% access to the s2
axes(handles.s2);
h_voltage_2 = animatedline('Color','g');
handles.s2.YGrid = 'on';
handles.s2.YLim = [0 255];
% access to the s3
axes(handles.s3);
h_voltage_3 = animatedline('Color','b');
handles.s3.YGrid = 'on';
handles.s3.YLim = [0 255];
% access to the s4
axes(handles.s4);
h_voltage_4 = animatedline('Color','k');
handles.s4.YGrid = 'on';
handles.s4.YLim = [0 255];

startTime = datetime('now','Format','HH:mm:ss.SSSSSS');

global t;
global buffer;
buffer.buf_len = 15;
buffer.buf_data_1 = zeros(buffer.buf_len, 1);
buffer.buf_data_filtered_1 = zeros(buffer.buf_len, 1);
t = timer('StartDelay', 0, 'Period', 0.02, 'ExecutionMode', 'fixedRate');
t.StartFcn = @(x,y)disp('Hello World!');
t.StopFcn = @(x,y)disp('Hello World!');
t.TimerFcn = {@ReceiveCallback, handles.s, h_voltage_1, h_voltage_2, h_voltage_3, h_voltage_4, ...
    handles.s1, handles.s2, handles.s3, handles.s4, startTime, handles.fid};
start(t)

    function ReceiveCallback(obj, event, s, h1, h2, h3, h4, ax1, ax2, ax3, ax4, startTime, fid)         
       flushinput(s)  
       global buffer
    %    /dev/cu.usbmodem1411
    %    readasync(s)      
    %    buf_len = 11;
    %    taps = 5;
    %    buf_len = get(gcbl, 'Userdata');
    %    buf_data_1 = get(gcbd, 'Userdata');
    %    buf_data_filtered_1 = get(gcbf, 'Userdata');
       value_1 = fscanf(s, "%d s1\n");
       value_2 = fscanf(s, "%d s2\n");
       value_3 = fscanf(s, "%d s3\n");
       value_4 = fscanf(s, "%d s4\n");

       if ~ischar(value_2) && ~ischar(value_1) && ~ischar(value_3) && ~ischar(value_4)...
              && ~isempty(value_2) && ~isempty(value_1) && ~isempty(value_3) && ~isempty(value_4) 
    %        t =  datetime('now','Format','HH:mm:ss.SSSSSS') - startTime;
           currentTime =  datetime('now','Format','HH:mm:ss.SSSSSS');
           diff = datenum(currentTime) - datenum(startTime);
           t = datetime(datevec(diff),'Format','HH:mm:ss.SSSSSS');
           fprintf(fid,'%s, %d\n\t', t, value_1);
           fprintf(fid,'%s, %d\n\t', t, value_2);
           fprintf(fid,'%s, %d\n\t', t, value_3);
           fprintf(fid,'%s, %d\n\t', t, value_4);       

           buffer.buf_data_1 = [buffer.buf_data_1(2:end); value_1];
           if buffer.buf_data_1(1) ~= 0
               buffer.buf_data_filtered_1 = sgolayfilt(double(buffer.buf_data_1),1,11);
           end       

           % Add points to animation
           addpoints(h1, diff*3600*24, buffer.buf_data_filtered_1(buffer.buf_len));
           addpoints(h2, diff*3600*24, double(value_2));
           addpoints(h3, diff*3600*24, double(value_3));
           addpoints(h4, diff*3600*24, double(value_4));

           ax1.XLim = datenum([diff-seconds(15) diff])*3600*24;
           ax2.XLim = datenum([diff-seconds(15) diff])*3600*24;
           ax3.XLim = datenum([diff-seconds(15) diff])*3600*24;
           ax4.XLim = datenum([diff-seconds(15) diff])*3600*24;

           datetick('x','keeplimits')
           drawnow limitrate
       end
    %    data = struct('len',25,'buf_1',buf_data_1,'buf_filtered_1', buf_data_filtered_1);
    %    obj.Userdata = data;
    %    set(gcbl, 'Userdata', buf_len);
    %    set(gcbd, 'Userdata', buf_data_1);
    %    set(gcbf, 'Userdata', buf_data_filtered_1);   
    end

guidata(hObject, handles);
end

% --- Executes on slider movement.
function weightSide_Callback(hObject, eventdata, handles)
% hObject    handle to weightSide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
setappdata(0,'side_ratio',val);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function weightSide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weightSide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btn_end_point.
function btn_end_point_Callback(hObject, eventdata, handles)
% hObject    handle to btn_end_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[bending_end_point, rotation_end_point] = calibration;
setappdata(0,'bending_end_point',bending_en*-d_point);
setappdata(0,'rotation_end_point',rotation_end_point);

% --- Executes on button press in btn_start_point.
function btn_start_point_Callback(hObject, eventdata, handles)
% hObject    handle to btn_start_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[bending_start_point, rotation_start_point] = calibration;
setappdata(0,'bending_start_point',bending_start_point);
setappdata(0,'rotation_start_point',rotation_start_point);



  
% hObject    handle to port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of port as text
%        str2double(get(hObject,'String')) returns contents of port as a double


% --- Executes during object creation, after setting all properties.
function port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%a = get(handles.port,'string');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_end_vicon.
function btn_end_vicon_Callback(hObject, eventdata, handles)
% hObject    handle to btn_end_vicon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t;
stop(t);
% fclose(handles.fid);
fclose(handles.s);



function port_Callback(hObject, eventdata, handles)
% hObject    handle to port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of port as text
%        str2double(get(hObject,'String')) returns contents of port as a double
handles.a = get(hObject,'string');
guidata(hObject, handles);


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(instrfindall);
handles.s = serial(handles.a);        
set(handles.s,'BaudRate',115200);
warning off;

global buffer
buffer = struct();
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function btn_start_vicon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btn_start_vicon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function btn_end_vicon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btn_end_vicon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



