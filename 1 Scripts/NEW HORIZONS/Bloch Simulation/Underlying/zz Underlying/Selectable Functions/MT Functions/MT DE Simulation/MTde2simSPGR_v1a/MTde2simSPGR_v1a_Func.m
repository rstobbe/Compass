%=========================================================
% 
%=========================================================

function [MTSPGR,err] = MTde2simSPGR_v1a_Func(MTSPGR,INPUT)

Status2('busy','Simulate SPGR sequence (include MT)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
BLOCH = MTSPGR.BLOCH;
SeqPrms = INPUT.SeqPrms;
NMRPrms = INPUT.NMRPrms;
SimPrms = INPUT.SimPrms;
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
if SimPrms.ExPulseN < 3 || SimPrms.RecN < 3
    err.flag = 1;
    err.msg = 'Number of solution points cannot be less than 3';
    return
end

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
RECINPUT.woff = 0;              % future modify to include off-resonance                             
func = str2func([MTSPGR.coupledblochfunc,'_DE']);
recfunc = @(t,M) func(t,M,BLOCH,RECINPUT);
trec = linspace(0,SeqPrms.TR-SeqPrms.exrftau,SimPrms.RecN);

%---------------------------------------------
% Initial Conditions 
%---------------------------------------------
MzA0 = 1;
MzB0 = NMRPrms.relM0B;
MxA0 = 0;
MyA0 = 0;
MxB0 = 0;
MyB0 = 0;
T = 0;

%---------------------------------------------
% Solve Sequence SS
%---------------------------------------------
M0 = [MzA0 MzB0 MxA0 MyA0 MxB0 MyB0];
Marr = M0;
for n = 1:SeqPrms.NSteady  
    [t,M] = ode45(expulsefunc,texpulse,M0);
    if strcmp(SimPrms.RecordSS,'Yes')
        Marr = [Marr;M];
        T = [T;t+T(length(T))];
    end
    if n == SeqPrms.NSteady
        MarrLast = M;
        TLast = t;
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
        MAx = Mte(3,3);
        MAy = Mte(3,4);
        MAxy = abs(MAx + 1i*MAy);
        MBx = Mte(3,5);
        MBy = Mte(3,6);
        MBxy = abs(MBx + 1i*MBy);
    end     
    M0 = M(SimPrms.RecN,:);
    M0(3) = 0;                  % simple spoiling for now
    M0(4) = 0;
    M0(5) = 0;                  % simple spoiling for now
    M0(6) = 0;
    n
end

%---------------------------------------------
% Return
%---------------------------------------------
MTSPGR.T = T;
MTSPGR.Marr = Marr;
MTSPGR.TLast = TLast;
MTSPGR.MarrLast = MarrLast;
MTSPGR.Mxy = MAxy + MBxy;
MTSPGR.MAxy = MAxy;
MTSPGR.MBxy = MBxy


Status2('done','',2);
Status2('done','',3);

