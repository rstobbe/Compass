%=====================================================
% (v1a) 
%       
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = MEOVatMeNeiSnrArr_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Calculate MEOV @ Minimum Edge and rNEI across SNR Array');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Analysis_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'TF_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('TF_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('TF_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load TF_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load TF_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('TF_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load TF_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'PSD_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('PSD_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('PSD_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSD_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load PSD_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('PSD_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load PSD_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
ANLZ.method = SCRPTGBL.CurrentTree.Func;
ANLZ.zf = str2double(SCRPTGBL.CurrentTree.('ZeroFill'));
ANLZ.me = str2double(SCRPTGBL.CurrentTree.('ME'));
ANLZ.rnei = str2double(SCRPTGBL.CurrentTree.('rNEI'));
ANLZ.snr0 = str2double(SCRPTGBL.CurrentTree.('SNR0'));
ANLZ.solpnts = str2double(SCRPTGBL.CurrentTree.('SolPnts'));
ANLZ.pointsrcfind = SCRPTGBL.CurrentTree.('PntSrcFind');
ANLZ.objectfunc = SCRPTGBL.CurrentTree.('OBfunc').Func; 

%---------------------------------------------
% Load Implementation and Kernel
%---------------------------------------------
TF = SCRPTGBL.TF_File_Data.TF;
PSD = SCRPTGBL.PSD_File_Data.PSD;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
OBipt = SCRPTGBL.CurrentTree.('OBfunc');
if isfield(SCRPTGBL,('OBfunc_Data'))
    OBipt.Objectfunc_Data = SCRPTGBL.Objectfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(ANLZ.objectfunc);           
[SCRPTipt,OB,err] = func(SCRPTipt,OBipt);
if err.flag
    return
end

%---------------------------------------------
% Perform Analysis
%---------------------------------------------
func = str2func([ANLZ.method,'_Func']);
INPUT.TF = TF;
INPUT.PSD = PSD;
INPUT.OB = OB;
[ANLZ,err] = func(ANLZ,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
ANLZ.ExpDisp = PanelStruct2Text(ANLZ.PanelOutput);
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = ANLZ.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name = ['MEOV_',TF.name(5:end)];

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Analysis:','Name',1,{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
ANLZ.name = name{1};
ANLZ.structname = 'ANLZ';

SCRPTipt(indnum).entrystr = ANLZ.name;
SCRPTGBL.RWSUI.SaveVariables = ANLZ;
SCRPTGBL.RWSUI.SaveVariableNames = 'ANLZ';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = ANLZ.name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = ANLZ.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
