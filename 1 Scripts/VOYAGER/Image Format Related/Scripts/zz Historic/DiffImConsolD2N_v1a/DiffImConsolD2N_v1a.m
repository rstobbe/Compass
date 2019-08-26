%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = DiffImConsolD2N_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Consolidate Dicom into Nifti');
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
% Load Dicom Images Into Matrix
%---------------------------------------------
func = str2func([CSD.loadfunc,'_Func']);
INPUT = struct();
[IMAT,err] = func(IMAT,INPUT);
if err.flag
    return
end





