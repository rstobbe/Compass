%====================================================
%
%====================================================

function [runfunc,CellArray,err] = LoadScrptDefault2Panels(panelnum,tab,scrptnum,CellArray)

Status('busy','Load Script Default');

global SCRPTPATHS
global SCRPTIPTGBL

runfunc = '';

%----------------------------------------------------
% Build
%----------------------------------------------------
% [SCRPTipt] = PanelRoutine(CellArray,tab,panelnum); 
% Options.scrptnum = 1;
% CellArray = PANlab2CellArray_B9(SCRPTipt,Options);

%----------------------------------------------------
% Search for Scripts
%----------------------------------------------------
[CellArray,pathschanged,err] = SearchPaths_B9(CellArray,SCRPTPATHS.(tab)(panelnum));

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
% Return Run Func
%----------------------------------------------------
runfunc0 = SCRPTipt(end).runscrptfunc1;
runfunc.func = str2func(runfunc0{1});
runfunc.input = runfunc0(2:6);

%--------------------------------------------
% Assign New Default Parameters
%--------------------------------------------
SCRPTIPTGBL.(tab)(panelnum).default(scrptnum,:) = CellArray;

Status('done','Default Script Loaded');


