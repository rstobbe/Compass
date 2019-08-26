%===========================================
% 
%===========================================

function [SCRPTipt,SCRPTGBL,err] = StabilityCheckASL_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Check Image Stability');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Image
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No Image in Global Memory';
    return  
end
IMG = TOTALGBL{2,val};

%---------------------------------------------
% Mask Input
%---------------------------------------------
TST.method = SCRPTGBL.CurrentTree.Func;
TST.type = SCRPTGBL.CurrentTree.('Type');
TST.maskfunc = SCRPTGBL.CurrentTree.('Maskfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
MASKipt = SCRPTGBL.CurrentTree.('Maskfunc');
if isfield(SCRPTGBL,('Maskfunc_Data'))
    MASKipt.Maskfunc_Data = SCRPTGBL.Maskfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(TST.maskfunc);           
[SCRPTipt,MASK,err] = func(SCRPTipt,MASKipt);
if err.flag
    return
end

%---------------------------------------------
% Test Stability
%---------------------------------------------
func = str2func([TST.method,'_Func']);
INPUT.MASK = MASK;
INPUT.IMG = IMG;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[TST,err] = func(TST,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.KeepEdit = 'yes';
