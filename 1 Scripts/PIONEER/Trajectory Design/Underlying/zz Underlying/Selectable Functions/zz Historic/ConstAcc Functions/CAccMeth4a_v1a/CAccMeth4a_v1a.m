%==================================================
%  (v1a)
%       - start CAccMeth3b2D_v2b (utility for 2D and 3D)
%==================================================

function [SCRPTipt,CACCM,err] = CAccMeth4a_v1a(SCRPTipt,CACCMipt)

Status2('done','Get Acceleration Constraint info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACCM.method = CACCMipt.Func;   
CACCM.gacc = str2double(CACCMipt.('Gacc'));
CACCM.gvel = str2double(CACCMipt.('Gvel'));
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