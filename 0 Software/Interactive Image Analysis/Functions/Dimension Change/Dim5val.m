%===================================================
% 
%===================================================
function Dim5val(src,event)

global IMAGEANLZ
global FIGOBJS

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
% Dim5 Change
%------------------------------------------
currentax = gca;
val = str2double(src.String);
imsize = IMAGEANLZ.(tab)(axnum).GetBaseImageSize([]);
if val > imsize(5);
    val = imsize(5);
    src.String = num2str(val);
end

Dim5_Change(currentax,tab,axnum,val);
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    FIGOBJS.(tab).Dim5(1).Value = val;
else
    FIGOBJS.(tab).Dim5(axnum).Value = val;
end