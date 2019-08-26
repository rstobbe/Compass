%==================================================
% (v1b)
%     
%==================================================

function [SCRPTipt,SCRPTGBL,err] = ExportGradStepResp_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Transient Fields During/After Gradient');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'GradDes_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('GradDes_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('GradDes_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GradDes_File';
            ErrDisp(err);
            return
        else
            Status('busy','Load Gradient Design');
            load(file);
            saveData.path = file;
            SCRPTGBL.('GradDes_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GradDes_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'GradSRX_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('GradSRX_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('GradSRX_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GradSRX_File';
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
            err.msg = '(Re) Load GradSRY_File';
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
            err.msg = '(Re) Load GradSRZ_File';
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
TGFX = SCRPTGBL.('GradSRX_File_Data').SR;
TGFY = SCRPTGBL.('GradSRY_File_Data').SR;
TGFZ = SCRPTGBL.('GradSRZ_File_Data').SR;
GRD = SCRPTGBL.('GradDes_File_Data').GRD;

%---------------------------------------------
% Export Step Response
%---------------------------------------------
func = str2func([SR.method,'_Func']);
INPUT.TGFX = TGFX;
INPUT.TGFY = TGFY;
INPUT.TGFZ = TGFZ;
INPUT.GRD = GRD;
[OUTPUT,err] = func(SR,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';
