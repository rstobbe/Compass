%==================================================
% (v1a)
%      
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_TrajTest_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Trajectory Test');
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
% Get Input
%-----------------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;
PLOT.clr = SCRPTGBL.CurrentTree.('Colour');
PLOT.gstartshift = str2double(SCRPTGBL.CurrentTree.('GStartShift'));
PLOT.trajnum = str2double(SCRPTGBL.CurrentTree.('TrajNum'));
PLOT.trajortho = str2double(SCRPTGBL.CurrentTree.('TrajOrtho'));
PLOT.gpol = SCRPTGBL.CurrentTree.('Polarity');
IMP = SCRPTGBL.('Imp_File_Data').IMP;

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',EDDY.ExpDisp);

%---------------------------------------------
% Plot Eddy Currents
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.EDDY = EDDY;
INPUT.IMP = IMP;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';
