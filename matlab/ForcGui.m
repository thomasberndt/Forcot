function varargout = ForcGui(varargin)
% FORCGUI MATLAB code for ForcGui.fig
%      FORCGUI, by itself, creates a new FORCGUI or raises the existing
%      singleton*.
%
%      H = FORCGUI returns the handle to a new FORCGUI or the handle to
%      the existing singleton*.
%
%      FORCGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORCGUI.M with the given input arguments.
%
%      FORCGUI('Property','Value',...) creates a new FORCGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ForcGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ForcGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ForcGui

% Last Modified by GUIDE v2.5 31-Oct-2018 15:14:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ForcGui_OpeningFcn, ...
                   'gui_OutputFcn',  @ForcGui_OutputFcn, ...
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


% --- Executes just before ForcGui is made visible.
function ForcGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ForcGui (see VARARGIN)

% Choose default command line output for ForcGui
handles.output = hObject;

handles.ForcFigure = figure(); 

pos = hObject.OuterPosition; 

hObject.OuterPosition = [20 50 pos(3) pos(4)]; 
pos = hObject.OuterPosition; 
handles.ForcFigure.OuterPosition = [pos(1)+pos(3) pos(2) pos(4) pos(4)]; 
handles.ForcAxes = axes;

TightAxis(handles); 

set(handles.ForcFigure, 'Color', 'w');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ForcGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ForcGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OpenButton.
function OpenButton_Callback(hObject, eventdata, handles)
% hObject    handle to OpenButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.files, handles.pathname, handles.ext, handles.n] = OpenForcDialog();
set(handles.FileListBox, 'String', handles.files);
set(handles.FileListBox, 'Value',  handles.n);
try
    LoadForc(handles);
catch
end
SaveState(hObject,handles);

% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SaveFigure(handles); 
SaveState(hObject,handles);


% --- Executes on selection change in FileListBox.
function FileListBox_Callback(hObject, eventdata, handles)
% hObject    handle to FileListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FileListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileListBox
handles = LoadForc(handles);
figure(handles.output);
SaveState(hObject,handles);
    
% --- Executes during object creation, after setting all properties.
function FileListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function handles = LoadForc(handles)
disp('click');
tic
    cla(handles.ForcAxes); 
    handles.n = get(handles.FileListBox, 'Value');
    handles.filename = sprintf('%s%s', handles.pathname, handles.files{handles.n}); 
    try
        handles.manualSF = [];
        toc
        disp('load and process'); 
        tic
        handles.princeton = LoadAndProcessPrincetonForc(handles.filename); 
        toc
        set(handles.SFTextBox, 'String', num2str(handles.princeton.forc.SF));
        disp('power spectrum');
        tic
        GuiPlotPowerSpectrum(handles);
        toc
        disp('plotting');
        tic
        GuiPlotForc(handles);       
        toc
    catch ME
        RaiseIssue(handles, ME); 
        axes(handles.ForcAxes); 
        text(0.1, 0.5 ,ME.message);
    end
    
function RaiseIssue(handles, ex)
    url = 'https://api.github.com/repos/thomasberndt/FFT-FORC/issues'; 
    opt = weboptions(...
        'Username', 'thomasberndt', ...
        'Password', 'ak5Dfp*6n>s', ...
        'ContentType', 'json', ...
        'HeaderFields', {'Accept' 'application/vnd.github.v3+json'}); 
    S = webwrite(url, ...
        'title', ex.message, ...
        'body', getReport(ex), opt);
    
function SaveState(hObject,handles)
    guidata(hObject,handles);
%     save('programsettings', 'handles'); 

function GuiPlotForc(handles)
    axes(handles.ForcAxes); 
    [~,name] = fileparts(handles.princeton.filename);
    title(sprintf('%s', name));
    PlotFORC(handles.princeton.forc);
    title(sprintf('%s', name));
    drawnow;
    
function TightAxis(handles)
    outerpos = handles.ForcAxes.OuterPosition;
    ti = handles.ForcAxes.TightInset; 
    left = outerpos(1) + 2.4*ti(1);
    bottom = outerpos(2) + 2.5*ti(2);
    ax_width = outerpos(3) - 2.2*ti(1) - ti(3);
    ax_height = outerpos(4) - 3*ti(2) - ti(4);
    handles.ForcAxes.Position = [left bottom ax_width ax_height];


function GuiPlotPowerSpectrum(handles)
    axes(handles.PowerAxes); 
    semilogy(handles.princeton.forc.d, handles.princeton.forc.PowerSpectrum, 'o-');
    xlabel('Frequency [normalized]'); 
    ylabel('Power'); 
    grid on
    drawnow;
    
function SaveFigure(handles)
    [path,name,ext] = fileparts(handles.filename);
    filetypes = {...
            '*.png', 'Portable Network Graphics file (*.png)'; ...
            '*.pdf', 'Portable Document Format (*.pdf)'; ...
            '*.eps', 'EPS file (*.eps)'; ...
            '*.jpg', 'JPEG image (*.jpg)'; ...
            '*.svg', 'Scalable Vector Graphics file (*.svg)'; ...
            '*.tif', 'TIFF image (*.tif)'; ...
            '*.bmp', 'Bitmap file (*.bmp)'; ...
            '*.fig', 'MATLAB Figure (*.fig)'};
    [file,path,indx] = uiputfile(filetypes, 'File Selection', fullfile(path, [name '.png']));
    [~,name,ext] = fileparts(file);
    if ~isequal(file,0) && ~isequal(path,0)
        export_fig(handles.ForcFigure, fullfile(path,file), '-m4');
    end
    
    
    
    
    



function SFTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to SFTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SFTextBox as text
%        str2double(get(hObject,'String')) returns contents of SFTextBox as a double
    SF = get(handles.SFTextBox, 'String'); 
    goodSF = true;
    try 
        handles.manualSF = str2double(SF);
    catch ME
        goodSF = false; 
        handles.manualSF = [];
    end
    if goodSF
        try
            handles.princeton.forc = SmoothForcFft(handles.princeton, handles.manualSF);
            handles.princeton.forc.maxHc = 0.9*handles.princeton.forc.maxHc;
            handles.princeton.forc.maxHu = 0.9*handles.princeton.forc.maxHu;
            GuiPlotForc(handles);        
        catch ME
            axes(handles.ForcAxes); 
            text(0.1, 0.5 ,ME.message);
        end
    end

% --- Executes during object creation, after setting all properties.
function SFTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SFTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on SFTextBox and none of its controls.
function SFTextBox_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to SFTextBox (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


