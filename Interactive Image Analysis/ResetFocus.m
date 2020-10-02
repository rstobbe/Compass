%============================================
% 
%============================================
function ResetFocus(src,event)

global FIGOBJS
global IMAGEANLZ

if isempty(IMAGEANLZ)
    return
end

currentax = gca;
FIGOBJS.Compass.CurrentObject = currentax;

if not(isempty(currentax.Parent.Tag))
    tab = currentax.Parent.Tag;
elseif not(isempty(currentax.Parent.Parent.Tag))
    tab = currentax.Parent.Parent.Tag;
    if not(isfield(IMAGEANLZ,tab))
        tab = currentax.Parent.Parent.Parent.Parent.Tag;
    end
elseif not(isempty(currentax.Parent.Parent.Parent.Tag))
    tab = currentax.Parent.Parent.Parent.Tag;
elseif not(isempty(currentax.Parent.Parent.Parent.Parent.Tag))
    tab = currentax.Parent.Parent.Parent.Parent.Tag;
else
    error
end
axnum = str2double(currentax.Tag);
if isnan(axnum)
    return
end
IMAGEANLZ.(tab)(axnum).UpdateStatus;