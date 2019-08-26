%=========================================================
% (Calc2)
%       - direction (and average) averaging
% (v1d) 
%       - add absolution value averaging compensation
%=========================================================

function [SCRPTipt,CALC,err] = Calc2KurtIM_v1d(SCRPTipt,CALCipt)

Status2('done','Get Kurtosis Calulation Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
CALC = struct();

%---------------------------------------------
% Return Input
%---------------------------------------------
CALC.corrfunc = CALCipt.Corrfunc.Func;
CALC.constrain = CALCipt.('Constrain');
CALC.minvalonb0 = str2double(CALCipt.('MinVal_b0'));

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = CALCipt.Struct.labelstr;
CORRipt = CALCipt.('Corrfunc');
if isfield(CALC,([CallingFunction,'_Data']))
    if isfield(CALC.([CallingFunction,'_Data']),('Corrfunc_Data'))
        CORRipt.Corrfunc_Data = CALCipt.([CallingFunction,'_Data']).Corrfunc_Data;
    end
end

%------------------------------------------
% Get Calculate Function Info
%------------------------------------------
func = str2func(CALC.corrfunc);           
[SCRPTipt,CORR,err] = func(SCRPTipt,CORRipt);
if err.flag
    return
end

CALC.CORR = CORR;

Status2('done','',2);
Status2('done','',3);
