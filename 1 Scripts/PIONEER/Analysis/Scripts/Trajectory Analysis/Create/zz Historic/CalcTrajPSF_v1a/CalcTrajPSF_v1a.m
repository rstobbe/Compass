%=====================================================
% (v1a) 
%        
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CalcTrajPSF_v1a(SCRPTipt,SCRPTGBL)

Status('busy','PSF Calculation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('PSF_Name',{SCRPTipt.labelstr});
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
ANLZ.susbuildfunc = SCRPTGBL.CurrentTree.('SUSBuildfunc').Func; 

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
SUSSipt = SCRPTGBL.CurrentTree.('SUSBuildfunc');
if isfield(SCRPTGBL,('SUSBuildfunc_Data'))
    SUSSipt.SUSBuildfunc_Data = SCRPTGBL.SUSBuildfunc_Data;
end

%------------------------------------------
% Get TF Build Function Info
%------------------------------------------
func = str2func(ANLZ.tfbuildfunc);           
[SCRPTipt,TFS,err] = func(SCRPTipt,TFSipt);
if err.flag
    return
end

%------------------------------------------
% Get SUS Build Function Info
%------------------------------------------
func = str2func(ANLZ.susbuildfunc);           
[SCRPTipt,SUS,err] = func(SCRPTipt,SUSSipt);
if err.flag
    return
end

%---------------------------------------------
% Perform Analysis
%---------------------------------------------
func = str2func([ANLZ.method,'_Func']);
INPUT.IMP = IMP;
INPUT.TFS = TFS;
INPUT.SUS = SUS;
[ANLZ,err] = func(ANLZ,INPUT);
if err.flag
    return
end
clear INPUT;

PSF = ANLZ;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
%ANLZ.ExpDisp = PanelStruct2Text(ANLZ.PanelOutput);
%global FIGOBJS
%FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = DES.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name0 = '';
if isfield(IMP,'name')
    name0 = IMP.name(5:end);
end
name = inputdlg('Name PSF:','Name PSF',1,{['PSF_',name0]});
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.SaveVariables = {PSF};
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end
PSF.name = name;
PSF.path = IMP.path;
PSF.type = 'Data';   
PSF.structname = 'PSF';

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {PSF};
SCRPTGBL.RWSUI.SaveVariableNames = {'PSF'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = PSF.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
