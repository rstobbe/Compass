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

IMAGEANLZ.(tab)(1).SetTotGblNumHighlight(totgblnum);

%--------------------------------------------------
% Script Panels
%--------------------------------------------------
UpdateImageInfoBox(tab,totgblnum);
return

