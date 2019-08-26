%==============================================
% (v1b)
%       - regress to middle of gradient steps
%==============================================

function [SCRPTipt,SCRPTGBL,err] = TrajModelFitting_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Trajectroy Model Fitting');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get EDDY Currents
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No EDDY in Global Memory';
    return  
end
EDDY = TOTALGBL{2,val};

%-----------------------------------------------------
% Test
%-----------------------------------------------------
if not(isfield(EDDY,'Geddy'))
    err.flag = 1;
    err.msg = 'Global does not contain eddy currents';
    return
end

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
            SCRPTGBL.('Imp_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',EDDY.ExpDisp);

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
RGRS.method = SCRPTGBL.CurrentTree.Func;
RGRS.modelfunc = SCRPTGBL.CurrentTree.('Modelfunc').Func;
RGRS.gstartshift = str2double(SCRPTGBL.CurrentTree.('GStartShift'));
IMP = SCRPTGBL.('Imp_File_Data').IMP;
tcest = SCRPTGBL.CurrentTree.('Tc_Estimate');
magest = SCRPTGBL.CurrentTree.('Mag_Estimate');

%---------------------------------------------
% Get Values
%---------------------------------------------
inds1 = strfind(tcest,',');
inds2 = strfind(magest,',');
if isempty(inds1)
    inds1 = strfind(tcest,' ');
    inds2 = strfind(magest,' ');
end
if length(inds1) ~= length(inds2)
    err.flag = 1;
    err.msg = '''Tc Estimate'' and ''Mag Estimate'' must be the same length';
    return
end
if isempty(inds1)
    RGRS.tcest = str2double(tcest);
    RGRS.magest = str2double(magest);
else
    RGRS.tcest(1) = str2double(tcest(1:inds1(1)-1));
    RGRS.magest(1) = str2double(magest(1:inds2(1)-1));    
    for n = 2:length(inds1)
        RGRS.tcest(n) = str2double(tcest(inds1(n-1)+1:inds1(n)-1));
        RGRS.magest(n) = str2double(magest(inds2(n-1)+1:inds2(n)-1));
    end
    if isempty(n)
        n = 1;
    end
    RGRS.tcest(length(inds1)+1) = str2double(tcest(inds1(n)+1:length(tcest)));
    RGRS.magest(length(inds1)+1) = str2double(magest(inds2(n)+1:length(magest)));     
end

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
ECMipt = SCRPTGBL.CurrentTree.('Modelfunc');
if isfield(SCRPTGBL,('Modelfunc_Data'))
    ECMipt.Modelfunc_Data = SCRPTGBL.Modelfunc_Data;
end

%------------------------------------------
% Model Function Info
%------------------------------------------
func = str2func(RGRS.modelfunc);           
[SCRPTipt,ECM,err] = func(SCRPTipt,ECMipt);
if err.flag
    return
end

%-----------------------------------------------------
% Perform Regression
%-----------------------------------------------------
func = str2func([RGRS.method,'_Func']);
INPUT.EDDY = EDDY;
INPUT.ECM = ECM;
INPUT.IMP = IMP;
[RGRS,err] = func(RGRS,INPUT);
if err.flag
    return
end

%-----------------------------------------------------
% Panel
%-----------------------------------------------------
SCRPTGBL.RWSUI.LocalOutput = RGRS.PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Eddy Current Regression:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Rgrs_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {RGRS};
SCRPTGBL.RWSUI.SaveVariableNames = {'RGRS'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};

