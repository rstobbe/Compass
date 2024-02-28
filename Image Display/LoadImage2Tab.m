%===================================================
%
%===================================================
function LoadImage2Tab(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Tag;
axnum = str2double(src.Tag);
SetFocus(tab,axnum);
IMAGEANLZ.(tab)(axnum).Highlight;

if isempty(IMAGEANLZ.(tab)(axnum).totgblnumhl)
    return
end

global TOTALGBL
global TOTALGBLHOLD
TOTALGBL{2,IMAGEANLZ.(tab)(axnum).totgblnumhl} = TOTALGBLHOLD{2,IMAGEANLZ.(tab)(axnum).totgblnumhl};

%--------------------------------------------
% Load
%--------------------------------------------
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    Gbl2Image(tab,axnum,IMAGEANLZ.(tab)(axnum).totgblnumhl);
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    Gbl2ImageOrtho(tab,IMAGEANLZ.(tab)(axnum).totgblnumhl);
end
