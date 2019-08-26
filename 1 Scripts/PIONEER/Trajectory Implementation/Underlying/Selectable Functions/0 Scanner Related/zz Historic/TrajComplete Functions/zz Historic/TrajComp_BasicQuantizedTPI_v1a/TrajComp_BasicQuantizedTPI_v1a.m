%====================================================
% (v1a)
%      
%====================================================


function [SCRPTipt,SYS,err] = SysImp_BasicQuantizedTPI_v1a(SCRPTipt,SYSipt) 

Status('busy','System Specific Implementation Aspects');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return 
%---------------------------------------------
SYS.method = SYSipt.Func;
SYS.gslew = str2double(SYSipt.('GSlew'));
SYS.tendfunc = SYSipt.('TEndfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = SYSipt.Struct.labelstr;
TENDipt = SYSipt.('TEndfunc');
if isfield(SYSipt,([CallingFunction,'_Data']))
    if isfield(SYSipt.SysRelatedfunc_Data,('TEndfunc_Data'))
        TENDipt.TENDfunc_Data = SYSipt.SysRelatedfunc_Data.TEndfunc_Data;
    end
end

%------------------------------------------
% Get TEND Function Info
%------------------------------------------
func = str2func(SYS.tendfunc);           
[SCRPTipt,TEND,err] = func(SCRPTipt,TENDipt);
if err.flag
    return
end

SYS.TEND = TEND;

Status2('done','',2);
Status2('done','',3);










