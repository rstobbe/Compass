%===========================================
% (v2c)
%   - Stard from kSpaceSample_v2c
%===========================================

function [SCRPTipt,SCRPTGBL,err] = kSpaceSample_Grd_v2c(SCRPTipt,SCRPTGBL)

Status('busy','Sample kSpace');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Sampling_Name',{SCRPTipt.labelstr});
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

%---------------------------------------------
% Load Input
%---------------------------------------------
SAMP.method = SCRPTGBL.CurrentTree.Func;
SAMP.ObjectFunc = SCRPTGBL.CurrentTree.('Objectfunc').Func;
SAMP.GridRevFunc = SCRPTGBL.CurrentTree.('GridRevfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
OBipt = SCRPTGBL.CurrentTree.('Objectfunc');
if isfield(SCRPTGBL,('Objectfunc_Data'))
    OBipt.Objectfunc_Data = SCRPTGBL.Objectfunc_Data;
end
GRDRipt = SCRPTGBL.CurrentTree.('GridRevfunc');
if isfield(SCRPTGBL,('GridRevfunc_Data'))
    GRDRipt.GridRevfunc_Data = SCRPTGBL.GridRevfunc_Data;
end

%------------------------------------------
% Get Object Function Info
%------------------------------------------
func = str2func(SAMP.ObjectFunc);           
[SCRPTipt,OB,err] = func(SCRPTipt,OBipt);
if err.flag
    return
end

%------------------------------------------
% Get Object Function Info
%------------------------------------------
func = str2func(SAMP.GridRevFunc);           
[SCRPTipt,GRDR,err] = func(SCRPTipt,GRDRipt);
if err.flag
    return
end

%---------------------------------------------
% Load Implementation
%---------------------------------------------
IMP = SCRPTGBL.Imp_File_Data.IMP;

%---------------------------------------------
% Sample k-Space
%---------------------------------------------
func = str2func([SAMP.method,'_Func']);
INPUT.IMP = IMP;
INPUT.OB = OB;
INPUT.GRDR = GRDR;
[SAMP,err] = func(INPUT,SAMP);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Sampling:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
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
