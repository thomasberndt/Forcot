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

% Last Modified by GUIDE v2.5 12-Mar-2019 09:00:48

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
set(handles.ForcFigure, 'SizeChangedFcn', {@resizeForcFigure, handles.output}); 
set(handles.ForcFigure, 'Name', 'Forcot'); 
set(handles.ForcFigure, 'NumberTitle', 'off'); 

pos = hObject.OuterPosition; 

myunits = get(hObject, 'Units');  
hObject.OuterPosition = [10 10 pos(3) pos(4)]; 
set(hObject, 'Units', 'pixels'); 
pos = hObject.OuterPosition; 
set(hObject, 'Units', myunits); 
handles.ForcFigure.OuterPosition = [pos(1)+pos(3) pos(2) pos(4) pos(4)]; 
handles.ForcAxes = axes;

set(handles.ForcFigure, 'Color', 'w');
handles = LoadState(hObject, handles);
TightAxis(handles); 

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
drawnow;
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
handles = SaveFigure(hObject,handles); 
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
        handles.princeton.forc.maxHu = handles.princeton.forc.maxHu * .9; 
        set(handles.Hu_TextBox, 'String', num2str(round(handles.princeton.forc.maxHu*1000)));
        set(handles.Hc_TextBox, 'String', num2str(round(handles.princeton.forc.maxHc*1000)));
        DeleteThing(handles.MessageText);
        GuiPlotForc(handles);  
        TightAxis(handles);
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
    DeleteThing(handles.SendDiagnosticDataButton);
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
        stufftoload = load(fullfile(tempdir, 'Forcot_programsettings.mat')); 
        stufftoload = stufftoload.stufftosave; 
        if isfield(stufftoload, 'PlotFirstPointArtifact')
            handles.PlotFirstPointArtifact = stufftoload.PlotFirstPointArtifact;
        else
            handles.PlotFirstPointArtifact = 0;
        end
        set(handles.CheckFirstPointArtifact, 'value', handles.PlotFirstPointArtifact);
        if isfield(stufftoload, 'FigurePath')
            handles.FigurePath = stufftoload.FigurePath;
        end
        if isfield(stufftoload, 'FigureExt')
            handles.FigureExt = stufftoload.FigureExt;
        end
        if isfield(stufftoload, 'ColorScheme')
            handles.ColorScheme = stufftoload.ColorScheme;
            if strcmpi(handles.ColorScheme, 'redyellowblue')
                set(handles.ColorSchemeDropdown, 'Value', 1);
            elseif strcmpi(handles.ColorScheme, 'redblue')
                set(handles.ColorSchemeDropdown, 'Value', 2);
            end
        end
        if isfield(stufftoload, 'filename')
            handles.filename = stufftoload.filename; 
            [handles.pathname, name, handles.ext] = fileparts(handles.filename);
            files = dir(fullfile(handles.pathname, sprintf('*%s', handles.ext))); 
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
    if isfield(handles, 'PlotFirstPointArtifact')
        stufftosave.PlotFirstPointArtifact = handles.PlotFirstPointArtifact; 
    end
    if isfield(handles, 'FigurePath')
        stufftosave.FigurePath = handles.FigurePath; 
    end
    if isfield(handles, 'FigureExt')
        stufftosave.FigureExt = handles.FigureExt; 
    end
    if isfield(handles, 'ColorScheme')
        stufftosave.ColorScheme = handles.ColorScheme; 
    end
    guidata(hObject,handles);
    try
        save(fullfile(tempdir, 'Forcot_programsettings.mat'), 'stufftosave'); 
    catch
    end

function GuiPlotForc(handles)
    if ~isfield(handles, 'PlotFirstPointArtifact')
        handles.PlotFirstPointArtifact = 1;
    end
    if ~isfield(handles, 'ColorScheme')
        handles.ColorScheme = 'redyellowblue';
    end
    handles.princeton.forc.PlotFirstPointArtifact = handles.PlotFirstPointArtifact;
    handles.princeton.forc.ColorScheme = handles.ColorScheme;
    axes(handles.ForcAxes); 
    [~,name] = fileparts(handles.princeton.filename);
    forc = handles.princeton.forc;
    PlotFORC(forc);
    title(sprintf('%s', name));
    drawnow;
    
function TightAxis(handles)
    myunits = get(handles.ForcAxes, 'Units');  
    set(handles.ForcAxes, 'Units', 'pixels'); 
    ti = handles.ForcAxes.TightInset; 
    width = handles.ForcFigure.Position(3);
    height = handles.ForcFigure.Position(4);
    handles.ForcAxes.Position = [...
        ti(1) ...
        ti(2) ...
        width-ti(3)-ti(1)-75 ....
        height-ti(4)-ti(2)]; 
    set(handles.ForcAxes, 'Units', myunits); 
    
function resizeForcFigure(hObject, event, mainfig)
    handles = guidata(mainfig);
    if isfield(handles, 'ForcAxes')
        TightAxis(handles); 
    end


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
    
