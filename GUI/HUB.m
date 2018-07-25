function varargout = HUB(varargin)
<<<<<<< HEAD
% GUI program for communication with Flora
=======
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

% Last Modified by GUIDE v2.5 25-Jul-2018 17:54:51
>>>>>>> master

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

% Turn off all warnings
warning off all;

% Initialize all params
hasData = false; 	%表征串口是否接收到数据
isShow = false;  	%表征是否正在进行数据显示，即是否正在执行函数dataDisp
isStopDisp = false;  	%表征是否按下了【停止显示】按钮
numRecv = 0;    	%接收字符计数
strRecv = '';   		%已接收的字符串

% Bind params to the hObject handler
setappdata(hObject, 'hasData', hasData);
setappdata(hObject, 'strRec', strRecv);
setappdata(hObject, 'numRec', numRecv);
setappdata(hObject, 'isShow', isShow);
setappdata(hObject, 'isStopDisp', isStopDisp);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HUB wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = HUB_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function btn_start_vicon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btn_start_vicon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end

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
handles.s1.YLim = [0 256];
% access to the s2
axes(handles.s2);
h_voltage_2 = animatedline('Color','g');
handles.s2.YGrid = 'on';
handles.s2.YLim = [0 256];
% access to the s3
axes(handles.s3);
h_voltage_3 = animatedline('Color','b');
handles.s3.YGrid = 'on';
handles.s3.YLim = [0 256];
% access to the s4
axes(handles.s4);
h_voltage_4 = animatedline('Color','k');
handles.s4.YGrid = 'on';
handles.s4.YLim = [0 256];

startTime = datetime('now','Format','HH:mm:ss.SSSSSS');

global t;
<<<<<<< HEAD
global buff;
buff = struct();
buff.buf_len = 25;
buff.buf_data_1 = zeros(buff.buf_len, 1);
buff.buf_data_filtered_1 = zeros(buff.buf_len, 1);
t = timer('StartDelay', 0, 'Period', 0.01, 'ExecutionMode', 'fixedRate','UserData', ...
    struct('len',25,'buf_1',zeros(25,1),'buf_filtered_1',zeros(25,1)));
=======
global buffer;
buffer.buf_len = 25;
buffer.buf_data = zeros(buffer.buf_len, 4);
buffer.buf_data_filtered = zeros(buffer.buf_len, 4);
t = timer('StartDelay', 0, 'Period', 0.025, 'ExecutionMode', 'fixedRate');
>>>>>>> master
t.StartFcn = @(x,y)disp('Hello World!');
t.StopFcn = @(x,y)disp('Hello World!');
t.TimerFcn = @ReceiveCallback;
start(t)
guidata(hObject, handles);

    function ReceiveCallback(~,~)         
       flushinput(s)  
          
       buf_len = 11;
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

           buff.buf_data_1 = [buff.buf_data_1(2:end); value_1];
           if buff.buf_data_1(1) ~= 0
               buff.buf_data_filtered_1 = sgolayfilt(double(buff.buf_data_1),2,7);
           end       

           % Add points to animation
           addpoints(h1, diff*3600*24, buf_data_filtered_1(buf_len));
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

       user_data = obj.UserData; 
    end
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
end

% --- Executes during object creation, after setting all properties.
function weightSide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weightSide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

function btn_end_point_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in btn_end_point.
function btn_end_point_Callback(hObject, eventdata, handles)
% hObject    handle to btn_end_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[bending_end_point, rotation_end_point] = calibration;
setappdata(0,'bending_end_point',bending_en*-d_point);
setappdata(0,'rotation_end_point',rotation_end_point);
end

% --- Executes on button press in btn_start_point.
function btn_start_point_Callback(hObject, eventdata, handles)
% hObject    handle to btn_start_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[bending_start_point, rotation_start_point] = calibration;
setappdata(0,'bending_start_point',bending_start_point);
setappdata(0,'rotation_start_point',rotation_start_point);
end


  
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
end


% --- Executes during object creation, after setting all properties.
function btn_end_vicon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btn_end_vicon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
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
end


function port_Callback(hObject, eventdata, handles)
% hObject    handle to port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of port as text
%        str2double(get(hObject,'String')) returns contents of port as a double
handles.a = get(hObject,'string');
guidata(hObject, handles);
end

% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
% hObject    handle to update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(instrfindall);
handles.s = serial(handles.a); 
set(handles.s,'BaudRate',9600);
warning off;

global buffer
buffer = struct();
guidata(hObject, handles);
end

<<<<<<< HEAD
end
=======

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
>>>>>>> master
