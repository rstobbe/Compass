%=========================================================
% 
%=========================================================

function UpdateInfoBox(tab,totgblnum)

global TOTALGBL
global FIGOBJS

if isfield(TOTALGBL{2,totgblnum},'ExpDisp')
    FIGOBJS.(tab).Info.String = TOTALGBL{2,totgblnum}.ExpDisp;
end

drawnow;