function handles = SaveFigure(hObject, handles)

    [defaultpath,name,ext] = fileparts(handles.filename);
    defaultext = '.png'; 
    
    if isfield(handles, 'FigurePath') 
        if ~isempty(handles.FigurePath) && exist(handles.FigurePath, 'dir')
            defaultpath = handles.FigurePath;
        end
    end
    if isfield(handles, 'FigureExt') 
        if ~isempty(handles.FigureExt)
            defaultext = handles.FigureExt;
        end
    end
    filetypes = {...
            '*.png', 'Portable Network Graphics file (*.png)'; ...
            '*.pdf', 'Portable Document Format (*.pdf)'; ...
            '*.eps', 'EPS file (*.eps)'; ...
            '*.jpg', 'JPEG image (*.jpg)'; ...
            '*.tif', 'TIFF image (*.tif)'; ...
            '*.bmp', 'Bitmap file (*.bmp)'; ...
            '*.fig', 'MATLAB Figure (*.fig)'};
    
    default_idx = strcmpi(filetypes(:,1), ['*' defaultext]); 
    filetypes = vertcat(filetypes(default_idx,:), filetypes(~default_idx,:)); 
    
    [file,path,~] = uiputfile(filetypes, 'File Selection', ...
            fullfile(defaultpath, [name defaultext]));
    
    if ~isequal(file,0) && ~isequal(path,0)
        [~,~,ext] = fileparts(file);
        filepath = fullfile(path,file);
        handles.FigurePath = path;
        handles.FigureExt = ext; 
        SaveState(hObject, handles);
        SaveOneFigure(handles, filepath, ext);
    end
    
function SaveOneFigure(handles, filepath, ext)
    handles.ForcFigure.PaperPositionMode = 'auto'; 
    handles.ForcFigure.PaperUnits = 'centimeters'; 
    p = handles.ForcFigure.Position; 
    siz = [p(3) p(4)]; 
    ratio = siz(2) / siz(1); 
    handles.ForcFigure.PaperSize = 21*[1 ratio]; 
    if strcmpi(ext, '.pdf')
        print(handles.ForcFigure, ...
             filepath, '-dpdf','-r0', '-bestfit');
    elseif strcmpi(ext, '.png')
        print(handles.ForcFigure, ...
             filepath, '-dpng','-r300');
    elseif strcmpi(ext, '.eps')
        print(handles.ForcFigure, ...
             filepath, '-depsc','-r300');
    elseif strcmpi(ext, '.jpg')
        print(handles.ForcFigure, ...
             filepath, '-djpeg','-r300');
    elseif strcmpi(ext, '.svg')
        print(handles.ForcFigure, ...
             filepath, '-dsvg','-r0');
    elseif strcmpi(ext, '.tif')
        print(handles.ForcFigure, ...
             filepath, '-dtiff','-r300');
    elseif strcmpi(ext, '.bmp')
        print(handles.ForcFigure, ...
             filepath, '-dbmp','-r0');
    elseif strcmpi(ext, '.fig')
        savefig(handles.ForcFigure, filepath);
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
            SaveState(hObject, handles);
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
    axis(handles.ForcAxes, [0 handles.princeton.forc.maxHc*1000 ...
        -handles.princeton.forc.maxHu*1000 handles.princeton.forc.maxHu*1000]); 

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
    [defaultpath,name,ext] = fileparts(handles.filename);
    defaultext = '.png'; 
    
    if isfield(handles, 'FigurePath') 
        if ~isempty(handles.FigurePath) && exist(handles.FigurePath, 'dir')
            defaultpath = handles.FigurePath;
        end
    end
    if isfield(handles, 'FigureExt') 
        if ~isempty(handles.FigureExt)
            defaultext = handles.FigureExt;
        end
    end
    filetypes = {...
            '*.png', 'Portable Network Graphics file (*.png)'; ...
            '*.pdf', 'Portable Document Format (*.pdf)'; ...
            '*.eps', 'EPS file (*.eps)'; ...
            '*.jpg', 'JPEG image (*.jpg)'; ...
            '*.tif', 'TIFF image (*.tif)'; ...
            '*.bmp', 'Bitmap file (*.bmp)'; ...
            '*.fig', 'MATLAB Figure (*.fig)'};
    
    default_idx = strcmpi(filetypes(:,1), ['*' defaultext]); 
    filetypes = vertcat(filetypes(default_idx,:), filetypes(~default_idx,:)); 
    
    [file,path,~] = uiputfile(filetypes, 'File Selection', ...
            fullfile(defaultpath, [name defaultext]));
    
    if ~isequal(file,0) && ~isequal(path,0)
        [~,~,ext] = fileparts(file);
        handles.FigurePath = path;
        handles.FigureExt = ext; 
        SaveState(hObject, handles);
        
        for n = 1:length(handles.files)
            set(handles.FileListBox, 'Value', n);
            handles = LoadForc(hObject, handles); 
            file = [handles.files{n} ext]; 
            filepath = fullfile(path,file);
            SaveOneFigure(handles, filepath, ext);
        end
    end

  
    
    
    
    


% --- Executes on button press in CheckFirstPointArtifact.
function CheckFirstPointArtifact_Callback(hObject, eventdata, handles)
% hObject    handle to CheckFirstPointArtifact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckFirstPointArtifact
    handles.PlotFirstPointArtifact = get(hObject,'Value'); 
    try
        SaveState(hObject,handles); 
        GuiPlotForc(handles);        
    catch ME
        axes(handles.ForcAxes); 
        text(0.1, 0.5 ,ME.message);
    end



% --- Executes on selection change in ColorSchemeDropdown.
function ColorSchemeDropdown_Callback(hObject, eventdata, handles)
% hObject    handle to ColorSchemeDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ColorSchemeDropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ColorSchemeDropdown
    idx = get(hObject, 'Value');
    if idx == 1
        handles.ColorScheme = 'redyellowblue';
    elseif idx == 2
        handles.ColorScheme = 'redblue'; 
    end
    GuiPlotForc(handles);       
    SaveState(hObject,handles); 
    



% --- Executes during object creation, after setting all properties.
function ColorSchemeDropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ColorSchemeDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
