%===================================================
% 
%===================================================
function Dim4ChangeControl(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = 'IM';
end
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

if not(IMAGEANLZ.(tab)(axnum).TestAxisActive);
    return
end

if not(isempty(IMAGEANLZ.(tab)(axnum).buttonfunction))
    error;          % shouldn't get here
end

%------------------------------------------
% Dim4 Change
%------------------------------------------
currentax = gca;
src.Value = round(src.Value);
Dim4_Change(currentax,tab,axnum,src.Value);
