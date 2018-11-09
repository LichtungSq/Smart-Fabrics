function varargout = HUB(varargin)
% Edit the above text to modify the response to help HUB
% Last Modified by GUIDE v2.5 07-Nov-2018 18:05:38
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

setappdata(handles.btn_start_vicon,'vicon_plot',1); % store the plot status to handles

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

% --- start vicon plot button onClickListener
function btn_start_vicon_Callback(hObject, eventdata, handles)
% hObject    handle to btn_start_vicon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% toggle(handles.btn_start_vicon,'vicon_plot');

fopen(handles.s); % open the serial port

% open four files handles
handles.fid_v1 = fopen([handles.updated_name '_1.txt'],'a+');
handles.fid_v2 = fopen([handles.updated_name '_2.txt'],'a+');
handles.fid_p = fopen([handles.updated_name '_3.txt'],'a+');
handles.fid_h = fopen([handles.updated_name '_4.txt'],'a+');

% read out the calibration results
v1_start_point = getappdata(0,'v1_start_point');
v1_end_point = getappdata(0,'v1_end_point');
v2_start_point = getappdata(0,'v2_start_point');
v2_end_point = getappdata(0,'v2_end_point');
p_start_point = getappdata(0,'p_start_point');
p_end_point = getappdata(0,'p_end_point');
h_start_point = getappdata(0,'h_start_point');
h_end_point = getappdata(0,'h_end_point');

% clear the plots
cla(handles.s1);
cla(handles.s2);
cla(handles.s3);
cla(handles.s4);

% access to the animated line in s1 (strain sensor 1)
axes(handles.s1);
h_voltage_1 = animatedline('Color','r');
handles.s1.YGrid = 'on';
handles.s1.YLim = [0 1024];

% access to the animated line in s1 (strain sensor 2)
axes(handles.s2);
h_voltage_2 = animatedline('Color','g');
handles.s2.YGrid = 'on';
handles.s2.YLim = [0 1024];

% access to the animated line in s3 (pressure sensor)
axes(handles.s3);
h_voltage_3 = animatedline('Color','b');
handles.s3.YGrid = 'on';
handles.s3.YLim = [0 1024];

% access to the s4 (currently not available)
axes(handles.s4);
h_voltage_4 = animatedline('Color','k');
handles.s4.YGrid = 'on';
handles.s4.YLim = [0 1024];

startTime = datetime('now','Format','HH:mm:ss.SSSSSS');

global t;
global buffer;

buffer.buf_len = 20;
buffer.buf_data = zeros(buffer.buf_len, 4);
buffer.buf_data_filtered = zeros(buffer.buf_len, 4);

t = timer('StartDelay', 0, 'Period', 0.025, 'ExecutionMode', 'fixedRate');
% t.StartFcn = {@ViconData, handles};
t.StartFcn = @(x,y)disp('Hello World!');
t.StopFcn = @(x,y)disp('Hello World!');
t.TimerFcn = {@ReceiveCallback, handles.s, h_voltage_1, h_voltage_2, h_voltage_3, h_voltage_4, ...
    handles.s1, handles.s2, handles.s3, handles.s4, v1_start_point, v2_start_point, p_start_point,...
    h_start_point, startTime, handles.fid_v1, handles.fid_v2, handles.fid_p, handles.fid_h};

start(t)

guidata(hObject, handles);

% --- end vicon plot button onClickListener
function btn_end_vicon_Callback(hObject, eventdata, handles)

global t;
stop(t);
global buffer
buffer = struct();

fclose(handles.fid_v1);
fclose(handles.fid_v2);
fclose(handles.fid_p);
fclose(handles.fid_h);
fclose(handles.s);

guidata(hObject, handles);

% --- start calibration button onClickListener
function btn_start_point_Callback(hObject, eventdata, handles)
% hObject    handle to btn_start_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fopen(handles.s);

[v1_start_point, v2_start_point, p_start_point, h_start_point] = calibration(handles.s);

% store all the calibrated data (start points) to app handles
setappdata(0,'v1_start_point',v1_start_point);
setappdata(0,'v2_start_point',v2_start_point);
setappdata(0,'p_start_point',p_start_point);
setappdata(0,'h_start_point',h_start_point);
set(handles.V1_start, 'String', num2str(v1_start_point));
set(handles.V2_start, 'String', num2str(v2_start_point));
set(handles.p_start, 'String', num2str(p_start_point));
set(handles.h_start, 'String', num2str(h_start_point));

guidata(hObject, handles);

% --- end calibration button onClickListener
function btn_end_point_Callback(hObject, eventdata, handles)

fopen(handles.s);

[v1_end_point, v2_end_point, p_end_point, h_end_point] = calibration(handles.s);

% store all the calibrated data (end points) to app handles
setappdata(0,'v1_end_point',v1_end_point);
setappdata(0,'v2_end_point',v2_end_point);
setappdata(0,'p_end_point',p_end_point);
setappdata(0,'h_end_point',h_end_point);
set(handles.V1_end, 'String', num2str(v1_end_point));
set(handles.V2_end, 'String', num2str(v2_end_point));
set(handles.p_end, 'String', num2str(p_end_point));
set(handles.h_end, 'String', num2str(h_end_point));

guidata(hObject, handles);

% --- port selection onCreat
function port_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- get port selection input 
function port_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of port as text
%        str2double(get(hObject,'String')) returns contents of port as a double
handles.a = get(hObject,'String');
guidata(hObject, handles);

% --- port selection onUpdate listener
function update_Callback(hObject, eventdata, handles)
delete(instrfindall);
handles.s = serial(handles.a); 
set(handles.s,'BaudRate',115200);
warning off;

global buffer
buffer = struct();
guidata(hObject, handles);

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)

set(handles.V1_start, 'String', '');
set(handles.V2_start, 'String', '');
set(handles.p_start, 'String', '');
set(handles.h_start, 'String', '');
set(handles.V1_end, 'String', '');
set(handles.V2_end, 'String', '');
set(handles.p_end, 'String', '');
set(handles.h_end, 'String', '');

guidata(hObject, handles);

function name_Callback(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name as text
%        str2double(get(hObject,'String')) returns contents of name as a double
handles.name = get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in update_name.
function update_name_Callback(hObject, eventdata, handles)
% hObject    handle to update_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.updated_name = handles.name;
guidata(hObject, handles);


% --- Executes on button press in separator.
function separator_Callback(hObject, eventdata, handles)
% hObject    handle to separator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fid_v1 = fopen([handles.updated_name '_1.txt'],'a+');
fprintf(fid_v1,'##################\n');
fclose(fid_v1);

fid_v2 = fopen([handles.updated_name '_2.txt'],'a+');
fprintf(fid_v2,'##################\n');
fclose(fid_v2);

fid_p = fopen([handles.updated_name '_3.txt'],'a+');
fprintf(fid_p,'##################\n');
fclose(fid_p);

fid_h = fopen([handles.updated_name '_4.txt'],'a+');
fprintf(fid_h,'##################\n');
fclose(fid_h);
guidata(hObject, handles);


% --- Executes on button press in btn_start_vic.
function btn_start_vic_Callback(hObject, eventdata, handles)
% hObject    handle to btn_start_vic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ViconData(handles);
