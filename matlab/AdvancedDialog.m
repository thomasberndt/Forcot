function varargout = AdvancedDialog(varargin)
% ADVANCEDDIALOG MATLAB code for AdvancedDialog.fig
%      ADVANCEDDIALOG, by itself, creates a new ADVANCEDDIALOG or raises the existing
%      singleton*.
%
%      H = ADVANCEDDIALOG returns the handle to a new ADVANCEDDIALOG or the handle to
%      the existing singleton*.
%
%      ADVANCEDDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADVANCEDDIALOG.M with the given input arguments.
%
%      ADVANCEDDIALOG('Property','Value',...) creates a new ADVANCEDDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AdvancedDialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AdvancedDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AdvancedDialog

% Last Modified by GUIDE v2.5 17-Dec-2020 11:40:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AdvancedDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @AdvancedDialog_OutputFcn, ...
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

% --- Executes just before AdvancedDialog is made visible.
function AdvancedDialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AdvancedDialog (see VARARGIN)

% Choose default command line output for AdvancedDialog
handles.output = hObject;
handles.forc = varargin{1};

handles = LoadState(hObject, handles);

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using AdvancedDialog.
if strcmp(get(hObject,'Visible'),'off')
    PlotEverything(hObject, handles);
end

% UIWAIT makes AdvancedDialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AdvancedDialog_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in CoercivityDistribution.
function CoercivityDistribution_Callback(hObject, eventdata, handles)
% hObject    handle to CoercivityDistribution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CoercivityDistribution
    handles.PlotCoercivityDistribution = get(handles.CoercivityDistribution, 'Value');
    SaveState(hObject, handles);


% --- Executes on button press in CoercivityCrosssection.
function CoercivityCrosssection_Callback(hObject, eventdata, handles)
% hObject    handle to CoercivityCrosssection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CoercivityCrosssection
    handles.PlotCoercivityCrosssection = get(handles.CoercivityCrosssection, 'Value');
    SaveState(hObject, handles);



function CoercivityCrosssectionAt_Callback(hObject, eventdata, handles)
% hObject    handle to CoercivityCrosssectionAt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CoercivityCrosssectionAt as text
%        str2double(get(hObject,'String')) returns contents of CoercivityCrosssectionAt as a double
    try
        handles.Hu_cross = str2double(get(handles.CoercivityCrosssectionAt, 'String'))/1000; 
    catch
        handles.Hu_cross = 0;
    end
    SaveState(hObject, handles);
 
% --- Executes during object creation, after setting all properties.
function CoercivityCrosssectionAt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CoercivityCrosssectionAt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function PlotEverything(hObject, handles)
    data = guidata(handles.forc.output);
    axes(handles.axes1);
    rho = data.princeton.forc.rho;
    Ha = data.princeton.forc.Ha; 
    Hb = data.princeton.forc.Hb; 
    Hc = data.princeton.forc.Hc; 
    Hu = data.princeton.forc.Hu; 
    
    hcs = linspace(0, data.princeton.forc.maxHc);
    hus = linspace(-data.princeton.forc.maxHu, data.princeton.forc.maxHu);
    [hc, hu] = meshgrid(hcs, hus);
    if handles.PlotCoercivityDistribution || handles.PlotInteractionDistribution
%         if ~isfield(handles.forc.princeton, 'rhoInterpolant') || isempty(handles.forc.princeton.rhoInterpolant)
            data.princeton.rhoInterpolant = scatteredInterpolant(Hc(:), Hu(:), rho(:));
