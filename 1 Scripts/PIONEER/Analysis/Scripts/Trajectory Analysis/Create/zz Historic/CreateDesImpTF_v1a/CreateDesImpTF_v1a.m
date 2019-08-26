%=====================================================
% (v1a) 
%      - as 'CreateDesImpPSF_v1a' (name change)
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateDesImpTF_v1a(SCRPTipt,SCRPTGBL)

Status('busy','TF Calculation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('TF_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Imp_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load Trajectory Implementation');
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
% Get Input
%---------------------------------------------
ANLZ.method = SCRPTGBL.CurrentTree.Func;
ANLZ.tfbuildfunc = SCRPTGBL.CurrentTree.('TFBuildfunc').Func; 

%---------------------------------------------
% Load Implementation and Kernel
%---------------------------------------------
IMP = SCRPTGBL.('Imp_File_Data').IMP;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
TFSipt = SCRPTGBL.CurrentTree.('TFBuildfunc');
if isfield(SCRPTGBL,('TFBuildfunc_Data'))
    TFSipt.TFBuildfunc_Data = SCRPTGBL.TFBuildfunc_Data;
end

%------------------------------------------
% Get TF Build Function Info
%------------------------------------------
func = str2func(ANLZ.tfbuildfunc);           
[SCRPTipt,TFS,err] = func(SCRPTipt,TFSipt);
if err.flag
    return
end

%---------------------------------------------
% Perform Analysis
%---------------------------------------------
func = str2func([ANLZ.method,'_Func']);
INPUT.IMP = IMP;
INPUT.TFS = TFS;
[ANLZ,err] = func(ANLZ,INPUT);
if err.flag
    return
end
clear INPUT;
TF = ANLZ;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
TF.ExpDisp = PanelStruct2Text(TF.PanelOutput);
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = TF.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name0 = '';
if isfield(IMP,'name')
    name0 = IMP.name(5:end);
end
name = inputdlg('Name TF:','Name TF',1,{['TF_',name0]});
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.SaveVariables = {TF};
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end
TF.name = name;
TF.path = IMP.path;
TF.type = 'Data';   
TF.structname = 'TF';

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = TF;
SCRPTGBL.RWSUI.SaveVariableNames = 'TF';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = TF.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
