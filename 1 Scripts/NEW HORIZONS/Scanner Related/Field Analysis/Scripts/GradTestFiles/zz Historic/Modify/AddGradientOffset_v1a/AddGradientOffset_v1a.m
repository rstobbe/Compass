%=====================================================
% (v1a) 
%           
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = AddGradientOffset_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Get Info');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('GradTest_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'GradTest_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('GradTest_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('GradTest_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GradTest_File';
            ErrDisp(err);
            return
        else
            SCRPTGBL.('GradTest_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GradTest_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
GRD.method = SCRPTGBL.CurrentTree.Func;
GRD0 = SCRPTGBL.('GradTest_File_Data').GRD;
GRD.goffset = str2double(SCRPTGBL.CurrentTree.('Goffset'));
GRD.wrtgradfunc = SCRPTGBL.CurrentTree.('WrtGradfunc').Func; 
GRD.wrtparamfunc = SCRPTGBL.CurrentTree.('WrtParamfunc').Func; 

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
WRTGipt = SCRPTGBL.CurrentTree.('WrtGradfunc');
if isfield(SCRPTGBL,('WrtGradfunc_Data'))
    WRTGipt.WrtGradfunc_Data = SCRPTGBL.WrtGradfunc_Data;
end
WRTPipt = SCRPTGBL.CurrentTree.('WrtParamfunc');
if isfield(SCRPTGBL,('WrtParamfunc_Data'))
    WRTPipt.WrtParamfunc_Data = SCRPTGBL.WrtParamfunc_Data;
end

%------------------------------------------
% Get Write Parameter Function Info
%------------------------------------------
func = str2func(GRD.wrtgradfunc);           
[SCRPTipt,WRTG,err] = func(SCRPTipt,WRTGipt);
if err.flag
    return
end
func = str2func(GRD.wrtparamfunc);           
[SCRPTipt,WRTP,err] = func(SCRPTipt,WRTPipt);
if err.flag
    return
end

%---------------------------------------------
% Create Gradients
%---------------------------------------------
func = str2func([GRD.method,'_Func']);
INPUT.GRD0 = GRD0;
INPUT.WRTG = WRTG;
INPUT.WRTP = WRTP;
[GRD,err] = func(GRD,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Gradient File:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('GradTest_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {GRD};
SCRPTGBL.RWSUI.SaveVariableNames = {'GRD'};

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;

SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};
