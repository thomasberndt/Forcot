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

% Last Modified by GUIDE v2.5 05-Nov-2018 15:27:12

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

handles.MessageText = [];
handles.SendDiagnosticDataButton = [];
handles.ForcFigure = figure(); 

pos = hObject.OuterPosition; 

myunits = get(hObject, 'Units');  
hObject.OuterPosition = [10 10 pos(3) pos(4)]; 
set(hObject, 'Units', 'pixels'); 
pos = hObject.OuterPosition; 
set(hObject, 'Units', myunits); 
handles.ForcFigure.OuterPosition = [pos(1)+pos(3) pos(2) pos(4) pos(4)]; 
handles.ForcAxes = axes;

TightAxis(handles); 

set(handles.ForcFigure, 'Color', 'w');
handles = LoadState(hObject, handles);

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
if isfield(handles, 'output')
    varargout{1} = handles.output;
else 
    varargout{1} = '';
end


% --- Executes on button press in OpenButton.
function OpenButton_Callback(hObject, eventdata, handles)
% hObject    handle to OpenButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'pathname')
    [handles.files, handles.pathname, handles.ext, handles.n] = ...
        OpenForcDialog(handles.pathname);
else
    [handles.files, handles.pathname, handles.ext, handles.n] = ...
        OpenForcDialog();
end
set(handles.FileListBox, 'String', handles.files);
set(handles.FileListBox, 'Value',  handles.n);
try
    handles = LoadForc(hObject, handles);
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
handles = LoadForc(hObject, handles);
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

function DeleteThing(thing)
    try
        delete(thing);
    catch
    end
    

function handles = LoadForc(hObject, handles)
    cla(handles.ForcAxes); 
    DeleteThing(handles.MessageText);
    DeleteThing(handles.SendDiagnosticDataButton);
    handles.n = get(handles.FileListBox, 'Value');
    handles.filename = fullfile(handles.pathname, handles.files{handles.n}); 
    [~,name] = fileparts(handles.filename);
    set(handles.TitleTextBox, 'String', name); 
    title(handles.ForcAxes, name); 
    handles.MessageText = text(handles.ForcAxes, 0.1, 0.5, ...
            'Loading FORC', ...
            'VerticalAlignment', 'bottom', ...
            'Color', 'b');
    drawnow
    try
        handles.manualSF = [];
        handles.princeton = LoadAndProcessPrincetonForc(handles.filename); 
        set(handles.SFTextBox, 'String', num2str(handles.princeton.forc.SF));
        set(handles.Hu_TextBox, 'String', num2str(round(handles.princeton.forc.maxHu*1000)));
        set(handles.Hc_TextBox, 'String', num2str(round(handles.princeton.forc.maxHc*1000)));
        DeleteThing(handles.MessageText);
        GuiPlotForc(handles);  
        GuiPlotPowerSpectrum(handles);   
    catch ME
        axes(handles.ForcAxes);
        handles.ME = ME; 
        DeleteThing(handles.MessageText);
        handles.MessageText = text(0.1, 0.5, ...
            sprintf('%s\n\nWould you like to send data to the authors to assist fixing the problem?', ...
            ME.message), ...
            'VerticalAlignment', 'bottom', ...
            'Color', 'r');
        handles.SendDiagnosticDataButton = uicontrol('Style','pushbutton',...
             'String','Send data to authors', ...
             'Units', 'normalized', ...
             'Position',[0.15,0.3,0.25,0.08], ...
             'Callback',{@(source, eventdata) SendDiagnosticData_Callback(source, eventdata, handles)});
        guidata(hObject, handles);
        drawnow;
    end
    
    
function SendDiagnosticData_Callback(source, eventdata, handles) 
    DeleteThing(handles.MessageText);
    DeleteThing(source); 
    axes(handles.ForcAxes);
    handles.MessageText = text(0.1, 0.5, ...
            sprintf('%s\n\nSending diagnostic data to authors... please wait', ...
            handles.ME.message), ...
            'VerticalAlignment', 'bottom', ...
            'Color', [.5 .5 0]);
    drawnow;
    try
        sent = RaiseIssue(handles); 
    catch
        sent = false; 
    end
    DeleteThing(handles.MessageText);
    if sent
        handles.MessageText = text(0.1, 0.5, ...
            sprintf('%s\nData sent.\nWe are working hard to fix the problem.', ...
            handles.ME.message), ...
            'VerticalAlignment', 'bottom', ...
            'Color', 'b');
    else
        handles.MessageText = text(0.1, 0.5, ...
            sprintf('%s\n\nDiagnosic data could not be sent.\nYou can help improve this software by sending the FORC diagram \n to the authors at thomas.andreas.berndt@gmail.com', ...
            handles.ME.message), ...
            'VerticalAlignment', 'bottom', ...
            'Color', [1 0 0]);
    end
    drawnow;
    
