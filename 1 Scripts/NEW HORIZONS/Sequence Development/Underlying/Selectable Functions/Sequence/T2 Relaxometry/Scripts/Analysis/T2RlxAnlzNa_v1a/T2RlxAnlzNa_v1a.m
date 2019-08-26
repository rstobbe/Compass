%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = T2RlxAnlzNa_v1a(SCRPTipt,SCRPTGBL)

Status('busy','T2 Relaxometry Study Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('RlxDes_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'RlxDes_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('RlxDes_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('RlxDes_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load RlxDes_File';
            ErrDisp(err);
            return
        else
            Status('busy','Load Rlxient Design');
            load(file);
            saveData.path = file;
            SCRPTGBL.('RlxDes_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load RlxDes_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
RLXANLZ.script = SCRPTGBL.CurrentTree.Func;
T2f = SCRPTGBL.CurrentTree.('T2f');
RLXANLZ.T2s = str2double(SCRPTGBL.CurrentTree.('T2s'));
SMNR = (SCRPTGBL.CurrentTree.('SMNR'));
RLXANLZ.MonteCarlo = str2double(SCRPTGBL.CurrentTree.('MonteCarlo'));
RLXANLZ.N = str2double(SCRPTGBL.CurrentTree.('N'));
RLXDES = SCRPTGBL.('RlxDes_File_Data').RLXDES;

%---------------------------------------------
% SMNR
%---------------------------------------------
inds = strfind(SMNR,':');
RLXANLZ.smnrmin = str2double(SMNR(1:inds(1)-1));
RLXANLZ.smnrstep = str2double(SMNR(inds(1)+1:inds(2)-1));
RLXANLZ.smnrmax = str2double(SMNR(inds(2)+1:length(SMNR))); 

%---------------------------------------------
% T2f
%---------------------------------------------
inds = strfind(T2f,':');
RLXANLZ.T2fmin = str2double(T2f(1:inds(1)-1));
RLXANLZ.T2fstep = str2double(T2f(inds(1)+1:inds(2)-1));
RLXANLZ.T2fmax = str2double(T2f(inds(2)+1:length(T2f))); 

%---------------------------------------------
% Grid
%---------------------------------------------
func = str2func([RLXANLZ.script,'_Func']);
INPUT.RLXDES = RLXDES;
[RLXANLZ,err] = func(RLXANLZ,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Display
%--------------------------------------------


%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name RlxDes:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('RlxDes_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {RLXANLZ};
SCRPTGBL.RWSUI.SaveVariableNames = {'RLXANLZ'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
