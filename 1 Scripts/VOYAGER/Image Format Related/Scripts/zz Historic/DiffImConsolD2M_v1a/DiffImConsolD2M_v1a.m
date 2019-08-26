%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = DiffImConsolD2M_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Consolidate Dicom into Matrix');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
SCRPTipt(strcmp('Image_Name',{SCRPTipt.labelstr})).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
CSD.script = SCRPTGBL.CurrentTree.Func;
CSD.average = SCRPTGBL.CurrentTree.('Average');
CSD.loadfunc = SCRPTGBL.CurrentTree.('LoadDWIDicom').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IMATipt = SCRPTGBL.CurrentTree.('LoadDWIDicom');
if isfield(SCRPTGBL,('LoadDWIDicom_Data'))
    IMATipt.LoadDWIDicom_Data = SCRPTGBL.LoadDWIDicom_Data;
end

%------------------------------------------
% Get Dicom Loading Function Info
%------------------------------------------
func = str2func(CSD.loadfunc);           
[SCRPTipt,IMAT,err] = func(SCRPTipt,IMATipt);
if err.flag
    return
end

%---------------------------------------------
% Consolidate Dicom into Matrix
%---------------------------------------------
func = str2func([CSD.script,'_Func']);
INPUT.CSD = CSD;
INPUT.IMAT = IMAT;
[OUTPUT,err] = func(INPUT);
if err.flag
    return
end

%--------------------------------------------
% Saved Structure
%--------------------------------------------
IMAT = OUTPUT.IMAT;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Image_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {IMAT};
SCRPTGBL.RWSUI.SaveVariableNames = 'IMAT';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'IMAT';


Status('done','');
Status2('done','',2);
Status2('done','',3);




