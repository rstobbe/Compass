%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = kSpaceShift_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Shift kSpace');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('ImagingEffect_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    err.flag = 1;
    err.msg = '(Re)Load Imp_File';
    return
elseif not(isfield(SCRPTGBL,'kSamp_File_Data'))
    err.flag = 1;
    err.msg = '(Re)Load Samp_File';
    return
end

%---------------------------------------------
% Load Input
%---------------------------------------------
IEFF.method = SCRPTGBL.CurrentTree.Func;
IEFF.kshftfunc = SCRPTGBL.CurrentTree.('kShiftfunc').Func;
IMP = SCRPTGBL.('Imp_File_Data').IMP;
KSMP = SCRPTGBL.('kSamp_File_Data').SAMP;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
KSHFTipt = SCRPTGBL.CurrentTree.('kShiftfunc');
if isfield(SCRPTGBL,('kShiftfunc_Data'))
    KSHFTipt.kShiftfunc_Data = SCRPTGBL.kShiftfunc_Data;
end

%------------------------------------------
% Get KSHFT Function Info
%------------------------------------------
func = str2func(IEFF.kshftfunc);           
[SCRPTipt,KSHFT,err] = func(SCRPTipt,KSHFTipt);
if err.flag
    return
end

%---------------------------------------------
% Shift k-space
%---------------------------------------------
func = str2func([IEFF.method,'_Func']);
INPUT.IMP = IMP;
INPUT.KSMP = KSMP;
INPUT.KSHFT = KSHFT;
INPUT.IEFF = IEFF;
[IEFF,err] = func(INPUT);
if err.flag
    return
end
clear INPUT;

IMP.Kmat = IEFF.Kmat;
IMP.IEFF = IEFF;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Data:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('ImagingEffect_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {IMP};
SCRPTGBL.RWSUI.SaveVariableNames = {'IMP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'ProjImp_kshift';

Status('done','');
Status2('done','',2);
Status2('done','',3);