%             guidata(hObject, handles);
%         end
        r = data.princeton.rhoInterpolant(hc, hu);
        CoercivityDistribution = sum(r, 1);
        CoercivityDistribution = CoercivityDistribution / sum(CoercivityDistribution, 'omitnan');
        InteractionDistribution = sum(r, 2);
        InteractionDistribution = InteractionDistribution / sum(InteractionDistribution, 'omitnan');
    end
    
    if handles.PlotCoercivityDistribution
        n = max(abs(CoercivityDistribution(hcs*1e3>5)))*handles.Normalize + (1-handles.Normalize);
        plot(hcs*1e3, CoercivityDistribution/n, 'DisplayName', ...
            sprintf('H_c (%s)', data.TitleTextBox.String), ...
            'LineWidth', 2);
        hold on
    end
    if handles.PlotCoercivityCrosssection
        [~,x] = min(abs(Hu-handles.Hu_cross));
        ind = sub2ind(size(Hu), x, 1:length(x));
        r = rho(ind);
        n = max(abs(r(Hc(ind)*1e3>5)))*handles.Normalize + (1-handles.Normalize);
        plot(Hc(ind)*1e3, r/n, 'DisplayName', ...
            sprintf('H_c at H_u=%g mT (%s)', ...
            handles.Hu_cross*1e3, ...
            data.TitleTextBox.String), ...
            'LineWidth', 2);
        hold on
    end
    if handles.PlotInteractionDistribution
        n = max(abs(InteractionDistribution))*handles.Normalize + (1-handles.Normalize);
        plot(hus*1e3, InteractionDistribution/n, 'DisplayName', ...
            sprintf('H_u (%s)', data.TitleTextBox.String), ...
            'LineWidth', 2);
        hold on
    end
    if handles.PlotInteractionCrosssection
        [~,x] = min(abs(Hc-handles.Hc_cross));
        ind = sub2ind(size(Hc), x, 1:length(x));
        r = rho(ind);
        n = max(abs(r))*handles.Normalize + (1-handles.Normalize);
        plot(Hu(ind)*1e3, r/n, 'DisplayName', ...
            sprintf('H_u at H_c=%g mT (%s)', ...
            handles.Hc_cross*1e3, ...
            data.TitleTextBox.String), ...
            'LineWidth', 2);
        hold on
    end
    grid on
    xlabel('Field [mT]');
    ylabel('Distribution \rho'); 
    legend('location', 'northeastoutside');
    if handles.PlotInteractionDistribution || handles.PlotInteractionCrosssection
        minH = -handles.forc.princeton.forc.maxHu;
    else
        minH = 0;
    end
    if handles.PlotCoercivityDistribution || handles.PlotCoercivityCrosssection
        maxH = handles.forc.princeton.forc.maxHc;
    else
        maxH = handles.forc.princeton.forc.maxHu;
    end
    xlim([minH maxH]*1e3);



function PlotSizeAndShape(hObject, handles)
    mu0 = pi*4e-7;
    data = guidata(handles.forc.output);
    axes(handles.axes1);
    rho = data.princeton.forc.rho;
    Ha = data.princeton.forc.Ha; 
    Hb = data.princeton.forc.Hb; 
    Hc = data.princeton.forc.Hc; 
    Hu = data.princeton.forc.Hu; 
    if isfield(handles.forc.princeton, 'taforc_Ms')
        Ms = handles.forc.princeton.taforc_Ms;
    else
        Ms = 480e3;
    end
    
    hcs = linspace(0, data.princeton.forc.maxHc);
    hus = linspace(-data.princeton.forc.maxHu, data.princeton.forc.maxHu);

    if handles.PlotCoercivityCrosssection
        [~,x] = min(abs(Hu-handles.Hu_cross));
        ind = sub2ind(size(Hu), x, 1:length(x));
        r = rho(ind);
        V = r.^3;
        N = Hc(ind) / mu0 ./ Ms; 
        q = ShapeAnisotropyInv(N);
        L = real((6/pi * V .* q.^2).^(1/3));
        
        abundance = data.princeton.TS_FORC.forc.rho(ind);
        abundance(isnan(abundance)) = 0;
        abundance(abundance<0) = 0;
        ma = max(abundance); 
        ab = abundance/ma * 150 + 1;
        h = scatter(1./q, L*1e9, ab, ...
            'filled', ...
            'AlphaData', sqrt(abundance/ma), ...
            'MarkerFaceAlpha', 'flat', ...
            'DisplayName', ...
            sprintf('H_c at H_u=%g mT (%s)', ...
            handles.Hu_cross*1e3, ...
            data.TitleTextBox.String), ...
            'LineWidth', 2);
        hold on
    end
    grid on
    xlabel('Axial ratio');
    ylabel('Length [nm]'); 
    legend('location', 'northeastoutside');
    xlim([0.6 1]);
    ylim([0 100]);


