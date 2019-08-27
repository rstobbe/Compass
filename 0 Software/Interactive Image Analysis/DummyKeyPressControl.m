%============================================
% What to do key pressed
%============================================
function DummyKeyPressControl(src,event)

global FIGOBJS

if not(strcmp(event.Character,'Q'))
    return
end

currentax = gca;
FIGOBJS.Compass.CurrentObject = currentax;
tab = currentax.Parent.Parent.Title;
if strcmp(tab,'Imaging')
    tab = 'IM';
elseif strcmp(tab,'Imaging2')
    tab = 'IM2';
elseif strcmp(tab,'Imaging4')
    tab = 'IM4';
end
TabReset(tab);
