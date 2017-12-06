function varargout = DataViewer(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DataViewer_OpeningFcn, ...
    'gui_OutputFcn',  @DataViewer_OutputFcn, ...
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


%UPDATE TIME SERIES
function handles2give = UpdateTimeSeries(handles2give)
%% General parameters
LineWidth = 1.0;
FontSize = 12;

data = handles2give.data;
SelectedTrial = strcmp(data.Mouse_Name,handles2give.MouseName) & ...
    data.Cell_Counter == handles2give.CellNumber & ...
    data.Trial_Counter == handles2give.TrialNumber;

%% Update Information Display
set(handles2give.InformationDisplay_MouseName_Tag, 'String', handles2give.MouseName);
set(handles2give.InformationDisplay_CellNumber_Tag, 'String', handles2give.CellNumber);
set(handles2give.InformationDisplay_TrialNumber_Tag, 'String', handles2give.TrialNumber);
ExtractMouseGenotype = data.Mouse_Genotype(SelectedTrial);
set(handles2give.InformationDisplay_MouseGenotype_Tag, 'String', ExtractMouseGenotype{1,1});
ExtractTrialStartTime = datestr(datetime(data.Trial_StartTime(SelectedTrial,:)));
set(handles2give.InformationDisplay_TrialStartTime_Tag, 'String', ExtractTrialStartTime);
ExtractCellType = data.Cell_tdTomatoExpressing(SelectedTrial);
if strcmp(ExtractCellType{1,1}, 'True')
    set(handles2give.InformationDisplay_CellType_Tag, 'String', 'tdTomato+');
else
    set(handles2give.InformationDisplay_CellType_Tag, 'String', 'tdTomato-');
end
ExtractCellDepth = data.Cell_Depth(SelectedTrial);
set(handles2give.InformationDisplay_CellDepth_Tag, 'String', num2str(ExtractCellDepth));
ExtractTrialType = data.Trial_Type(SelectedTrial);
set(handles2give.InformationDisplay_TrialType_Tag, 'String', ExtractTrialType{1,1});

%% Data to plot

ExtractMembranePotential = data.Trial_MembranePotential(SelectedTrial);
handles2give.MembranePotential = ExtractMembranePotential{1,1};
handles2give.MembranePotentialTimeVector = 1:(length(handles2give.MembranePotential));
MembranePotential_SamplingRate = 40000;
handles2give.MembranePotentialTimeVector = handles2give.MembranePotentialTimeVector * (1000 / MembranePotential_SamplingRate);

ExtractWhiskerAngle = data.Trial_WhiskerAngle_C2_right(SelectedTrial);
handles2give.WhiskerAngle = ExtractWhiskerAngle{1,1};
handles2give.WhiskerAngleTimeVector = 1:(length(handles2give.WhiskerAngle));
WhiskerAngle_SamplingRate = 500;
handles2give.WhiskerAngleTimeVector = handles2give.WhiskerAngleTimeVector * (1000 / WhiskerAngle_SamplingRate);

if strcmp(char(data.Trial_Type(SelectedTrial)), 'active touch')
    ExtractPiezo = data.Trial_Piezo(SelectedTrial);
    handles2give.Piezo = ExtractPiezo{1,1};
    handles2give.PiezoTimeVector = 1:(length(handles2give.Piezo));
    Piezo_SamplingRate = 40000;
    handles2give.PiezoTimeVector = handles2give.PiezoTimeVector * (1000 / Piezo_SamplingRate);
end;
    
%% Plot membrane potential
axes(handles2give.MembranePotentialAxes);
plot(handles2give.MembranePotentialTimeVector, handles2give.MembranePotential,'Color','k','LineWidth',LineWidth);
set(gca,'FontSize',FontSize);
xlabel(['Time (ms)'],'FontWeight','Bold','FontSize',FontSize);
ylabel('Membrane potential (mV)','FontWeight','Bold','FontSize',FontSize);
axis([handles2give.TimeAxisMin handles2give.TimeAxisMax handles2give.MembranePotentialAxisMin handles2give.MembranePotentialAxisMax])
%set(gca,'XTickLabel',[])
box(gca,'off')

%% Plot right whisker angle
axes(handles2give.RightWhiskerAngleAxes);
plot(handles2give.WhiskerAngleTimeVector, handles2give.WhiskerAngle,'Color','g','LineWidth',LineWidth);
set(gca,'FontSize',FontSize);
xlabel(['Time (ms)'],'FontWeight','Bold','FontSize',FontSize);
ylabel('Right whisker (deg)','FontWeight','Bold','FontSize',FontSize);
axis([handles2give.TimeAxisMin handles2give.TimeAxisMax handles2give.WhiskerAxisMin handles2give.WhiskerAxisMax])
%set(gca,'XTickLabel',[])
box(gca,'off')

%% Plot Piezo
if strcmp(char(data.Trial_Type(SelectedTrial)), 'active touch')
    axes(handles2give.PiezoAxes);
    plot(handles2give.PiezoTimeVector, handles2give.Piezo,'Color','b','LineWidth',LineWidth);
    set(gca,'FontSize',FontSize);
    xlabel(['Time (ms)'],'FontWeight','Bold','FontSize',FontSize);
    ylabel('Piezo touch sensor (V)','FontWeight','Bold','FontSize',FontSize);
    axis([handles2give.TimeAxisMin handles2give.TimeAxisMax handles2give.PiezoAxisMin handles2give.PiezoAxisMax])
    %set(gca,'XTickLabel',[])
    box(gca,'off')
else
    axes(handles2give.PiezoAxes);
    plot(0, 0,'Color','b','LineWidth',LineWidth);
    set(gca,'FontSize',FontSize);
    xlabel(['Time (ms)'],'FontWeight','Bold','FontSize',FontSize);
    ylabel('Piezo touch sensor (V)','FontWeight','Bold','FontSize',FontSize);
    axis([handles2give.TimeAxisMin handles2give.TimeAxisMax handles2give.PiezoAxisMin handles2give.PiezoAxisMax])
    %set(gca,'XTickLabel',[])
    box(gca,'off')
end


% --- Executes just before DataViewer is made visible.
function DataViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DataViewer (see VARARGIN)

% Choose default command line output for DataViewer
handles.output = hObject;

%% Initialize the path
handles.MembranePotentialDir = '';
set(handles.MembranePotentialFileTag,'String',handles.MembranePotentialDir);

%% Set axis scaling
handles.MembranePotentialAxisMin = -80; set(handles.MembranePotentialAxisMinTag,'String',num2str(handles.MembranePotentialAxisMin));
handles.MembranePotentialAxisMax = 40; set(handles.MembranePotentialAxisMaxTag,'String',num2str(handles.MembranePotentialAxisMax));

handles.WhiskerAxisMin = 100; set(handles.WhiskerAxisMinTag,'String',num2str(handles.WhiskerAxisMin));
handles.WhiskerAxisMax = 300; set(handles.WhiskerAxisMaxTag,'String',num2str(handles.WhiskerAxisMax));

handles.PiezoAxisMin = -1; set(handles.PiezoAxisMinTag,'String',num2str(handles.PiezoAxisMin));
handles.PiezoAxisMax = 1; set(handles.PiezoAxisMaxTag,'String',num2str(handles.PiezoAxisMax));

handles.TimeAxisMin = 0; set(handles.TimeAxisMinTag,'String',num2str(handles.TimeAxisMin));
handles.TimeAxisMax = 3000; set(handles.TimeAxisMaxTag,'String',num2str(handles.TimeAxisMax));

% %% Load data
% currentFolder = pwd;
% if ispc
%     MatlabFile = fullfile([currentFolder '\*.mat']);
%     MouseFileName = dir(MatlabFile);
%     load([currentFolder '\' MouseFileName.name]);
% elseif ismac
%     MatlabFile = fullfile([currentFolder '/*.mat']);
%     MouseFileName = dir(MatlabFile);
%     load([currentFolder '/' MouseFileName.name]);
% end
% handles.data = data;
% 
% %% Set mouse name
% handles.MouseNameList = unique(data.Mouse_Name);
% set(handles.MouseName_Popupmenu,'String',handles.MouseNameList);
% set(handles.MouseName_Popupmenu,'Value',1);
% handles.MouseName = handles.MouseNameList{get(handles.MouseName_Popupmenu,'Value')};
% 
% %% Set cell number
% handles.CellNumberList = unique(handles.data.Cell_Counter(strcmp(handles.data.Mouse_Name,handles.MouseName)));
% set(handles.CellNumber_Popupmenu,'String',handles.CellNumberList);
% set(handles.CellNumber_Popupmenu,'Value',1);
% handles.CellNumber = handles.CellNumberList(get(handles.CellNumber_Popupmenu,'Value'));
% 
% %% Set trial number
% handles.TrialNumberList = unique(handles.data.Trial_Counter(strcmp(handles.data.Mouse_Name,handles.MouseName) & handles.data.Cell_Counter == handles.CellNumber));
% set(handles.TrialNumber_Popupmenu,'String',handles.TrialNumberList);
% set(handles.TrialNumber_Popupmenu,'Value',1);
% handles.TrialNumber = handles.TrialNumberList(get(handles.TrialNumber_Popupmenu,'Value'));
% 
% %% Set axes
% handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DataViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DataViewer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in MouseName_Popupmenu.
function MouseName_Popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to MouseName_Popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MouseName_Popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MouseName_Popupmenu

handles.MouseName = handles.MouseNameList{get(handles.MouseName_Popupmenu,'Value')};

handles.CellNumberList = unique(handles.data.Cell_Counter(strcmp(handles.data.Mouse_Name,handles.MouseName)));
set(handles.CellNumber_Popupmenu,'String',handles.CellNumberList);
handles.CellNumber = handles.CellNumberList(1);
set(handles.CellNumber_Popupmenu,'Value',1);

handles.TrialNumberList = unique(handles.data.Trial_Counter(strcmp(handles.data.Mouse_Name,handles.MouseName) & handles.data.Cell_Counter == handles.CellNumber));
set(handles.TrialNumber_Popupmenu,'String',handles.TrialNumberList);
handles.TrialNumber = 1;
set(handles.TrialNumber_Popupmenu,'Value',1);

handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function MouseName_Popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MouseName_Popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in CellNumber_Popupmenu.
function CellNumber_Popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to CellNumber_Popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CellNumber_Popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CellNumber_Popupmenu

handles.CellNumber = handles.CellNumberList(get(handles.CellNumber_Popupmenu,'Value'));

handles.TrialNumberList = unique(handles.data.Trial_Counter(strcmp(handles.data.Mouse_Name,handles.MouseName) & handles.data.Cell_Counter == handles.CellNumber));
set(handles.TrialNumber_Popupmenu,'String',handles.TrialNumberList);
handles.TrialNumber = 1;
set(handles.TrialNumber_Popupmenu,'Value',1);

handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function CellNumber_Popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CellNumber_Popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TrialNumber_Popupmenu.
function TrialNumber_Popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to TrialNumber_Popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TrialNumber_Popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TrialNumber_Popupmenu

handles.TrialNumber = handles.TrialNumberList(get(handles.TrialNumber_Popupmenu,'Value'));

handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TrialNumber_Popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TrialNumber_Popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%
% --- Change Axes Scale --- 
%
function WhiskerAxisMinTag_Callback(hObject, eventdata, handles)
% hObject    handle to WhiskerAxisMinTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WhiskerAxisMinTag as text
%        str2double(get(hObject,'String')) returns contents of WhiskerAxisMinTag as a double

handles.WhiskerAxisMin = round(str2double(get(handles.WhiskerAxisMinTag,'String')));

% Change the text
set(handles.WhiskerAxisMinTag,'String',num2str(handles.WhiskerAxisMin));

handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function WhiskerAxisMinTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WhiskerAxisMinTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function WhiskerAxisMaxTag_Callback(hObject, eventdata, handles)
% hObject    handle to WhiskerAxisMaxTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WhiskerAxisMaxTag as text
%        str2double(get(hObject,'String')) returns contents of WhiskerAxisMaxTag as a double

handles.WhiskerAxisMax = round(str2double(get(handles.WhiskerAxisMaxTag,'String')));

% Change the text
set(handles.WhiskerAxisMaxTag,'String',num2str(handles.WhiskerAxisMax));

handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function WhiskerAxisMaxTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WhiskerAxisMaxTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TimeAxisMinTag_Callback(hObject, eventdata, handles)
% hObject    handle to TimeAxisMinTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeAxisMinTag as text
%        str2double(get(hObject,'String')) returns contents of TimeAxisMinTag as a double

handles.TimeAxisMin = round(str2double(get(handles.TimeAxisMinTag,'String')));

% Change the text
set(handles.TimeAxisMinTag,'String',num2str(handles.TimeAxisMin));

handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TimeAxisMinTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeAxisMinTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TimeAxisMaxTag_Callback(hObject, eventdata, handles)
% hObject    handle to TimeAxisMaxTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeAxisMaxTag as text
%        str2double(get(hObject,'String')) returns contents of TimeAxisMaxTag as a double

handles.TimeAxisMax = round(str2double(get(handles.TimeAxisMaxTag,'String')));

% Change the text
set(handles.TimeAxisMaxTag,'String',num2str(handles.TimeAxisMax));

handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TimeAxisMaxTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeAxisMaxTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MembranePotentialAxisMinTag_Callback(hObject, eventdata, handles)
% hObject    handle to MembranePotentialAxisMinTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MembranePotentialAxisMinTag as text
%        str2double(get(hObject,'String')) returns contents of MembranePotentialAxisMinTag as a double

handles.MembranePotentialAxisMin = round(str2double(get(handles.MembranePotentialAxisMinTag,'String')));

% Change the text
set(handles.MembranePotentialAxisMinTag,'String',num2str(handles.MembranePotentialAxisMin));

handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function MembranePotentialAxisMinTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MembranePotentialAxisMinTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MembranePotentialAxisMaxTag_Callback(hObject, eventdata, handles)
% hObject    handle to MembranePotentialAxisMaxTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MembranePotentialAxisMaxTag as text
%        str2double(get(hObject,'String')) returns contents of MembranePotentialAxisMaxTag as a double

handles.MembranePotentialAxisMax = round(str2double(get(handles.MembranePotentialAxisMaxTag,'String')));

% Change the text
set(handles.MembranePotentialAxisMaxTag,'String',num2str(handles.MembranePotentialAxisMax));

handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function MembranePotentialAxisMaxTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MembranePotentialAxisMaxTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function PiezoAxisMinTag_Callback(hObject, eventdata, handles)
% hObject    handle to PiezoAxisMinTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PiezoAxisMinTag as text
%        str2double(get(hObject,'String')) returns contents of PiezoAxisMinTag as a double

handles.PiezoAxisMin = str2double(get(handles.PiezoAxisMinTag,'String'));

% Change the text
set(handles.PiezoAxisMinTag,'String',num2str(handles.PiezoAxisMin));

handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PiezoAxisMinTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PiezoAxisMinTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PiezoAxisMaxTag_Callback(hObject, eventdata, handles)
% hObject    handle to PiezoAxisMaxTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PiezoAxisMaxTag as text
%        str2double(get(hObject,'String')) returns contents of PiezoAxisMaxTag as a double

handles.PiezoAxisMax = str2double(get(handles.PiezoAxisMaxTag,'String'));

% Change the text
set(handles.PiezoAxisMaxTag,'String',num2str(handles.PiezoAxisMax));

handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PiezoAxisMaxTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PiezoAxisMaxTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ResetScalingPushbutton.
function ResetScalingPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ResetScalingPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.MembranePotentialAxisMin = -80;
handles.MembranePotentialAxisMax = 40;
handles.WhiskerAxisMin = 100;
handles.WhiskerAxisMax = 300;
handles.PiezoAxisMin = -1;
handles.PiezoAxisMax = 1;
handles.TimeAxisMin = 0;
handles.TimeAxisMax = 3000;

% Change the text
set(handles.MembranePotentialAxisMinTag,'String',num2str(handles.MembranePotentialAxisMin));
set(handles.MembranePotentialAxisMaxTag,'String',num2str(handles.MembranePotentialAxisMax));
set(handles.WhiskerAxisMinTag,'String',num2str(handles.WhiskerAxisMin));
set(handles.WhiskerAxisMaxTag,'String',num2str(handles.WhiskerAxisMax));
set(handles.PiezoAxisMinTag,'String',num2str(handles.PiezoAxisMin));
set(handles.PiezoAxisMaxTag,'String',num2str(handles.PiezoAxisMax));
set(handles.TimeAxisMinTag,'String',num2str(handles.TimeAxisMin));
set(handles.TimeAxisMaxTag,'String',num2str(handles.TimeAxisMax));

handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in MoveBackButton.
function MoveBackButton_Callback(hObject, eventdata, handles)
% hObject    handle to MoveBackButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
move_time = (handles.TimeAxisMax - handles.TimeAxisMin) * 0.8;
handles.TimeAxisMin = handles.TimeAxisMin - move_time;
handles.TimeAxisMax = handles.TimeAxisMax - move_time;
set(handles.TimeAxisMinTag,'String',num2str(handles.TimeAxisMin));
set(handles.TimeAxisMaxTag,'String',num2str(handles.TimeAxisMax));
handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in MoveForwardsButton.
function MoveForwardsButton_Callback(hObject, eventdata, handles)
% hObject    handle to MoveForwardsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
move_time = (handles.TimeAxisMax - handles.TimeAxisMin) * 0.8;
handles.TimeAxisMin = handles.TimeAxisMin + move_time;
handles.TimeAxisMax = handles.TimeAxisMax + move_time;
set(handles.TimeAxisMinTag,'String',num2str(handles.TimeAxisMin));
set(handles.TimeAxisMaxTag,'String',num2str(handles.TimeAxisMax));
handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in AutoscaleButton.
function AutoscaleButton_Callback(hObject, eventdata, handles)
% hObject    handle to AutoscaleButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.MembranePotentialAxisMin = min(handles.MembranePotential);
handles.MembranePotentialAxisMax = max(handles.MembranePotential);
handles.WhiskerAxisMin = min(handles.WhiskerAngle);
handles.WhiskerAxisMax = max(handles.WhiskerAngle);
handles.PiezoAxisMin = min(handles.Piezo);
handles.PiezoAxisMax = max(handles.Piezo);
handles.TimeAxisMin = min(handles.MembranePotentialTimeVector);
handles.TimeAxisMax = max(handles.MembranePotentialTimeVector);

% Change the text
set(handles.MembranePotentialAxisMinTag,'String',num2str(handles.MembranePotentialAxisMin));
set(handles.MembranePotentialAxisMaxTag,'String',num2str(handles.MembranePotentialAxisMax));
set(handles.WhiskerAxisMinTag,'String',num2str(handles.WhiskerAxisMin));
set(handles.WhiskerAxisMaxTag,'String',num2str(handles.WhiskerAxisMax));
set(handles.PiezoAxisMinTag,'String',num2str(handles.PiezoAxisMin));
set(handles.PiezoAxisMaxTag,'String',num2str(handles.PiezoAxisMax));
set(handles.TimeAxisMinTag,'String',num2str(handles.TimeAxisMin));
set(handles.TimeAxisMaxTag,'String',num2str(handles.TimeAxisMax));

handles = UpdateTimeSeries(handles);

% Update handles structure
guidata(hObject, handles);

function MembranePotentialFileTag_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LoadButton as text
%        str2double(get(hObject,'String')) returns contents of LoadButton as a double


% --- Executes during object creation, after setting all properties.
function MembranePotentialFileTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.MembranePotentialfilename, handles.MembranePotentialDir] = uigetfile('*.mat') ;
set(handles.MembranePotentialFileTag,'String',handles.MembranePotentialfilename);

%% Load data
MatlabFile = fullfile(handles.MembranePotentialDir,handles.MembranePotentialfilename);
tic
load(MatlabFile);
toc
handles.data = data;

%% Set mouse name
handles.MouseNameList = unique(handles.data.Mouse_Name);
set(handles.MouseName_Popupmenu,'String',handles.MouseNameList);
set(handles.MouseName_Popupmenu,'Value',1);
handles.MouseName = handles.MouseNameList{get(handles.MouseName_Popupmenu,'Value')};

%% Set cell number
handles.CellNumberList = unique(handles.data.Cell_Counter(strcmp(handles.data.Mouse_Name,handles.MouseName)));
set(handles.CellNumber_Popupmenu,'String',handles.CellNumberList);
set(handles.CellNumber_Popupmenu,'Value',1);
handles.CellNumber = handles.CellNumberList(get(handles.CellNumber_Popupmenu,'Value'));

%% Set trial number
handles.TrialNumberList = unique(handles.data.Trial_Counter(strcmp(handles.data.Mouse_Name,handles.MouseName) & handles.data.Cell_Counter == handles.CellNumber));
set(handles.TrialNumber_Popupmenu,'String',handles.TrialNumberList);
set(handles.TrialNumber_Popupmenu,'Value',1);
handles.TrialNumber = handles.TrialNumberList(get(handles.TrialNumber_Popupmenu,'Value'));

%% Set axes
handles = UpdateTimeSeries(handles);
guidata(hObject, handles);


% --- Executes on button press in PreviousTrialButton.
function PreviousTrialButton_Callback(hObject, eventdata, handles)
% hObject    handle to PreviousTrialButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TrialNumberValueOld = get(handles.TrialNumber_Popupmenu,'Value');
if TrialNumberValueOld==1
    set(handles.TrialNumber_Popupmenu,'Value',TrialNumberValueOld);
else
    set(handles.TrialNumber_Popupmenu,'Value',TrialNumberValueOld-1);
end
handles.TrialNumber=handles.TrialNumberList(get(handles.TrialNumber_Popupmenu,'Value'));

handles = UpdateTimeSeries(handles);
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in NextTrialButton.
function NextTrialButton_Callback(hObject, eventdata, handles)
% hObject    handle to NextTrialButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TrialNumberValueOld = get(handles.TrialNumber_Popupmenu,'Value');
if TrialNumberValueOld==numel(handles.TrialNumberList)
    set(handles.TrialNumber_Popupmenu,'Value',TrialNumberValueOld);
else
    set(handles.TrialNumber_Popupmenu,'Value',TrialNumberValueOld+1);
end
handles.TrialNumber=handles.TrialNumberList(get(handles.TrialNumber_Popupmenu,'Value'));

handles = UpdateTimeSeries(handles);
% Update handles structure
guidata(hObject, handles);
