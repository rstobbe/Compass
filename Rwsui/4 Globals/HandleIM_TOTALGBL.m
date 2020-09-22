function HandleIM_TOTALGBL(Control,Action)

global IMAGEANLZ

%--------------------------------------------------
% Input
%--------------------------------------------------
val = Control.Value;
if isempty(val)
    return
end
totgblnum = Control.UserData(val).totgblnum;
tab = Control.Parent.Parent.Parent.Tag;

for n = 1:IMAGEANLZ.(tab)(1).axeslen
    IMAGEANLZ.(tab)(n).SetTotGblNumHighlight(totgblnum);
end

%--------------------------------------------------
% Script Panels
%--------------------------------------------------
UpdateImageInfoBox(tab,totgblnum);

axnum = GetFocus(tab);
if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    return
end

IMAGEANLZ.(tab)(axnum).SetFocus;