function PlotShape(hObject, handles)
    mu0 = pi*4e-7;
    data = guidata(handles.forc.output);
    axes(handles.axes3);
    rho = data.princeton.forc.rho;
    Ha = data.princeton.forc.Ha; 
    Hb = data.princeton.forc.Hb; 
    Hc = data.princeton.forc.Hc; 
    Hu = data.princeton.forc.Hu; 
    if isfield(handles.forc.princeton, 'taforc_Ms')
        Ms = handles.forc.princeton.taforc_Ms;
    else
        Ms = 480e3;
    end
    
    hcs = linspace(0, data.princeton.forc.maxHc);
    hus = linspace(-data.princeton.forc.maxHu, data.princeton.forc.maxHu);

    if handles.PlotCoercivityCrosssection
        [~,x] = min(abs(Hu-handles.Hu_cross));
        ind = sub2ind(size(Hu), x, 1:length(x));
        r = rho(ind);
        V = r.^3;
        N = Hc(ind) / mu0 ./ Ms; 
        q = ShapeAnisotropyInv(N);
        L = real((6/pi * V .* q.^2).^(1/3));
        
        abundance = data.princeton.TS_FORC.forc.rho(ind);
        abundance(isnan(abundance)) = 0;
        abundance(abundance<0) = 0;
        
        [q, id] = sort(q);
        qq = linspace(1, 1/.6, 30);
        abundance = abundance(id);
        
        ma = max(abundance); 
        ab = abundance/ma;
        A = zeros(size(qq));
        for n = 1:length(qq)-1
            A(n) = sum(ab(and(q>qq(n), q<=qq(n+1))), 'omitnan');
        end
        plot(1./qq, A/sum(A),  ...
            'DisplayName', ...
            sprintf('H_c at H_u=%g mT (%s)', ...
            handles.Hu_cross*1e3, ...
            data.TitleTextBox.String), ...
            'LineWidth', 2);
        hold on
    end
    grid on
    xlabel('Axial ratio');
    ylabel('Abundance'); 
%     legend('location', 'northeastoutside');
    xlim([0.6 1]);





function PlotSize(hObject, handles)
    mu0 = pi*4e-7;
    data = guidata(handles.forc.output);
    axes(handles.axes2);
    rho = data.princeton.forc.rho;
    Ha = data.princeton.forc.Ha; 
    Hb = data.princeton.forc.Hb; 
    Hc = data.princeton.forc.Hc; 
    Hu = data.princeton.forc.Hu; 
    if isfield(handles.forc.princeton, 'taforc_Ms')
        Ms = handles.forc.princeton.taforc_Ms;
    else
        Ms = 480e3;
    end
    
    hcs = linspace(0, data.princeton.forc.maxHc);
    hus = linspace(-data.princeton.forc.maxHu, data.princeton.forc.maxHu);

    if handles.PlotCoercivityCrosssection
        [~,x] = min(abs(Hu-handles.Hu_cross));
        ind = sub2ind(size(Hu), x, 1:length(x));
        r = rho(ind);
        V = r.^3;
        N = Hc(ind) / mu0 ./ Ms; 
        q = ShapeAnisotropyInv(N);
        L = real((6/pi * V .* q.^2).^(1/3));
                
        abundance = data.princeton.TS_FORC.forc.rho(ind);
        abundance(isnan(abundance)) = 0;
        abundance(abundance<0) = 0;
        
        [L, id] = sort(L);
        LL = linspace(0, 100e-9, 40);
        abundance = abundance(id);
        
        ma = max(abundance); 
        ab = abundance/ma;
        A = zeros(size(LL));
        for n = 1:length(LL)-1
            A(n) = sum(ab(and(L>LL(n), L<=LL(n+1))), 'omitnan');
        end
        plot(LL*1e9, A/ sum(A),  ...
            'DisplayName', ...
            sprintf('H_c at H_u=%g mT (%s)', ...
            handles.Hu_cross*1e3, ...
            data.TitleTextBox.String), ...
            'LineWidth', 2);
        hold on
    end
    grid on
    xlabel('Length [nm]');
    ylabel('Abundance'); 
