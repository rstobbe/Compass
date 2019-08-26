%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = AddNoiseT2_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Add Noise and Signal Decay to Data');
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
    if isfield(SCRPTGBL.CurrentTree.('Imp_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SCRPTGBL.('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'kSamp_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('kSamp_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('kSamp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load kSamp_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SCRPTGBL.('kSamp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load kSamp_File';
        ErrDisp(err);
        return
    end
end


%---------------------------------------------
% Load Input
%---------------------------------------------
IEFF.method = SCRPTGBL.CurrentTree.Func;
IEFF.noisefunc = SCRPTGBL.CurrentTree.('Noisefunc').Func;
IEFF.t2func = SCRPTGBL.CurrentTree.('T2func').Func;
IMP = SCRPTGBL.('Imp_File_Data').IMP;
KSMP = SCRPTGBL.('kSamp_File_Data').SAMP;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
T2ipt = SCRPTGBL.CurrentTree.('T2func');
if isfield(SCRPTGBL,('T2func_Data'))
    T2ipt.T2func_Data = SCRPTGBL.T2func_Data;
end
NOISEipt = SCRPTGBL.CurrentTree.('Noisefunc');
if isfield(SCRPTGBL,('Noisefunc_Data'))
    NOISEipt.Noisefunc_Data = SCRPTGBL.Noisefunc_Data;
end

%------------------------------------------
% Get T2 Function Info
%------------------------------------------
func = str2func(IEFF.t2func);           
[SCRPTipt,T2,err] = func(SCRPTipt,T2ipt);
if err.flag
    return
end

%------------------------------------------
% Get Noise Function Info
%------------------------------------------
func = str2func(IEFF.noisefunc);           
[SCRPTipt,NOISE,err] = func(SCRPTipt,NOISEipt);
if err.flag
    return
end

%---------------------------------------------
% Add Noise and T2
%---------------------------------------------
func = str2func([IEFF.method,'_Func']);
INPUT.IMP = IMP;
INPUT.KSMP = KSMP;
INPUT.NOISE = NOISE;
INPUT.T2 = T2;
INPUT.IEFF = IEFF;
[IEFF,err] = func(INPUT);
if err.flag
    return
end
clear INPUT;

SAMP = KSMP;
SAMP.SampDat = IEFF.SampDat;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Noise Data:');
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

SCRPTGBL.RWSUI.SaveVariables = {SAMP};
SCRPTGBL.RWSUI.SaveVariableNames = {'SAMP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);



