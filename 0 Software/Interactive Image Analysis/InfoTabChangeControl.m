%============================================
% 
%============================================
function InfoTabChangeControl(src,event)

global FIGOBJS
global IMAGEANLZ
global COMPASSINFO

TabTitle = event.NewValue.Title;
axnum = str2double(TabTitle(end));
if axnum == 0
    axnum = 10;
end

if isnan(axnum)
    return
end

tab = src.Parent.Parent.Parent.Tag;
if strcmp(tab,'IM')
    FIGOBJS.IM.TabGroup.SelectedTab = FIGOBJS.IM.ImTab(axnum);
    IMAGEANLZ.IM(axnum).UpdateStatus; 
elseif strcmp(tab,'IM2')
    for n = 1:2
        FIGOBJS.(tab).ImPan(n).HighlightColor = 'w';
    end
    IMAGEANLZ.IM2(axnum).UpdateStatus;  
elseif strcmp(tab,'IM4')
    for n = 1:4
        FIGOBJS.(tab).ImPan(n).HighlightColor = 'w';
    end
    IMAGEANLZ.IM4(axnum).UpdateStatus;    
end

% FIGOBJS.Compass.CurrentAxes = FIGOBJS.(tab).ImAxes(axnum);
% FIGOBJS.Compass.CurrentObject = FIGOBJS.(tab).ImAxes(axnum);
FIGOBJS.Compass.CurrentAxes = [];
FIGOBJS.Compass.CurrentObject = [];

if not(strcmp(COMPASSINFO.USERGBL.setup,'ImageAnalysis'))
    for n = 1:10
        IMAGEANLZ.IM(n).UnHighlight;
    end
end