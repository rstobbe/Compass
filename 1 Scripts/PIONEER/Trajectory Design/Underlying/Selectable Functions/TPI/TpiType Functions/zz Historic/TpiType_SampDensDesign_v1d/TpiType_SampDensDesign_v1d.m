%====================================================
% (v1d)
%   - Input Options - Formalize
%====================================================

function [SCRPTipt,TPIT,err] = TpiType_SampDensDesign_v1d(SCRPTipt,TPITipt)

Status2('busy','TPI Design',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
TPIT.method = TPITipt.Func;   
TPIT.gamfunc = TPITipt.('Gamfunc').Func;
TPIT.p = str2double(TPITipt.('pVal'));
TPIT.phiconstrain = str2double(TPITipt.('PhiConstrain'));

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GAMipt = TPITipt.('Gamfunc');
if isfield(TPITipt,('Gamfunc_Data'))
    GAMipt.Gamfunc_Data = TPITipt.Gamfunc_Data;
end

%------------------------------------------
% Get Elip Function Info
%------------------------------------------
func = str2func(TPIT.gamfunc);           
[SCRPTipt,GAM,err] = func(SCRPTipt,GAMipt);
if err.flag
    return
end

TPIT.GAM = GAM;

Status2('done','',2);