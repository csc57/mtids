function varargout = import_dynamic_params(varargin)
% IMPORT_DYNAMIC_PARAMS MATLAB code for import_dynamic_params.fig
%      IMPORT_DYNAMIC_PARAMS, by itself, creates a new IMPORT_DYNAMIC_PARAMS or raises the existing
%      singleton*.
%
%      H = IMPORT_DYNAMIC_PARAMS returns the handle to a new IMPORT_DYNAMIC_PARAMS or the handle to
%      the existing singleton*.
%
%      IMPORT_DYNAMIC_PARAMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMPORT_DYNAMIC_PARAMS.M with the given input arguments.
%
%      IMPORT_DYNAMIC_PARAMS('Property','Value',...) creates a new IMPORT_DYNAMIC_PARAMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before import_dynamic_params_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to import_dynamic_params_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help import_dynamic_params

% Last Modified by GUIDE v2.5 31-May-2012 12:57:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @import_dynamic_params_OpeningFcn, ...
                   'gui_OutputFcn',  @import_dynamic_params_OutputFcn, ...
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


% --- Executes just before import_dynamic_params is made visible.
function import_dynamic_params_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to import_dynamic_params (see VARARGIN)

%% Callback Functions

% Choose default command line output for import_dynamic_params
handles.output = hObject;

listBlks = varargin{1};
listnms = varargin{2};
filename = varargin{3};
m=regexp( filename, '\.', 'split','once');
handles.sysname = m{1};

%% Geometry
screenSize = get( 0, 'ScreenSize' );
topFrame = 30;
bottomFrame = 0.5*topFrame;
sideFrame = 0.5*topFrame;

nrBlks = length(listBlks);

topGap = 1/12*screenSize(4);
left = screenSize(3)*0.1;
height = get_figureHeight ( nrBlks );

if screenSize(3)*0.9 > 760
    width = 760;
else
    width = screenSize(3)*0.85;
end

bottom = screenSize(4) - topGap - height;
posVector = [left bottom width height]; %do this dynamically % [left, bottom, width, height]


%% Creating Figure

% creatint elements
handles.uipanel1 = uipanel;
handles.t = uitable;
% handles.textBlockType = uicontrol;

% setting figure parameters manually
defaultBackground = get(0,'defaultUicontrolBackgroundColor');
set(hObject,'Position',posVector,'Name','Import Dynamic Wizard','Toolbar','none',...
    'MenuBar','none','Resize','on','ResizeFcn',{@figResize,handles},'Color',...
    defaultBackground,'Units','pixels');%,'CloseRequestFcn',{@figure1_CloseRequestFcn,handles});


%% Filling the data cells
dat = cell(length(listBlks),3);
dat(:,1) = listnms;
for i = 1:length(listBlks)
    % if there are well known block types here, we can provide some
    % initialisation of the table. If not, declare parameters names
    % otherwise
    switch listBlks{i}
        case 'Gain';
            % check out the model explorer to get the correct parameter
            % names
            paramname = {'Gain'};
            % read it out of the imported system
            paramvalue = {get_param([handles.sysname '/' listnms{i}],paramname{1})};
        case 'Integrator';
            paramname = {'InitialCondition'};
            paramvalue = {get_param([handles.sysname '/' listnms{i}],paramname{1})};
        case 'Constant';
            paramname = {'Value'};
            paramvalue = {get_param([handles.sysname '/' listnms{i}],paramname{1})};
        case 'StateSpace';
            paramname = {'A';'B';'C';'D';'X0'};
            paramvalue = cell( length(paramname) , 1);
            for j = 1:length(paramname)
                paramvalue{j} = get_param([handles.sysname '/' listnms{i}],paramname{j});
            end
        otherwise;
            paramname = {''};
%                 paramname = get_param([handles.sysname '/' listnms{i}],'DialogParameters')
            paramvalue = {''};
    end

    for j = 1:length(paramname)
        dat{i,2*j} = paramname{j};
        dat{i,1+2*j} = paramvalue{j};
    end
end

%% Set Column names and "edit cell" properties
cnames = cell( size(dat,2) , 1 );
cnames{1} = 'Block Name';
columneditable = logical( zeros(1, size(dat,2) ));
for i = 1:floor( size(dat,2) / 2)
    cnames{2*i} = 'Parameter Name';
    cnames{2*i + 1} = 'Value';
    columneditable(2*i) = false;
    columneditable(2*i + 1) = true;
end
columnformat = repmat( {'char'}, 1,size(dat,2) );

