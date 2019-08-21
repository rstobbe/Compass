%====================================================
%
%====================================================

function [saveData,saveSCRPTcellarray,saveGlobalNames,err] = LoadSelectedFile_B9(panelnum,tab,scrptnum,path,file)

err.flag = 0;
err.msg = '';

global SCRPTPATHS
global SCRPTIPTGBL
global SCRPTGBL

%----------------------------------------------------
% Load
%----------------------------------------------------
load(strcat(path,file));
if not(exist('saveData','var')) || not(exist('saveSCRPTcellarray','var')) || not(exist('saveGlobalNames','var'))
    err.flag = 1;
    err.msg = 'Not a Saved Script File';
    ErrDisp(err);
    saveData = [];
    saveSCRPTcellarray = [];
    saveGlobalNames = [];
    return
end
CellArray = saveSCRPTcellarray;
SCRPTPATHS.(tab)(panelnum).outloc = path;

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

%--------------------------------------------
% Assign New Default Parameters
%--------------------------------------------
SCRPTIPTGBL.(tab)(panelnum).default(scrptnum,:) = CellArray;

%--------------------------------------------
% Reset Global
%--------------------------------------------
SCRPTGBL.(tab){panelnum,scrptnum} = [];

