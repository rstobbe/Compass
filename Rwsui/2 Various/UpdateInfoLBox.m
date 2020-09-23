%=========================================================
% 
%=========================================================

function UpdateInfoLBox(tab,totgblnum)

global TOTALGBL
global FIGOBJS

if isfield(TOTALGBL{2,totgblnum},'ExpDisp')
    FIGOBJS.(tab).InfoL.String = TOTALGBL{2,totgblnum}.ExpDisp;
end

drawnow;