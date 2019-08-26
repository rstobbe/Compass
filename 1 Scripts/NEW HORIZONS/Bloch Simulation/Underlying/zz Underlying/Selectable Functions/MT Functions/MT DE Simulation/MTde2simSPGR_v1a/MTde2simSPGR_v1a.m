%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,MTSPGR,err] = MTde2simSPGR_v1a(SCRPTipt,MTSPGRipt)

Status2('busy','Simulate MT with SPGR sequence',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
MTSPGR.method = MTSPGRipt.Func; 
MTSPGR.coupledblochfunc = MTSPGRipt.('CoupledBlochfunc').Func; 

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = MTSPGRipt.Struct.labelstr;
BLOCHipt = MTSPGRipt.('CoupledBlochfunc');
if isfield(MTSPGRipt,([CallingLabel,'_Data']))
    if isfield(MTSPGRipt.([CallingLabel,'_Data']),'CoupledBlochfunc_Data')
        BLOCHipt.('CoupledBlochfunc_Data') = MTSPGRipt.([CallingLabel,'_Data']).('CoupledBlochfunc_Data');
    end
end

%------------------------------------------
% Get Bloch Info
%------------------------------------------
func = str2func(MTSPGR.coupledblochfunc);           
[SCRPTipt,BLOCH,err] = func(SCRPTipt,BLOCHipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
MTSPGR.BLOCH = BLOCH;

Status2('done','',2);
Status2('done','',3);
