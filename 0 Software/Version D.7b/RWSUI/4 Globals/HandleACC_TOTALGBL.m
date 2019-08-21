function HandleACC_TOTALGBL(Control,Action)

%--------------------------------------------------
% Input
%--------------------------------------------------
val = Control.Value;
if isempty(val)
    return
end
totgblnum = Control.UserData(val).totgblnum;
tab = Control.Parent.Parent.Parent.Tag;

%--------------------------------------------------
% Script Panels
%--------------------------------------------------
UpdateInfoBox(tab,totgblnum);
return
