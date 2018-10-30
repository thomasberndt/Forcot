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

% Last Modified by GUIDE v2.5 30-Oct-2018 14:44:02

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
    axes(handles.ForcAxes); 
    cla
    
    handles.n = get(handles.FileListBox, 'Value');
    handles.filename = sprintf('%s%s', handles.pathname, handles.files{handles.n}); 
    try
        handles.princeton = LoadAndProcessPrincetonForc(handles.filename);        
        GuiPlotPowerSpectrum(handles);
        GuiPlotForc(handles);         
    catch ME
        axes(handles.ForcAxes); 
        text(0.1, 0.5 ,ME.message);
    end
    
    
function SaveState(hObject,handles)
    guidata(hObject,handles);
    save('programsettings', 'handles'); 

function GuiPlotForc(handles)
    axes(handles.ForcAxes); 
    PlotFORC(handles.princeton.forc);
    [~,name] = fileparts(handles.princeton.filename);
    title(sprintf('%s (SF=%g)', name, handles.princeton.forc.SF));
    drawnow;

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
    if ~isequal(file,0) && ~isequal(path,0)
        set(handles.PowerAxes, 'Visible', 'off');
        axes(handles.PowerAxes);
        cla;
        fig = gcf;
        fig.PaperPositionMode = 'auto';
        print(fullfile(path,file),'-dpng','-r0', '-noui');
        set(handles.PowerAxes, 'Visible', 'on');
        GuiPlotPowerSpectrum(handles);
    end
    
    
    
    
    