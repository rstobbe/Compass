%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,TIMADJ,err] = TimingAdjust_SingleCast_v1a(SCRPTipt,TIMADJipt)

Status2('busy','Get Timing Adjust',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
TIMADJ.method = TIMADJipt.Func;   
TIMADJ.accconstfunc = TIMADJipt.('ConstEvolfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CACCipt = TIMADJipt.('ConstEvolfunc');
if isfield(TIMADJipt,('ConstEvolfunc_Data'))
    CACCipt.ConstEvolfunc_Data = TIMADJipt.ConstEvolfunc_Data;
end

%------------------------------------------
% Get Acceleration Constraint Info
%------------------------------------------
func = str2func(TIMADJ.accconstfunc);           
[SCRPTipt,CACC,err] = func(SCRPTipt,CACCipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
TIMADJ.CACC = CACC;

Status2('done','',3);