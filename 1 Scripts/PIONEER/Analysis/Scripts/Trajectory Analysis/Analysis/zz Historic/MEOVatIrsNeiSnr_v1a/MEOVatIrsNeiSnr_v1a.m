%=====================================================
% (v1a) 
%           
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = MEOVatIrsNeiSnr_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Calculate MEOV');
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
if not(isfield(SCRPTGBL,'PSF_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('PSF_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('PSF_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSF_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load PSF_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('PSF_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load PSF_File';
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
ANLZ.snr = str2double(SCRPTGBL.CurrentTree.('SNR'));
ANLZ.aveirs = str2double(SCRPTGBL.CurrentTree.('IRS'));
ANLZ.rnei = str2double(SCRPTGBL.CurrentTree.('rNEI'));
ANLZ.objectfunc = SCRPTGBL.CurrentTree.('OBfunc').Func; 

%---------------------------------------------
% Load Implementation and Kernel
%---------------------------------------------
PSF = SCRPTGBL.PSF_File_Data.PSF;
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
INPUT.PSF = PSF;
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
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = ANLZ.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name = 'MEOV_';

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

SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {ANLZ};
SCRPTGBL.RWSUI.SaveVariableNames = {'ANLZ'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
