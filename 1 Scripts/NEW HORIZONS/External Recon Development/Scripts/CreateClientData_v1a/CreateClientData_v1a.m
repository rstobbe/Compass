%=========================================================
% (v1ea) 
%       - 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CreateClientData_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Write ');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('ClientDat_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'Wrt_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Wrt_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Wrt_File').Struct.selectedfile;
        if ~contains(file,'.mat')
            file = [file,'.mat'];
        end
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Wrt_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load Trajectory Implementation');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Wrt_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Wrt_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
WRT.method = SCRPTGBL.CurrentTree.Func;
WRT.loadfunc = SCRPTGBL.CurrentTree.LoadRawDatafunc.Func;
WRT.kernfunc = SCRPTGBL.CurrentTree.LoadConvKernfunc.Func;
WRT.buildfunc = SCRPTGBL.CurrentTree.BuildClientDatafunc.Func;

%---------------------------------------------
% Load Implementation
%---------------------------------------------
IMP = SCRPTGBL.Wrt_File_Data.IMP;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('LoadRawDatafunc');
if isfield(SCRPTGBL,('LoadRawDatafunc_Data'))
    LOADipt.LoadRawDatafunc_Data = SCRPTGBL.LoadRawDatafunc_Data;
end
KERNipt = SCRPTGBL.CurrentTree.('LoadConvKernfunc');
if isfield(SCRPTGBL,('LoadConvKernfunc_Data'))
    KERNipt.LoadConvKernfunc_Data = SCRPTGBL.LoadConvKernfunc_Data;
end
BUILDipt = SCRPTGBL.CurrentTree.('BuildClientDatafunc');
if isfield(SCRPTGBL,('BuildClientDatafunc_Data'))
    BUILDipt.BuildClientDatafunc_Data = SCRPTGBL.BuildClientDatafunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(WRT.loadfunc);           
[SCRPTipt,LOAD,err] = func(SCRPTipt,LOADipt);
if err.flag
    return
end
func = str2func(WRT.kernfunc);           
[SCRPTipt,KERN,err] = func(SCRPTipt,KERNipt);
if err.flag
    return
end
func = str2func(WRT.buildfunc);           
[SCRPTipt,BUILD,err] = func(SCRPTipt,BUILDipt);
if err.flag
    return
end

%---------------------------------------------
% Write
%---------------------------------------------
func = str2func([WRT.method,'_Func']);
INPUT.LOAD = LOAD;
INPUT.KERN = KERN;
INPUT.BUILD = BUILD;
INPUT.IMP = IMP;
[WRT,err] = func(INPUT,WRT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
WRT.ExpDisp = PanelStruct2Text(WRT.PanelOutput);
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = WRT.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name System Writing:','System Writing',1,{WRT.name});
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
WRT.name = name{1};

SCRPTipt(indnum).entrystr = WRT.name;
SCRPTGBL.RWSUI.SaveVariables = WRT;
SCRPTGBL.RWSUI.SaveVariableNames = 'IMP';            
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = WRT.name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = WRT.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