%% Column and cell format computations
% width of table should be adapted on content or column cells
% idea: compute number of symbols which are spread horizontally
heightTable = 1.25*sizeChar2Pixel(hObject, 'h', ( nrBlks + 2 ) );
[ widthTable columnwidth] = get_tableColumnWidth(hObject,listBlks,dat,cnames);
widthFigure = widthTable + 140;

%% Prepare table position properties
posVecTable = [1.5*sideFrame 5*bottomFrame widthTable heightTable]; % [left, bottom, width, height]
if widthFigure > screenSize(3)
    widthFigure = screenSize(3);
    posVector(1) = 0;
end

%% Creating Figure Content
posVector(3) = widthFigure;
set(hObject,'Position',posVector);

% parameters for panel, in which all other control elements are positioned
posVectorPanel = get_panelPosition(widthTable, height);
% posVectorPanel = [sideFrame bottomFrame width-2*sideFrame height-topFrame]; % [left, bottom, width, height]

set(handles.uipanel1,'Parent',hObject,'Title','Collecting model parameters',...
        'Units','pixel','Position',posVectorPanel);

set(handles.t,'Units','pixel');
set(handles.t,'RowName',listBlks,'ColumnName',cnames,'Position',posVecTable,...
    'ColumnWidth',columnwidth,'Data',dat, 'ColumnEditable', columneditable,...
    'BackgroundColor',[1 1 1],'ColumnFormat',columnformat);

% parameters for pushbuttons
horPosPushbutton1 = 0.15*widthFigure;
posVectorSubmitButton = [horPosPushbutton1 1.7*bottomFrame 140 35];
set(handles.pushbutton1,'Units','pixels','Position',posVectorSubmitButton,...
    'String','Add Block');

horPosPushbutton2 = 0.55*widthFigure;
posVectorCancelButton = [horPosPushbutton2 1.7*bottomFrame 140 35];
set(handles.pushbutton2,'Units','pixels','String','Cancel Import',...
                'Position',posVectorCancelButton);

% handles.handles.textBlockType = uicontrol('Style','text','FontWeight','demi','FontSize',10,...
%     'Position',[45 height-1.725*topFrame 100 18],... % [left, bottom, width, height]
%     'String','Block Type');
            
% "Dirty": Prompt Block Type above the row names
% set(handles.textBlockType,'Style','text','FontWeight','demi','FontSize',10,...
%     'Position',[45 height-1.725*topFrame 100 18],... % [left, bottom, width, height]
%     'String','Block Type');
% uistack(handles.textBlockType,'top');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes import_dynamic_params wait for user response (see UIRESUME)
%     uiwait(handles.figure1); 




% --- Outputs from this function are returned to the command line.
function varargout = import_dynamic_params_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% determine length of row labeling vector
nrOfRows = length( get(handles.t,'RowName') );

% ask for new row (=block) name
newRowName = inputdlg({'New Block Type: '},'Add Row',1);
% check if block type exists before adding the row to the table
if isempty(find_system(handles.sysname,'BlockType',newRowName{1}));
    errordlg(['No Block of Type ',newRowName,' found!']);
    return;
end

% Data processing to row names and table data
rownames = cell(nrOfRows+1,1);
rownames(1:nrOfRows) = get(handles.t,'RowName');
rownames(end) = newRowName;
testCell=find_system(handles.sysname,'BlockType',newRowName{1});
s=regexp(testCell,'/','split');
listOutString = cell(size(s,1),1);
for i = 1:size(s,1)
    listOutString{i} = s{i}{2};
end
listsize = [1.2*sizeChar2Pixel(hObject,'w', 3+max(cellfun(@length,listOutString))) ...
    1.2*sizeChar2Pixel(hObject,'h',size(listOutString,1)+1 )];
newBlockNameIndex = listdlg('PromptString','Select a Block Name:',...
    'SelectionMode','single','ListSize',listsize,...
    'ListString',listOutString);
dataOld=get(handles.t,'Data');
dataNew = cell( size(dataOld,1)+1, size(dataOld,2) );
dataNew(1:end-1,:) = dataOld;
dataNew(end,1) = listOutString(newBlockNameIndex);
dataNew(end,2) = {'UNNAMED'};
dataNew(end,3) = {'UNNAMED'};

heightTableNew = 1.25*sizeChar2Pixel(handles.figure1, 'h', ( size(dataNew,1) + 2 ) );
positionTable = get(handles.t,'Position');
positionTableNew = positionTable;
positionTableNew(4) = heightTableNew;

