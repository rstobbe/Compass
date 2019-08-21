%=========================================================
% Script Options
%=========================================================

function [err] = RemoveScript(panelnum,tab,scrptnum)

global SCRPTGBL
global DEFFILEGBL

err.flag = 0;
err.msg = '';

[SCRPTipt] = LabelGet_B9(tab,panelnum);
Options.scrptnum = scrptnum;
[Current0] = PANlab2CellArray_B9(SCRPTipt,Options);
Current(1:scrptnum-1,:) = Current0(1:scrptnum-1,:);
Current(scrptnum+1:length(Current),:) = Current0(scrptnum+1:length(Current),:);
[SCRPTipt] = PanelRoutine_B9(Current,tab,panelnum);
setfunc = 1;
DispScriptParam_B9(SCRPTipt,setfunc,tab,panelnum);
SCRPTGBL.(tab){panelnum,scrptnum} = [];

DEFFILEGBL.(tab)(panelnum,scrptnum).file = '';
DEFFILEGBL.(tab)(panelnum,scrptnum).runfunc = '';