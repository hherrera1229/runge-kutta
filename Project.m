function varargout = Project(varargin)
% PROJECT MATLAB code for Project.fig
%      PROJECT, by itself, creates a new PROJECT or raises the existing
%      singleton*.
%
%      H = PROJECT returns the handle to a new PROJECT or the handle to
%      the existing singleton*.
%
%      PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT.M with the given input arguments.
%
%      PROJECT('Property','Value',...) creates a new PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Project

% Last Modified by GUIDE v2.5 02-Dec-2011 05:31:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Project_OpeningFcn, ...
                   'gui_OutputFcn',  @Project_OutputFcn, ...
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

% --- Executes just before Project is made visible.
function Project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Project (see VARARGIN)

% Choose default command line output for Project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using Project.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes Project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Project_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in update_button.
function update_button_Callback(hObject, eventdata, handles)
% hObject    handle to update_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Pull User Data
cla;
sigma=str2num(get(handles.sigma_edit,'String'));
r=str2num(get(handles.r_edit,'String'));
b=str2num(get(handles.b_edit,'String'));
ya=str2num(get(handles.x_edit,'String'));
yb=str2num(get(handles.y_edit,'String'));
yc=str2num(get(handles.z_edit,'String'));
xmax=str2num(get(handles.time,'String'));
%Start Runge Kutta Method
h=0.01;
fa=@(x,ya,yb,yc) sigma*(yb-ya)+0*yc;
fb=@(x,ya,yb,yc) r*ya-yb-ya*yc;
fc=@(x,ya,yb,yc) ya*yb-b*yc;
x(1)=0;
j=1;
for i=0:h:(xmax-h);
j=j+1;
k1=fa(x(j-1),ya(j-1),yb(j-1),yc(j-1));
k2=fa(x(j-1)+h/2,ya(j-1)+(k1*h)/2,yb(j-1)+(k1*h)/2,yc(j-1)+(k1*h)/2);
k3=fa(x(j-1)+(h/2),ya(j-1)+(k2*h)/2,yb(j-1)+(k2*h)/2,yc(j-1)+(k2*h)/2);
k4=fa(x(j-1)+h,ya(j-1)+k3*h,yb(j-1)+k3*h,yc(j-1)+k3*h);
l1=fb(x(j-1),ya(j-1),yb(j-1),yc(j-1));
l2=fb(x(j-1)+h/2,ya(j-1)+(k1*h)/2,yb(j-1)+(l1*h)/2,yc(j-1)+(l1*h)/2);
l3=fb(x(j-1)+h/2,ya(j-1)+(k2*h)/2,yb(j-1)+(l2*h)/2,yc(j-1)+(l2*h)/2);
l4=fb(x(j-1)+h,ya(j-1)+(k3*h),yb(j-1)+l3*h,yc(j-1)+l3*h);
m1=fc(x(j-1),ya(j-1),yb(j-1),yc(j-1));
m2=fc(x(j-1)+h/2,ya(j-1)+k1*h/2,yb(j-1)+(l1*h)/2,yc(j-1)+m1*h/2);
m3=fc(x(j-1)+h/2,ya(j-1)+(k2*h)/2,yb(j-1)+(l2*h)/2,yc(j-1)+m2*h/2);
m4=fc(x(j-1)+h,ya(j-1)+(k3*h),yb(j-1)+l3*h,yc(j-1)+m3*h);
ya(j)=ya(j-1)+(1/6)*(k1+2*k2+2*k3+k4)*h;
yb(j)=yb(j-1)+(1/6)*(l1+2*l2+2*l3+l4)*h;
yc(j)=yc(j-1)+(1/6)*(m1+2*m2+2*m3+m4)*h;
x(j)=i+h;
end
%Generate and Display Plots
M=[x' ya' yb' yc'];
axes(handles.axes_tvsx)
plot(M(:,1),M(:,2));
title('t vs x');
axes(handles.axes_tvsy)
plot(M(:,1),M(:,3));
title('t vs y');
axes(handles.axes_tvsz)
plot(M(:,1),M(:,4));
title('t vs z');
axes(handles.axes_xvsy)
plot(M(:,2),M(:,3));
title('x vs y');
axes(handles.axes_xvsz)
plot(M(:,2),M(:,4));
title('x vs z');
axes(handles.axes_yvsz)
plot(M(:,3),M(:,4));
title('y vs z');
guidata(hObject, handles)

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});



function sigma_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sigma_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigma_edit as text
%        str2double(get(hObject,'String')) returns contents of sigma_edit as a double


% --- Executes during object creation, after setting all properties.
function sigma_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigma_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function r_edit_Callback(hObject, eventdata, handles)
% hObject    handle to r_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r_edit as text
%        str2double(get(hObject,'String')) returns contents of r_edit as a double


% --- Executes during object creation, after setting all properties.
function r_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b_edit_Callback(hObject, eventdata, handles)
% hObject    handle to b_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b_edit as text
%        str2double(get(hObject,'String')) returns contents of b_edit as a double


% --- Executes during object creation, after setting all properties.
function b_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_edit_Callback(hObject, eventdata, handles)
% hObject    handle to x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_edit as text
%        str2double(get(hObject,'String')) returns contents of x_edit as a double


% --- Executes during object creation, after setting all properties.
function x_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_edit_Callback(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_edit as text
%        str2double(get(hObject,'String')) returns contents of y_edit as a double


% --- Executes during object creation, after setting all properties.
function y_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_edit_Callback(hObject, eventdata, handles)
% hObject    handle to z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_edit as text
%        str2double(get(hObject,'String')) returns contents of z_edit as a double


% --- Executes during object creation, after setting all properties.
function z_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double


% --- Executes during object creation, after setting all properties.
function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes_yvsz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_yvsz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_yvsz


% --- Executes on selection change in plotmenu.
function plotmenu_Callback(hObject, eventdata, handles)
% hObject    handle to plotmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotmenu

    
% --- Executes during object creation, after setting all properties.
function plotmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function axes_yvsz_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to axes_yvsz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