%     legend('location', 'northeastoutside');
    xlim([0 100]);


% --- Executes during object creation, after setting all properties.
function InteractionCrosssectionAt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InteractionCrosssectionAt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in InteractionDistribution.
function InteractionDistribution_Callback(hObject, eventdata, handles)
% hObject    handle to InteractionDistribution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of InteractionDistribution
    handles.PlotInteractionDistribution = get(handles.InteractionDistribution, 'Value');
    SaveState(hObject, handles);

% --- Executes on button press in InteractionCrosssection.
function InteractionCrosssection_Callback(hObject, eventdata, handles)
% hObject    handle to InteractionCrosssection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of InteractionCrosssection
    handles.PlotInteractionCrosssection = get(handles.InteractionCrosssection, 'Value');
    SaveState(hObject, handles);


function InteractionCrosssectionAt_Callback(hObject, eventdata, handles)
% hObject    handle to InteractionCrosssectionAt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InteractionCrosssectionAt as text
%        str2double(get(hObject,'String')) returns contents of InteractionCrosssectionAt as a double
    try
        handles.Hc_cross = str2double(get(handles.InteractionCrosssectionAt, 'String'))/1000; 
    catch
        handles.Hc_cross = 0;
    end
    SaveState(hObject, handles);


% --- Executes on button press in NormalizeCheckbox.
function NormalizeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to NormalizeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NormalizeCheckbox
    handles.Normalize = get(handles.NormalizeCheckbox, 'Value');
    SaveState(hObject, handles);
    PlotEverything(hObject, handles);
    
    
    
function SaveState(hObject, handles)
    stufftosave = struct(); 
    stufftosave.Hu_cross = handles.Hu_cross; 
    stufftosave.PlotCoercivityCrosssection = handles.PlotCoercivityCrosssection;
    stufftosave.Hc_cross = handles.Hc_cross; 
    stufftosave.PlotInteractionCrosssection = handles.PlotInteractionCrosssection; 
    stufftosave.PlotCoercivityDistribution = handles.PlotCoercivityDistribution; 
    stufftosave.PlotInteractionDistribution = handles.PlotInteractionDistribution; 
    stufftosave.Normalize = handles.Normalize;
    try
        save(fullfile(tempdir, 'Forcot_advancedsettings.mat'), 'stufftosave'); 
    catch
    end
    guidata(hObject, handles);
    

function handles = LoadState(hObject, handles)
    handles.Hu_cross = 0; 
    handles.PlotCoercivityCrosssection = 1;
    handles.Hc_cross = 10/1e3; 
    handles.PlotInteractionCrosssection = 1; 
    handles.PlotCoercivityDistribution = 0; 
    handles.PlotInteractionDistribution = 0; 
    handles.Normalize = 1;
    try
        stufftoload = load(fullfile(tempdir, 'Forcot_advancedsettings.mat')); 
        stufftoload = stufftoload.stufftosave; 
        if isfield(stufftoload, 'Hu_cross')
            handles.Hu_cross = stufftoload.Hu_cross;
        end
        if isfield(stufftoload, 'PlotCoercivityCrosssection')
            handles.PlotCoercivityCrosssection = stufftoload.PlotCoercivityCrosssection;
        end
        if isfield(stufftoload, 'Hc_cross')
            handles.Hc_cross = stufftoload.Hc_cross;
        end
        if isfield(stufftoload, 'PlotInteractionCrosssection')
            handles.PlotInteractionCrosssection = stufftoload.PlotInteractionCrosssection;
        end
        if isfield(stufftoload, 'PlotCoercivityDistribution')
            handles.PlotCoercivityDistribution = stufftoload.PlotCoercivityDistribution;
        end
        if isfield(stufftoload, 'PlotInteractionDistribution')
            handles.PlotInteractionDistribution = stufftoload.PlotInteractionDistribution;
        end
        if isfield(stufftoload, 'Normalize')
            handles.Normalize = stufftoload.Normalize;
        end
    catch
    end

    set(handles.CoercivityCrosssectionAt, 'String', num2str(handles.Hu_cross*1e3)); 
    set(handles.CoercivityCrosssection, 'Value', handles.PlotCoercivityCrosssection); 
    set(handles.CoercivityDistribution, 'Value', handles.PlotCoercivityDistribution); 
    set(handles.InteractionCrosssectionAt, 'String', num2str(handles.Hc_cross*1e3)); 
    set(handles.InteractionCrosssection, 'Value', handles.PlotInteractionCrosssection); 
    set(handles.InteractionDistribution, 'Value', handles.PlotInteractionDistribution); 
    set(handles.NormalizeCheckbox, 'Value', handles.Normalize);
    
    


