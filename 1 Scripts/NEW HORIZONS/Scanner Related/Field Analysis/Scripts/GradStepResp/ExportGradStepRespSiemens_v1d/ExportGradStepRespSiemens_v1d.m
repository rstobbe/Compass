%==================================================
% (v1d)
%    start 'ExportGradStepRespRise_v1d'
%==================================================

function [SCRPTipt,SCRPTGBL,err] = ExportGradStepRespSiemens_v1d(SCRPTipt,SCRPTGBL)

Status('busy','Export Step Response');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('StepResp_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'GradSRX_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('GradSRX_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('GradSRX_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = 'GradSRX_File not found - reload';
            ErrDisp(err);
            return
        else
            Status('busy','Load Gradient Design');
            load(file);
            saveData.path = file;
            SCRPTGBL.('GradSRX_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GradSRX_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'GradSRY_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('GradSRY_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('GradSRY_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = 'GradSRY_File not found - reload';
            ErrDisp(err);
            return
        else
            Status('busy','Load Gradient Design');
            load(file);
            saveData.path = file;
            SCRPTGBL.('GradSRY_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GradSRY_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'GradSRZ_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('GradSRZ_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('GradSRZ_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = 'GradSRZ_File not found - reload';
            ErrDisp(err);
            return
        else
            Status('busy','Load Gradient Design');
            load(file);
            saveData.path = file;
            SCRPTGBL.('GradSRZ_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GradSRZ_File';
        ErrDisp(err);
        return
    end
end

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
SR.method = SCRPTGBL.CurrentTree.Func;
SR.Tstep = str2double(SCRPTGBL.CurrentTree.('Tstep'));
SR.Tmax = str2double(SCRPTGBL.CurrentTree.('Tmax'));
SR.Gmax = str2double(SCRPTGBL.CurrentTree.('Gmax'));
SR.graddel = str2double(SCRPTGBL.CurrentTree.('DelayGrad'));
SR.R2Fswitch = str2double(SCRPTGBL.CurrentTree.('R2Fswitch'));
TGFX = SCRPTGBL.('GradSRX_File_Data').MFEVO;
TGFY = SCRPTGBL.('GradSRY_File_Data').MFEVO;
TGFZ = SCRPTGBL.('GradSRZ_File_Data').MFEVO;

%---------------------------------------------
% Export Step Response
%---------------------------------------------
func = str2func([SR.method,'_Func']);
INPUT.TGFX = TGFX;
INPUT.TGFY = TGFY;
INPUT.TGFZ = TGFZ;
[SR,err] = func(SR,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = SR.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Step Response:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {SR};
SCRPTGBL.RWSUI.SaveVariableNames = {'SR'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};


