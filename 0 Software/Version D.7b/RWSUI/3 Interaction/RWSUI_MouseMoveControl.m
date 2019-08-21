%============================================
% 
%============================================
function RWSUI_MouseMoveControl(src,event)

global IMAGEANLZ

currentob = gco;
if isempty(currentob)
    %blah = 1
    return
else
    test = currentob.Type;
    if not(strcmp(test,'axes'))
        %blah = 2
        return
    end
end

currentax = gca;
if not(strcmp(currentax.Parent.Parent.Type,'uitab'))
    return
end
tab = currentax.Parent.Parent.Tag;
if not(isfield(IMAGEANLZ,tab))
    tab = currentax.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(currentax.Tag);
if isnan(axnum)
    return
end
if not(IMAGEANLZ.(tab)(axnum).TestAxisActive)
    return
end
MouseMoveControl(currentax,tab,axnum);