%=================================================
% 
%=================================================
function ImageTabChange(src,event)

global IMAGEANLZ
global FIGOBJS

%--------------------------------------------
% tab Selected
%--------------------------------------------
TabTitle = event.NewValue.Title;
TabNumber = str2double(TabTitle(end));
if TabNumber == 0
    TabNumber = 10;
end

IMAGEANLZ.IM(TabNumber).UpdateStatus; 
IMAGEANLZ.IM(TabNumber).TabChange;
for n = 1:10
    IMAGEANLZ.IM(n).UnHighlight;
end

FIGOBJS.IM.CurrentImage = TabNumber;

