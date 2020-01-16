%=========================================================
% 
%=========================================================

function AxisReset(tab,axnum)

global IMAGEANLZ
global FIGOBJS

set(gcf,'pointer','arrow');

if isfield(FIGOBJS.(tab),'DispPan')
    if axnum <= length(FIGOBJS.(tab).DispPan)
        delete(FIGOBJS.(tab).DispPan(axnum))
    end
end

IMAGEANLZ.(tab)(axnum).Initialize(tab,axnum);

if strcmp(tab,'IM')
    FIGOBJS.IM.CurrentImage = 0;
end

if strcmp(tab,'IM3')
    InitializeOrthoPresentation(tab);
end



