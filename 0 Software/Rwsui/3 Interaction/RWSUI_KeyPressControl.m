%============================================
% What to do key pressed
%============================================
function RWSUI_KeyPressControl(src,event)

global IMAGEANLZ
global RWSUIGBL
global FIGOBJS

RWSUIGBL.Character = event.Character;
RWSUIGBL.Key = event.Key;

currentob = gco;
if not(isempty(currentob))
    if strcmp(currentob.Type,'uitab')
        return
    elseif strcmp(currentob.Type,'uipanel')
        return
    elseif strcmp(currentob.Type,'uicontrol') && strcmp(currentob.Style,'edit') 
        return
    end
end

test = gcf;
if FIGOBJS.Compass ~= test
    return
end

currentax = gca;
FIGOBJS.Compass.CurrentObject = currentax;

tab = currentax.Parent.Parent.Tag;
if not(isfield(IMAGEANLZ,tab))
    tab = currentax.Parent.Parent.Parent.Parent.Tag;
end
if strcmp(event.Character,'Q')
    TabReset(tab);
    return
end

axnum = str2double(currentax.Tag);
if isnan(axnum)
    return
end
if not(IMAGEANLZ.(tab)(axnum).TestAxisActive)
    return
end

KeyPressControl(currentax,tab,axnum,event);

