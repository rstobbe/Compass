%===================================================
% 
%===================================================
function Dim4val(src,event)

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
% Dim4 Change
%------------------------------------------
currentax = gca;
val = str2double(src.String);
imsize = IMAGEANLZ.(tab)(axnum).GetBaseImageSize([]);
if val > imsize(4);
    val = imsize(4);
    src.String = num2str(val);
end

Dim4_Change(currentax,tab,axnum,val);
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    FIGOBJS.(tab).Dim4(1).Value = val;
else
    FIGOBJS.(tab).Dim4(axnum).Value = val;
end