function handles = LoadState(hObject, handles)
    try
        stufftoload = load('programsettings.mat'); 
        stufftoload = stufftoload.stufftosave; 
        if isfield(stufftoload, 'filename')
            handles.filename = stufftoload.filename; 
            [handles.pathname, name, handles.ext] = fileparts(handles.filename);
            files = dir(sprintf('%s/*%s', handles.pathname, handles.ext)); 
            handles.files = {files.name};
            set(handles.FileListBox, 'String', handles.files);
            handles.n = find(strcmpi(handles.files, [name handles.ext])); 
            if ~isempty(handles.n)
                set(handles.FileListBox, 'Value',  handles.n);
                handles = LoadForc(hObject, handles);
            end  
        end
    catch
    end
    
function SaveState(hObject, handles)
    stufftosave = struct(); 
    stufftosave.filename = handles.filename; 
    guidata(hObject,handles);
    save('programsettings', 'stufftosave'); 

function GuiPlotForc(handles)
    axes(handles.ForcAxes); 
    [~,name] = fileparts(handles.princeton.filename);
    PlotFORC(handles.princeton.forc);
    title(sprintf('%s', name));
    drawnow;
    
function TightAxis(handles)
    outerpos = handles.ForcAxes.OuterPosition;
    ti = handles.ForcAxes.TightInset; 
    left = outerpos(1) + 2.6*ti(1);
    bottom = outerpos(2) + 2.5*ti(2);
    ax_width = outerpos(3) - 2.6*ti(1) - ti(3);
    ax_height = outerpos(4) - 3.1*ti(2) - ti(4);
    handles.ForcAxes.Position = [left bottom ax_width ax_height];


function GuiPlotPowerSpectrum(handles)
    axes(handles.PowerAxes); 
    SFs = handles.princeton.forc.SFs;
    PowerSpectrum = handles.princeton.forc.PowerSpectrum;
    n = find(handles.princeton.forc.SFs >= handles.princeton.forc.SF & ...
        ~isnan(PowerSpectrum), 1, 'first');
    plot(SFs, PowerSpectrum, 'o-', SFs(n), PowerSpectrum(n), 'o');
    xlabel('SF'); 
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
            handles.princeton.forc.maxHc = str2double(get(handles.Hc_TextBox, 'string'))/1000;
            handles.princeton.forc.maxHu = str2double(get(handles.Hu_TextBox, 'string'))/1000;
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



function Hu_TextBox_Callback(hObject, eventdata, handles)
% hObject    handle to Hu_TextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Hu_TextBox as text
%        str2double(get(hObject,'String')) returns contents of Hu_TextBox as a double
    handles = SetAxisLimits(handles);
    SaveState(hObject,handles); 

% --- Executes during object creation, after setting all properties.
function Hu_TextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Hu_TextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function handles = SetAxisLimits(handles)
    handles.princeton.forc.maxHc = str2double(get(handles.Hc_TextBox, 'string'))/1000;
    handles.princeton.forc.maxHu = str2double(get(handles.Hu_TextBox, 'string'))/1000;
    axis(handles.ForcAxes, [0 handles.princeton.forc.maxHc ...
        -handles.princeton.forc.maxHu handles.princeton.forc.maxHu]); 

function Hc_TextBox_Callback(hObject, eventdata, handles)
% hObject    handle to Hc_TextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Hc_TextBox as text
%        str2double(get(hObject,'String')) returns contents of Hc_TextBox as a double
    handles = SetAxisLimits(handles);
    SaveState(hObject,handles); 

% --- Executes during object creation, after setting all properties.
function Hc_TextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Hc_TextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TitleTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to TitleTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TitleTextBox as text
%        str2double(get(hObject,'String')) returns contents of TitleTextBox as a double
title(handles.ForcAxes, get(hObject, 'String')); 

% --- Executes during object creation, after setting all properties.
function TitleTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TitleTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveAllButton.
function SaveAllButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveAllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    filetypes = {...
            '*.png', 'Portable Network Graphics file (*.png)'; ...
            '*.pdf', 'Portable Document Format (*.pdf)'; ...
            '*.eps', 'EPS file (*.eps)'; ...
            '*.jpg', 'JPEG image (*.jpg)'; ...
            '*.svg', 'Scalable Vector Graphics file (*.svg)'; ...
            '*.tif', 'TIFF image (*.tif)'; ...
            '*.bmp', 'Bitmap file (*.bmp)'; ...
            '*.fig', 'MATLAB Figure (*.fig)'};
    [file,path,indx] = uiputfile(filetypes, 'File Selection', fullfile(handles.pathname, 'forcs.png'));
    [~,~,ext] = fileparts(file);
    if ~isequal(file,0) && ~isequal(path,0)
        for n = 1:length(handles.files)
            set(handles.FileListBox, 'Value', n);
            LoadForc(hObject, handles); 
            file = [handles.files{n} ext]; 
            export_fig(handles.ForcFigure, fullfile(path,file), '-m4');
        end
    end
    
    
    
    
    
    
