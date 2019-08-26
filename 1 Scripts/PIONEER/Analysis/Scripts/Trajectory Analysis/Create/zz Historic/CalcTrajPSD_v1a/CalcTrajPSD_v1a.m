%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CalcTrajPSD_v1a(SCRPTipt,SCRPTGBL)

Status('busy','PSD Calculation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('PSD_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'ProjImp_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('ProjImp_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('ProjImp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load ProjImp_File';
            ErrDisp(err);
            return
        else
            load(file);
            SCRPTGBL.('ProjImp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load ProjImp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
CALCTOP.method = SCRPTGBL.CurrentScript.Func;
CALCTOP.calcpsdfunc = SCRPTGBL.CurrentTree.('CalcPSDfunc').Func;
IMP = SCRPTGBL.('ProjImp_File_Data').IMP;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CALCipt = SCRPTGBL.CurrentTree.('CalcPSDfunc');
if isfield(SCRPTGBL,('CalcPSDfunc_Data'))
    CALCipt.CalcPSDfunc_Data = SCRPTGBL.CalcPSDfunc_Data;
end

%------------------------------------------
% Get Calc Function Info
%------------------------------------------
func = str2func(CALCTOP.calcpsdfunc);           
[SCRPTipt,CALC,err] = func(SCRPTipt,CALCipt);
if err.flag
    return
end

%---------------------------------------------
% Calculate
%---------------------------------------------
func = str2func([CALCTOP.method,'_Func']);
INPUT.IMP = IMP;
INPUT.CALC = CALC;
[CALCTOP,err] = func(CALCTOP,INPUT);
if err.flag
    return
end

PSD = CALCTOP;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
%IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
%global FIGOBJS
%FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = IMG.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name0 = '';
if isfield(IMP,'name')
    name0 = IMP.name(5:end);
end
name = inputdlg('Name PSD:','Name PSD',1,{['PSD_',name0]});
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.SaveVariables = {PSD};
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end
PSD.name = name;
PSD.path = IMP.path;
PSD.type = 'Data';   
PSD.structname = 'PSD';

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {PSD};
SCRPTGBL.RWSUI.SaveVariableNames = {'PSD'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = PSD.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);


