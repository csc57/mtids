function figResize(src,evt,handles) %#ok<INUSL>
%FIGRESIZE figure resize function for pp2.fig
%
% This function works as a resize function for the figure pp2.fig.
%
% INPUT:    src      -- Handles to invoking function
%           evt      -- (unused)
%           handles  -- Struct with handles of parent figure
%
% OUTPUT: (none)     -- Position elements are set directly
%
% Author: Ferdinand Trommsdorff (f.trommsdorff@gmail.com)
% Project: MTIDS (http://code.google.com/p/mtids/)

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
fposPushbutton3 = get(handles.pushbutton3,'Position');
fposPushbutton4 = get(handles.pushbutton4,'Position');
fposPushbutton5 = get(handles.pushbutton5,'Position');
fposPushbutton6 = get(handles.pushbutton6,'Position');
set(handles.pushbutton1,'Position',...
    [0.1*fpos(3) fposPushbutton1(2) fposPushbutton1(3) fposPushbutton1(4)]);
set(handles.pushbutton2,'Position',...
    [0.1*fpos(3) fposPushbutton2(2) fposPushbutton2(3) fposPushbutton2(4)]);
set(handles.pushbutton3,'Position',...
    [0.4*fpos(3) fposPushbutton3(2) fposPushbutton3(3) fposPushbutton3(4)]);
set(handles.pushbutton4,'Position',...
    [0.4*fpos(3) fposPushbutton4(2) fposPushbutton4(3) fposPushbutton4(4)]);
set(handles.pushbutton5,'Position',...
    [0.7*fpos(3) fposPushbutton5(2) fposPushbutton5(3) fposPushbutton5(4)]);
set(handles.pushbutton6,'Position',...
    [0.7*fpos(3) fposPushbutton6(2) fposPushbutton6(3) fposPushbutton6(4)]);
fposPanelTextInputSpecs = get(handles.PanelTextInputSpecs,'Position');
set(handles.PanelTextInputSpecs,'Position',...
    [fposPanelTextInputSpecs(1) fposPanelTextInputSpecs(2) fpos(3)-2*fposPanelTextInputSpecs(1)...
    fposPanelTextInputSpecs(4)]);
%      posTextBlockTypeOld = get(handles.textBlockType,'Position');
%      figureFrames = get_figureFrames();
%      posTextBlockTypeNew = [posTextBlockTypeOld(1) ...
%          fpos(4)-1.725*figureFrames.top ...
%          posTextBlockTypeOld(3) ...
%          posTextBlockTypeOld(4)];
%      set(handles.textBlockType,'Position',posTextBlockTypeNew);