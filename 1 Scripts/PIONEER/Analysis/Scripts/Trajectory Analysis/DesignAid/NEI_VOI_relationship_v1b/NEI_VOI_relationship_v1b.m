%=====================================================
% (v1b) 
%        - use 'common' CVcalc
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = NEI_VOI_relationship_v1b(SCRPTipt,SCRPTGBL)

Status('busy','NEI - VOI relationship');
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
ANLZ.snr = str2double(SCRPTGBL.CurrentTree.('SNR'));
ANLZ.zf = str2double(SCRPTGBL.CurrentTree.('ZeroFill'));
ANLZ.objectfunc = SCRPTGBL.CurrentTree.('OBfunc').Func; 

%---------------------------------------------
% Load Implementation
%---------------------------------------------
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
name = 'NEIarr_';

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