% Computing new positions
% GUI soll nicht nach oben "raus wachsen"
% newObjectPositions( positionTableNew,handles,eventdata );
positionTable = get(handles.t,'Position');
positionPanel = get(handles.uipanel1, 'Position');
positionFigure = get(handles.figure1, 'Position');

OffsetPanelTable = positionPanel(4) - positionTable(4);
OffsetFigureTable = positionFigure(4) - positionTable(4);


heigthPanelNew = heightTableNew + OffsetPanelTable;
heigthFigureNew = heightTableNew + OffsetFigureTable;


positionPanelNew = positionPanel;
positionFigureNew = positionFigure;


positionPanelNew(4) = heigthPanelNew;
positionFigureNew(4) = heigthFigureNew;

set(handles.t,'RowName',rownames,'Data',dataNew,...
    'Position',positionTableNew);
set(handles.uipanel1,'Position',positionPanelNew);
set(handles.figure1,'Position',positionFigureNew);

figResize(handles.figure1,eventdata,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
handles.OutputFlag = 1;
guidata(hObject, handles);
%     uiresume(handles.figure1);
delete(hObject);


% Figure resize function
function figResize(src,evt,handles)
     topFrame = 30;
     fpos = get(src,'Position');
     fposPanel = get(handles.uipanel1,'Position');
     fposTable = get(handles.t,'Position');
     set(handles.uipanel1,'Position',...
      [fposPanel(1) fposPanel(2) fpos(3)-27 fpos(4)-20]);
     bottomTable = fpos(4) - fposTable(4) - topFrame;
     set(handles.t,'Position',...
         [fposTable(1) bottomTable fpos(3)-45 fposTable(4) ]);
     fposPushbutton1 = get(handles.pushbutton1,'Position');
     fposPushbutton2 = get(handles.pushbutton2,'Position');
     set(handles.pushbutton1,'Position',...
         [0.15*fpos(3) fposPushbutton1(2) fposPushbutton1(3) fposPushbutton1(4)]);
     set(handles.pushbutton2,'Position',...
         [0.55*fpos(3) fposPushbutton2(2) fposPushbutton2(3) fposPushbutton2(4)]);
%      posTextBlockTypeOld = get(handles.textBlockType,'Position');
%      figureFrames = get_figureFrames();
%      posTextBlockTypeNew = [posTextBlockTypeOld(1) ...
%          fpos(4)-1.725*figureFrames.top ...
%          posTextBlockTypeOld(3) ...
%          posTextBlockTypeOld(4)];
%      set(handles.textBlockType,'Position',posTextBlockTypeNew);

     
function [ tableColumnWidth columnwidth ] = get_tableColumnWidth(hObject,listBlks,dat,cnames)
charCounter = 0;
columnwidth = cell( 1 ,size(dat,2) );
for ii = 1: size(dat,2)
    % get max length of a single column in table data
    [val IDX] = max(cellfun(@length,dat(:,ii)));
    % compare max length with column name and take maximum of it
    if cellfun(@length,cnames(ii)) > val
        % column name IS longer
        charCounter = charCounter + cellfun(@length,cnames(ii));
        columnwidth{ii} = 1.4*sizeChar2Pixel(hObject, 'w', cnames{ii} );
    else
        % longest name is within the table data
        charCounter = charCounter + val;
        columnwidth{ii} = 1.2*sizeChar2Pixel(hObject, 'w', dat{IDX,ii} );
    end
end
tableColumnWidth = sizeChar2Pixel(hObject, 'w', max(cellfun(@length,listBlks )) )...
    + sum(cell2mat(columnwidth));

function newObjectPositions( positionTableNew,handles,eventdata )
% Compute and set new layout positions for the figure
positionTable = get(handles.t,'Position');
positionPanel = get(handles.uipanel1, 'Position');
positionFigure = get(handles.figure1, 'Position');

OffsetPanelTable = positionPanel(4) - positionTable(4);
OffsetFigureTable = positionFigure(4) - positionTable(4);

heigthPanelNew = positionTableNew(4) + OffsetPanelTable;
heigthFigureNew = positionTableNew(4) + OffsetFigureTable;

positionPanelNew = positionPanel;
positionFigureNew = positionFigure;

positionPanelNew(4) = heigthPanelNew;
positionFigureNew(4) = heigthFigureNew;

set(handles.t,'RowName',rownames,'Data',dataNew,...
    'Position',positionTableNew);
set(handles.uipanel1,'Position',positionPanelNew);
set(handles.figure1,'Position',positionFigureNew);

figResize(handles.figure1,eventdata,handles);

%%%%%ENDOFSCRIPT%%%%%%%%%%%

