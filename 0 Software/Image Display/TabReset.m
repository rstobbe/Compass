%=========================================================
% 
%=========================================================

function TabReset(tab)

global FIGOBJS
for axnum = 1:length(FIGOBJS.(tab).ImAxes)  
    AxisReset(tab,axnum);
end

if strcmp(tab,'IM')
    FIGOBJS.IM.CurrentImage = 0;
end

if strcmp(tab,'IM3')
    InitializeOrthoPresentation(tab);
end