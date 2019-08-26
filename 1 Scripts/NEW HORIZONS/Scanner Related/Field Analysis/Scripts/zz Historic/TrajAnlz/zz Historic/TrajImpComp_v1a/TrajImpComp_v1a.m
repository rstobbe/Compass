%==================================================
% (v1a)
%     
%==================================================

function [SCRPTipt,SCRPTGBL,err] = TrajImpComp_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Compare Measured Trajectory to Implementation');
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
if not(isfield(SCRPTGBL,'GradDes_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('GradDes_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('GradDes_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GradDes_File';
            ErrDisp(err);
            return
        else
            SCRPTGBL.('GradDes_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GradDes_File';
        ErrDisp(err);
        return
    end
end

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;
GRD = SCRPTGBL.('GradDes_File_Data').GRD;
    
%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',EDDY.ExpDisp);

%---------------------------------------------
% Plot Comparison
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.EDDY = EDDY;
INPUT.GRD = GRD;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';
