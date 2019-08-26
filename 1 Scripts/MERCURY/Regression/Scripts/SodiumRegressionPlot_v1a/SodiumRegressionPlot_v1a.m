%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SodiumRegressionPlot_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Test Regression');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Test_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'Reg_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Reg_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Reg_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Reg_File';
            ErrDisp(err);
            return
        else
            load(file);
            SCRPTGBL.('Reg_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Reg_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOT.method = SCRPTGBL.CurrentScript.Func;
STUDY = SCRPTGBL.('Reg_File_Data').STUDY;

%---------------------------------------------
% Test
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.STUDY = STUDY;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = PLOT.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Plot:','Name',1,{['PLOT_',PLOT.name]});
if isempty(name)
    SCRPTGBL.RWSUI.SaveVariables = {PLOT};
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
PLOT.name = name{1};

SCRPTipt(indnum).entrystr = PLOT.name;
SCRPTGBL.RWSUI.SaveVariables = PLOT;
SCRPTGBL.RWSUI.SaveVariableNames = 'PLOT';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = PLOT.name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = PLOT.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

