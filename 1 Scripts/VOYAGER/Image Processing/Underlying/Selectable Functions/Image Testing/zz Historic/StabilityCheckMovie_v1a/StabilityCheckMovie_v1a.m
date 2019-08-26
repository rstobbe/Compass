%===========================================
% 
%===========================================

function [SCRPTipt,SCRPTGBL,err] = StabilityCheckMovie_v1a(SCRPTipt,SCRPTGBL)

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
TST.filtfunc = SCRPTGBL.CurrentTree.('Filtfunc').Func;
TST.maskfunc = SCRPTGBL.CurrentTree.('Maskfunc').Func;
TST.images = SCRPTGBL.CurrentTree.('Images');
TST.slicenum = str2double(SCRPTGBL.CurrentTree.('SliceNum'));

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
FILTipt = SCRPTGBL.CurrentTree.('Filtfunc');
if isfield(SCRPTGBL,('Filtfunc_Data'))
    FILTipt.Filtfunc_Data = SCRPTGBL.Filtfunc_Data;
end
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
func = str2func(TST.filtfunc);           
[SCRPTipt,FILT,err] = func(SCRPTipt,FILTipt);
if err.flag
    return
end

%---------------------------------------------
% Test Stability
%---------------------------------------------
func = str2func([TST.method,'_Func']);
INPUT.FILT = FILT;
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
