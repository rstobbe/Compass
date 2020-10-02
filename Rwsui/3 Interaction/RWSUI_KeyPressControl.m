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

if isempty(IMAGEANLZ)
    return
end

currentax = gca;
tab = currentax.Parent.Parent.Tag;
if not(isfield(IMAGEANLZ,tab))
    tab = currentax.Parent.Parent.Parent.Parent.Tag;
end

if strcmp(event.Key,'q')
    TabReset(tab);
    return
end

if strcmp(event.Key,'delete')
    if isgraphics(FIGOBJS.Compass.CurrentObject,'Axes')
        if strcmp(tab,'IM3')
            TabReset(tab);
        else
            axnum = GetFocus(tab);
            AxisReset(tab,axnum);
        end
    elseif strcmp(FIGOBJS.Compass.CurrentObject.Style,'listbox')
        val = FIGOBJS.Compass.CurrentObject.Value;
        for n = 1:length(val)
            if val ~= 0
                totgblnum(n) = FIGOBJS.Compass.CurrentObject.UserData(val(n)).totgblnum;
            end
        end
        for n = 1:length(totgblnum)
            Delete_TOTALGBL(totgblnum(n));
            axnum = GetFocus(tab);
            SetFocus(tab,axnum);
        end
        return
    end
end

FIGOBJS.Compass.CurrentObject = currentax;

axnum = str2double(currentax.Tag);
if isnan(axnum)
    return
end
if not(IMAGEANLZ.(tab)(axnum).TestAxisActive)
    return
end

KeyPressControl(currentax,tab,axnum,event);

