%=========================================================
% 
%=========================================================

function [MTSPGR,err] = MTdesimSPGRwSatPulse_v1a_Func(MTSPGR,INPUT)

Status2('busy','Simulate SPGR sequence (include MT)',2);
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
SATsatratefunc = @(w1) w1^2*pi*lineshapeval;

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
RLXsatratefunc = @(w1) 0;

%---------------------------------------------
% Setup DE for Sat Pulse
%---------------------------------------------
SATINPUT.M0B = NMRPrms.relM0B;
SATINPUT.T1A = NMRPrms.T1A;
SATINPUT.T1B = NMRPrms.T1B;
SATINPUT.T2A = NMRPrms.T2A;
SATINPUT.T2B = NMRPrms.T2B;
SATINPUT.EXR = NMRPrms.ExchgRate;
SATINPUT.w1 = (SeqPrms.satrffa/360)*(1/SeqPrms.satrftau)*1000;
SATINPUT.woff = SeqPrms.satrfwoff;
SATINPUT.satratefunc = SATsatratefunc;
func = str2func([MTSPGR.coupledblochfunc,'_DE']);
satpulsefunc = @(t,M) func(t,M,BLOCH,SATINPUT);
tsatpulse = linspace(0,SeqPrms.satrftau,SimPrms.SatPulseN);

%---------------------------------------------
% Setup DE for Excitation Pulse
%---------------------------------------------
EXINPUT.M0B = NMRPrms.relM0B;
EXINPUT.T1A = NMRPrms.T1A;
EXINPUT.T1B = NMRPrms.T1B;
EXINPUT.T2A = NMRPrms.T2A;
EXINPUT.T2B = NMRPrms.T2B;
EXINPUT.EXR = NMRPrms.ExchgRate;
EXINPUT.w1 = (SeqPrms.exrffa/360)*(1/SeqPrms.exrftau)*1000;
EXINPUT.woff = SeqPrms.exrfwoff;
EXINPUT.satratefunc = EXsatratefunc;
func = str2func([MTSPGR.coupledblochfunc,'_DE']);
expulsefunc = @(t,M) func(t,M,BLOCH,EXINPUT);
texpulse = linspace(0,SeqPrms.exrftau,SimPrms.ExPulseN);

%---------------------------------------------
% Setup DE for Recovery
%---------------------------------------------
RECINPUT.M0B = NMRPrms.relM0B;
RECINPUT.T1A = NMRPrms.T1A;
RECINPUT.T1B = NMRPrms.T1B;
RECINPUT.T2A = NMRPrms.T2A;
RECINPUT.T2B = NMRPrms.T2B;
RECINPUT.EXR = NMRPrms.ExchgRate;
RECINPUT.w1 = 0;
RECINPUT.woff = 0;
RECINPUT.satratefunc = RLXsatratefunc;
func = str2func([MTSPGR.coupledblochfunc,'_DE']);
recfunc = @(t,M) func(t,M,BLOCH,RECINPUT);
trec = linspace(0,SeqPrms.TR-SeqPrms.satrftau-SeqPrms.exrftau,SimPrms.RecN);

%---------------------------------------------
% Initial Conditions 
%---------------------------------------------
MzA0 = 1;
MzB0 = NMRPrms.relM0B;
Mx0 = 0;
My0 = 0;
T = 0;

%---------------------------------------------
% Solve Sequence SS
%---------------------------------------------
M0 = [MzA0 MzB0 Mx0 My0];
Marr = M0;
for n = 1:SeqPrms.NSteady
    [t,M] = ode45(satpulsefunc,tsatpulse,M0);
    if strcmp(SimPrms.RecordSS,'Yes')
        Marr = [Marr;M];
        T = [T;t+T(length(T))];
    end
    if n == SeqPrms.NSteady
        MarrLast = M;
        TLast = t;
    end    
    M0 = M(SimPrms.SatPulseN,:);
    
    [t,M] = ode45(expulsefunc,texpulse,M0);
    if strcmp(SimPrms.RecordSS,'Yes')
        Marr = [Marr;M];
        T = [T;t+T(length(T))];
    end
    if n == SeqPrms.NSteady
        MarrLast = [MarrLast;M];
        TLast = [TLast;t+TLast(length(TLast))];
    end      
    M0 = M(SimPrms.ExPulseN,:);
    
    [t,M] = ode45(recfunc,trec,M0); 
    if strcmp(SimPrms.RecordSS,'Yes')
        Marr = [Marr;M];
        T = [T;t+T(length(T))];
    end
    if n == SeqPrms.NSteady
        MarrLast = [MarrLast;M];
        TLast = [TLast;t+TLast(length(TLast))];
        tesolve = linspace(0,SeqPrms.TE-(SeqPrms.exrftau/2),3);
        [tte,Mte] = ode45(recfunc,tesolve,M0); 
        Mx = Mte(3,3);
        My = Mte(3,4);
        Mxy = abs(Mx + 1i*My);
    end     
    M0 = M(SimPrms.RecN,:);
    M0(3) = 0;                  % simple spoiling for now
    M0(4) = 0;
end

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

