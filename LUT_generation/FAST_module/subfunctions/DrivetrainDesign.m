%% Initialization code
function varargout = DrivetrainDesign(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DrivetrainDesign_OpeningFcn, ...
                   'gui_OutputFcn',  @DrivetrainDesign_OutputFcn, ...
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

%% Opening function
function DrivetrainDesign_OpeningFcn(hObject, eventdata, handles, varargin)

% Get input
handles.Rated_Power = varargin{1};
handles.Generator_Efficiency = varargin{2};
handles.Generator_Torque = varargin{3};
handles.Generator_Speed = varargin{4};
handles.Generator_K = varargin{5};
handles.HSS_Inertia = varargin{6};
handles.Gearbox_Efficiency = varargin{7};
handles.Gearbox_Ratio = varargin{8};
handles.WindSpeed_Cutin = varargin{9};
handles.WindSpeed_Cutout = varargin{10};
handles.Max_TipSpeed = varargin{11};
handles.Blade_PitchOffset = varargin{12};
handles.Input = varargin;

% Update input fields
set(handles.Rated_Power_textbox, 'String', num2str(handles.Rated_Power/1e6));
set(handles.Generator_Efficiency_textbox, 'String', num2str(handles.Generator_Efficiency));
set(handles.Generator_Torque_textbox, 'String', num2str(handles.Generator_Torque));
set(handles.Generator_Speed_textbox, 'String', num2str(handles.Generator_Speed));
set(handles.Generator_K_textbox, 'String', num2str(handles.Generator_K));
set(handles.HSS_Inertia_textbox, 'String', num2str(handles.HSS_Inertia));
set(handles.Gearbox_Efficiency_textbox, 'String', num2str(handles.Gearbox_Efficiency));
set(handles.Gearbox_Ratio_textbox, 'String', num2str(handles.Gearbox_Ratio));
set(handles.WindSpeed_Cutin_textbox, 'String', num2str(handles.WindSpeed_Cutin));
set(handles.WindSpeed_Cutout_textbox, 'String', num2str(handles.WindSpeed_Cutout));
set(handles.Max_TipSpeed_textbox, 'String', num2str(handles.Max_TipSpeed));
set(handles.Blade_PitchOffset_textbox, 'String', num2str(handles.Blade_PitchOffset));

% Update handles structure
guidata(hObject, handles);

% Halt window
uiwait(handles.DrivetrainDesign);

%% Closing function
function DrivetrainDesign_CloseRequestFcn(hObject, eventdata, handles)
button = questdlg('Save changes?');
if strcmp(button, 'Yes')
    handles.Save = true;
    guidata(hObject, handles);
    uiresume(hObject);
elseif strcmp(button, 'No')
    handles.Save = false;
    guidata(hObject, handles);
    uiresume(hObject);
end
    
%% Save button
function Apply_Callback(hObject, eventdata, handles)
handles.Save = true;
guidata(hObject, handles);
uiresume(handles.DrivetrainDesign);

%% Cancel button
function Cancel_Callback(hObject, eventdata, handles)
handles.Save = false;
guidata(hObject, handles);
uiresume(handles.DrivetrainDesign);

%% Output function
function varargout = DrivetrainDesign_OutputFcn(hObject, eventdata, handles) 

% Set output
if handles.Save
    varargout{1} = handles.Rated_Power;
    varargout{2} = handles.Generator_Efficiency;
    varargout{3} = handles.Generator_Torque;
    varargout{4} = handles.Generator_Speed;
    varargout{5} = handles.Generator_K;
    varargout{6} = handles.HSS_Inertia;
    varargout{7} = handles.Gearbox_Efficiency;
    varargout{8} = handles.Gearbox_Ratio;
    varargout{9} = handles.WindSpeed_Cutin;
    varargout{10} = handles.WindSpeed_Cutout;
    varargout{11} = handles.Max_TipSpeed;
    varargout{12} = handles.Blade_PitchOffset;
else
    varargout = handles.Input;
end

% Close figure
delete(hObject)

%% Generator efficiency - text box
function Generator_Efficiency_textbox_Callback(hObject, eventdata, handles)
if str2double(get(hObject,'String')) > 1
    set(hObject, 'String', '1')
elseif str2double(get(hObject,'String')) < 0
    set(hObject, 'String', '0')
elseif isnan(str2double(get(hObject,'String')))
    set(hObject, 'String', num2str(handles.Generator_Efficiency))
end
handles.Generator_Efficiency = str2double(get(hObject,'String'));
guidata(hObject, handles);
function Generator_Efficiency_textbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Rated generator power - text box
function Rated_Power_textbox_Callback(hObject, eventdata, handles)
if str2double(get(hObject,'String')) < 0
    set(hObject, 'String', '0')
elseif isnan(str2double(get(hObject,'String')))
    set(hObject, 'String', num2str(handles.Rated_Power)/1e6)
end
handles.Rated_Power = 1e6 * str2double(get(hObject,'String'));
guidata(hObject, handles);
function Rated_Power_textbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Rated generator torque - text box
function Generator_Torque_textbox_Callback(hObject, eventdata, handles)
if str2double(get(hObject,'String')) < 0
    set(hObject, 'String', '0')
elseif isnan(str2double(get(hObject,'String')))
    set(hObject, 'String', num2str(handles.Generator_Torque))
end
handles.Generator_Torque = str2double(get(hObject,'String'));
guidata(hObject, handles);
function Generator_Torque_textbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Rated generator speed - text box
function Generator_Speed_textbox_Callback(hObject, eventdata, handles)
if str2double(get(hObject,'String')) < 0
    set(hObject, 'String', '0')
elseif isnan(str2double(get(hObject,'String')))
    set(hObject, 'String', num2str(handles.Generator_Speed))
end
handles.Generator_Speed = str2double(get(hObject,'String'));
guidata(hObject, handles);
function Generator_Speed_textbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Optimal (region 2) mode gain - text box
function Generator_K_textbox_Callback(hObject, eventdata, handles)
if str2double(get(hObject,'String')) < 0
    set(hObject, 'String', '0')
elseif isnan(str2double(get(hObject,'String')))
    set(hObject, 'String', num2str(handles.Generator_K))
end
handles.Generator_K = str2double(get(hObject,'String'));
guidata(hObject, handles);
function Generator_K_textbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Inertia around high-speed shaft - text box
function HSS_Inertia_textbox_Callback(hObject, eventdata, handles)
if str2double(get(hObject,'String')) < 0
    set(hObject, 'String', '0')
elseif isnan(str2double(get(hObject,'String')))
    set(hObject, 'String', num2str(handles.HSS_Inertia))
end
handles.HSS_Inertia = str2double(get(hObject,'String'));
guidata(hObject, handles);
function HSS_Inertia_textbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Gearbox efficiency - text box
function Gearbox_Efficiency_textbox_Callback(hObject, eventdata, handles)
if str2double(get(hObject,'String')) > 1
    set(hObject, 'String', '1')
elseif str2double(get(hObject,'String')) < 0
    set(hObject, 'String', '0')
elseif isnan(str2double(get(hObject,'String')))
    set(hObject, 'String', num2str(handles.Gearbox_Efficiency))
end
handles.Gearbox_Efficiency = str2double(get(hObject,'String'));
guidata(hObject, handles);
function Gearbox_Efficiency_textbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Gearbox ratio - text box
function Gearbox_Ratio_textbox_Callback(hObject, eventdata, handles)
if str2double(get(hObject,'String')) < 0
    set(hObject, 'String', '0')
elseif isnan(str2double(get(hObject,'String')))
    set(hObject, 'String', num2str(handles.Gearbox_Ratio))
end
handles.Gearbox_Ratio = str2double(get(hObject,'String'));
guidata(hObject, handles);
function Gearbox_Ratio_textbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Cut-in wind speed - text box
function WindSpeed_Cutin_textbox_Callback(hObject, eventdata, handles)
if str2double(get(hObject,'String')) < 0
    set(hObject, 'String', '0')
elseif isnan(str2double(get(hObject,'String')))
    set(hObject, 'String', num2str(handles.WindSpeed_Cutin))
end
handles.WindSpeed_Cutin = str2double(get(hObject,'String'));
guidata(hObject, handles);
function WindSpeed_Cutin_textbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Cut-out wind speed - text box
function WindSpeed_Cutout_textbox_Callback(hObject, eventdata, handles)
if str2double(get(hObject,'String')) < 0
    set(hObject, 'String', '0')
elseif isnan(str2double(get(hObject,'String')))
    set(hObject, 'String', num2str(handles.WindSpeed_Cutout))
end
handles.WindSpeed_Cutout = str2double(get(hObject,'String'));
guidata(hObject, handles);
function WindSpeed_Cutout_textbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Maximum tip speed - text box
function Max_TipSpeed_textbox_Callback(hObject, eventdata, handles)
if str2double(get(hObject,'String')) < 0
    set(hObject, 'String', '0')
elseif isnan(str2double(get(hObject,'String')))
    set(hObject, 'String', num2str(handles.Max_TipSpeed))
end
handles.Max_TipSpeed = str2double(get(hObject,'String'));
guidata(hObject, handles);
function Max_TipSpeed_textbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Pitch offset - text box
function Blade_PitchOffset_textbox_Callback(hObject, eventdata, handles)
if isnan(str2double(get(hObject,'String')))
    set(hObject, 'String', num2str(handles.Blade_PitchOffset))
end
handles.Blade_PitchOffset = str2double(get(hObject,'String'));
guidata(hObject, handles);
function Blade_PitchOffset_textbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
