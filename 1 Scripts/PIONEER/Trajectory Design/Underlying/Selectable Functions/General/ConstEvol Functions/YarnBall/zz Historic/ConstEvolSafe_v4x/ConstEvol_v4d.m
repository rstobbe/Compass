%==================================================
%  (v4d)
%       - Includes SAFE modeling
%==================================================

function [SCRPTipt,CACCM,err] = ConstEvol_v4d(SCRPTipt,CACCMipt)

Status2('done','Get Acceleration Constraint info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACCM.method = CACCMipt.Func;   
CACCM.gacc = str2double(CACCMipt.('Gacc'));
CACCM.gvelprof = CACCMipt.('GvelProf').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GVPipt = CACCMipt.('GvelProf');
if isfield(CACCMipt,('GvelProf_Data'))
    GVPipt.GvelProf_Data = CACCMipt.GvelProf_Data;
end

%------------------------------------------
% Get RadEvfunc Info
%------------------------------------------
func = str2func(CACCM.gvelprof);           
[SCRPTipt,GVP,err] = func(SCRPTipt,GVPipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
CACCM.GVP = GVP;

Status2('done','',3);