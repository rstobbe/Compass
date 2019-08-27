%=========================================================
% 
%=========================================================

function UpdateImageInfoBox(tab,totgblnum)

global TOTALGBL
global FIGOBJS

%FIGOBJS.(tab).UberTabGroup.SelectedTab = FIGOBJS.(tab).TopInfoTab;
FIGOBJS.(tab).InfoTabGroup.SelectedTab = FIGOBJS.(tab).InfoTabL;

if isfield(TOTALGBL{2,totgblnum},'ExpDisp');
    FIGOBJS.(tab).InfoL.String = TOTALGBL{2,totgblnum}.ExpDisp;
end

drawnow;