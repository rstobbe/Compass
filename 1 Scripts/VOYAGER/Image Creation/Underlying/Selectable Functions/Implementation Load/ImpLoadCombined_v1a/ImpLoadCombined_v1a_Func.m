%=========================================================
% 
%=========================================================

function [IMPLD,err] = ImpLoadCombined_v1a_Func(IMPLD,INPUT)

Status2('busy','Load Implementation Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FID = INPUT.FID;
clear INPUT;

%--------------------------------------------
% Separate
%--------------------------------------------
IMP = IMPLD.IMP;
if isfield(IMP,'SDC')
    IMPLD.SDC = IMP.SDC;
    IMP = rmfield(IMP,'SDC');
elseif isfield(IMP,'SDCArr')
    IMPLD.SDC = IMP.SDCArr;
    IMP = rmfield(IMP,'SDCArr');
end
IMPLD.IMP = IMP;

Status2('done','',2);
Status2('done','',3);
