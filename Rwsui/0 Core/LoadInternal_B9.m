%====================================================
%
%====================================================

function LoadInternal_B9(panelnum,tab,scrptnum)

Status('busy','Load Script');

global TOTALGBL
global SCRPTIPTGBL
global FIGOBJS

%---------------------------------------------
% Get Image
%---------------------------------------------
val = FIGOBJS.(tab).GblList.Value;
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No Scripts in Global Memory';
    ErrDisp(err);
    return  
end
totgblnum = FIGOBJS.(tab).GblList.UserData(val).totgblnum;
saveData = TOTALGBL{2,totgblnum};
if not(isfield(saveData,'saveSCRPTcellarray')) && not(isprop(saveData,'saveSCRPTcellarray'))
    Status('error','Not a loadable script');
    return
end
CellArray = saveData.saveSCRPTcellarray;

%----------------------------------------------------
% Display
%----------------------------------------------------
[SCRPTipt] = LabelGet(tab,panelnum);
Options.scrptnum = scrptnum;
[Current] = PANlab2CellArray_B9(SCRPTipt,Options);
Current(scrptnum,:) = CellArray;
[SCRPTipt] = PanelRoutine(Current,tab,panelnum);   
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,tab,panelnum);

%----------------------------------------------------
% Search for Scripts
%----------------------------------------------------
%AddPaths_B9     - replace with a search for scripts

%--------------------------------------------
% Assign New Default Parameters
%--------------------------------------------
SCRPTIPTGBL.(tab)(panelnum).default(scrptnum,:) = CellArray;

Status('done','Script Loaded');
