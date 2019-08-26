%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,RADEV,err] = RadDes_TpiSampDensDesign_v1a(SCRPTipt,RADEVipt)

Status2('busy','Get Radial Evolution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
RADEV.method = RADEVipt.Func;   
RADEV.gamfunc = RADEVipt.('Gamfunc').Func;
RADEV.p = str2double(RADEVipt.('pVal'));

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GAMipt = RADEVipt.('Gamfunc');
if isfield(RADEVipt,('Gamfunc_Data'))
    GAMipt.Gamfunc_Data = RADEVipt.Gamfunc_Data;
end

%------------------------------------------
% Get Elip Function Info
%------------------------------------------
func = str2func(RADEV.gamfunc);           
[SCRPTipt,GAM,err] = func(SCRPTipt,GAMipt);
if err.flag
    return
end

RADEV.GAM = GAM;

Status2('done','',2);