% --- Executes on button press in SaveFigure.
function SaveFigure_Callback(hObject, eventdata, handles)
% hObject    handle to SaveFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [defaultpath,name,ext] = fileparts(handles.forc.filename);
    defaultext = '.png'; 
    
    if isfield(handles.forc, 'FigurePath') 
        if ~isempty(handles.forc.FigurePath) && exist(handles.forc.FigurePath, 'dir')
            defaultpath = handles.forc.FigurePath;
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
    filepath = fullfile(path,file);
    [~,~,ext] = fileparts(file);
    export_fig(handles.axes1, filepath);
    
    
    

% --- Executes on button press in ExportCsv.
function ExportCsv_Callback(hObject, eventdata, handles)
% hObject    handle to ExportCsv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [defaultpath,name,ext] = fileparts(handles.forc.filename);
    defaultext = '.csv'; 
    
    if isfield(handles.forc, 'FigurePath') 
        if ~isempty(handles.forc.FigurePath) && exist(handles.forc.FigurePath, 'dir')
            defaultpath = handles.forc.FigurePath;
        end
    end
    filetypes = {...
            '*.csv', 'Comma-separated file (*.csv)'; ...
            '*.txt', 'Text file (*.txt)'};
    
    default_idx = strcmpi(filetypes(:,1), ['*' defaultext]); 
    filetypes = vertcat(filetypes(default_idx,:), filetypes(~default_idx,:)); 
    
    [file,path,~] = uiputfile(filetypes, 'File Selection', ...
            fullfile(defaultpath, [name defaultext]));
    file = replace(file, '_Coercivity_distribution.', '.'); 
    file = replace(file, '_Interaction_distribution.', '.'); 
    file = replace(file, '_Coercivity_crosssection.', '.'); 
    file = replace(file, '_Interaction_crosssection.', '.'); 
    [~,file,ext] = fileparts(file);
    filepath = fullfile(path,file);
        
    rho = handles.forc.princeton.forc.rho;
    Hc = handles.forc.princeton.forc.Hc; 
    Hu = handles.forc.princeton.forc.Hu; 
    
    hcs = linspace(0, handles.forc.princeton.forc.maxHc);
    hus = linspace(-handles.forc.princeton.forc.maxHu, handles.forc.princeton.forc.maxHu);
    [hc, hu] = meshgrid(hcs, hus);
    if handles.PlotCoercivityDistribution || handles.PlotInteractionDistribution
        r = handles.forc.princeton.rhoInterpolant(hc, hu);
        CoercivityDistribution = sum(r, 1);
        CoercivityDistribution = CoercivityDistribution / sum(CoercivityDistribution, 'omitnan');
        InteractionDistribution = sum(r, 2);
        InteractionDistribution = InteractionDistribution / sum(InteractionDistribution, 'omitnan');
    end
    
    if handles.PlotCoercivityDistribution
        f = fopen(sprintf('%s_Coercivity_distribution%s', filepath, ext), 'w+'); 
        fprintf(f, 'H_c [T], Coercivity distribution\n');
        fprintf(f, '%g,%g\n', [hcs; CoercivityDistribution]);
        fclose(f);
    end
    if handles.PlotInteractionDistribution
        f = fopen(sprintf('%s_Interaction_distribution%s', filepath, ext), 'w+'); 
        fprintf(f, 'H_u [T], Interaction field distribution\n');
        fprintf(f, '%g,%g\n', [hus; InteractionDistribution']);
        fclose(f);
    end
    if handles.PlotCoercivityCrosssection
        [~,x] = min(abs(Hu-handles.Hu_cross));
        ind = sub2ind(size(Hu), x, 1:length(x));
        ind(isnan(rho(ind))) = [];
        f = fopen(sprintf('%s_Coercivity_crosssection%s', filepath, ext), 'w+'); 
        fprintf(f, 'H_c [T], Coercivity crosssection at H_u=%g T\n', handles.Hu_cross);
        fprintf(f, '%g,%g\n', [Hc(ind); rho(ind)]);
        fclose(f);
    end
    if handles.PlotInteractionCrosssection
        [~,x] = min(abs(Hc-handles.Hc_cross));
        ind = sub2ind(size(Hc), x, 1:length(x));
        ind(isnan(rho(ind))) = [];
        f = fopen(sprintf('%s_Interaction_crosssection%s', filepath, ext), 'w+'); 
        fprintf(f, 'H_u [T], Interaction crosssection at H_c=%g T\n', handles.Hc_cross);
        fprintf(f, '%g,%g\n', [Hu(ind); rho(ind)]);
        fclose(f);
    end


% --- Executes on button press in PlotButton.
function PlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    PlotEverything(hObject, handles);


% --- Executes on button press in AddToPlots.
function AddToPlots_Callback(hObject, eventdata, handles)
% hObject    handle to AddToPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AddToPlots



function YFrom_Callback(hObject, eventdata, handles)
% hObject    handle to YFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YFrom as text
%        str2double(get(hObject,'String')) returns contents of YFrom as a double
    axes(handles.axes1);
    try
        ylim([str2double(handles.YFrom.String) str2double(handles.YTo.String)])
    catch
    end

% --- Executes during object creation, after setting all properties.
function YFrom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YTo_Callback(hObject, eventdata, handles)
% hObject    handle to YTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YTo as text
%        str2double(get(hObject,'String')) returns contents of YTo as a double
    axes(handles.axes1);
    try
        ylim([str2double(handles.YFrom.String) str2double(handles.YTo.String)])
    catch
    end

% --- Executes during object creation, after setting all properties.
function YTo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClearPlotButton.
function ClearPlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearPlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    data = guidata(handles.forc.output);
    axes(handles.axes1);
    cla;
    axes(handles.axes2);
    cla;
    axes(handles.axes3);
    cla;



function XFrom_Callback(hObject, eventdata, handles)
% hObject    handle to XFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XFrom as text
%        str2double(get(hObject,'String')) returns contents of XFrom as a double
    axes(handles.axes1);
    try
        xlim([str2double(handles.XFrom.String) str2double(handles.XTo.String)])
    catch
    end

% --- Executes during object creation, after setting all properties.
function XFrom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function XTo_Callback(hObject, eventdata, handles)
% hObject    handle to XTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XTo as text
%        str2double(get(hObject,'String')) returns contents of XTo as a double
    axes(handles.axes1);
    try
        xlim([str2double(handles.XFrom.String) str2double(handles.XTo.String)])
    catch
    end

% --- Executes during object creation, after setting all properties.
function XTo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PushPlotSizeShape.
function PushPlotSizeShape_Callback(hObject, eventdata, handles)
% hObject    handle to PushPlotSizeShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    PlotSizeAndShape(hObject, handles);
    PlotSize(hObject, handles);
    PlotShape(hObject, handles);


    
