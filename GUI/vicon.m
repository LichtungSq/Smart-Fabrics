function varargout = vicon(varargin)
% VICON MATLAB code for vicon.fig
%      VICON, by itself, creates a new VICON or raises the existing
%      singleton*.
%
%      H = VICON returns the handle to a new VICON or the handle to
%      the existing singleton*.
%
%      VICON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VICON.M with the given input arguments.
%
%      VICON('Property','Value',...) creates a new VICON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vicon_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vicon_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vicon_OpeningFcn, ...
                   'gui_OutputFcn',  @vicon_OutputFcn, ...
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


% --- Executes just before vicon is made visible.
function vicon_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vicon (see VARARGIN)

% Choose default command line output for vicon
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vicon wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vicon_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in vicon_go.
function vicon_go_Callback(hObject, eventdata, handles)
% hObject    handle to vicon_go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% access to the animated line in s1 (strain sensor 1)

ViconData(handles);


% --- Executes on button press in vicon_stop.
function vicon_stop_Callback(hObject, eventdata, handles)
% hObject    handle to vicon_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
