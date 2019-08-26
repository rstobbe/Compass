%=========================================================
% 
%=========================================================

function [MTSPGR,err] = MTsimSPGRalg_v1a_Func(MTSPGR,INPUT)

Status2('busy','MT Simulation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
LINEVAL = MTSPGR.LINEVAL;
BLOCH = MTSPGR.BLOCH;
SeqPrms = INPUT.SeqPrms;
NMRPrms = INPUT.NMRPrms;
SimPrms = INPUT.SimPrms;
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
if SimPrms.SatPulseN < 3 || SimPrms.ExPulseN < 3 || SimPrms.RecN < 3
    err.flag = 1;
    err.msg = 'Number of solution points cannot be less than 3';
    return
end

%---------------------------------------------
% Build MT Saturation Rate Function
%---------------------------------------------
func = str2func([MTSPGR.linevalfunc,'_Func']);  
INPUT.T2 = NMRPrms.T2B;
INPUT.woff = SeqPrms.satrfwoff;
[LINEVAL,err] = func(LINEVAL,INPUT);
if err.flag
    return
end
lineshapeval = LINEVAL.lineshapeval;
MTsatratefunc = @(w1) w1^2*pi*lineshapeval;

%---------------------------------------------
% Build Ex Saturation Rate Function
%---------------------------------------------
func = str2func([MTSPGR.linevalfunc,'_Func']);  
INPUT.T2 = NMRPrms.T2B;
INPUT.woff = SeqPrms.exrfwoff;
[LINEVAL,err] = func(LINEVAL,INPUT);
if err.flag
    return
end
lineshapeval = LINEVAL.lineshapeval;
EXsatratefunc = @(w1) w1^2*pi*lineshapeval;
RLXsatratefunc = EXsatratefunc;





%---------------------------------------------
% Equation (Cercignani - 2006)
%---------------------------------------------




%---------------------------------------------
% Return
%---------------------------------------------
MTSPGR.T = T;
MTSPGR.Marr = Marr;
MTSPGR.TLast = TLast;
MTSPGR.MarrLast = MarrLast;
MTSPGR.Mxy = Mxy;

Status2('done','',2);
Status2('done','',3);

