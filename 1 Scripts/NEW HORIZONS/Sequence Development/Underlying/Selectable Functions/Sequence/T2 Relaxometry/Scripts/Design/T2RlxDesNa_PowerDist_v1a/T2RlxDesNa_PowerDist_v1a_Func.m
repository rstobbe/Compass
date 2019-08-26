%=========================================================
% 
%=========================================================

function [RLXDES,err] = T2RlxDesNa_PowerDist_v1a_Func(RLXDES,INPUT)

Status('busy','T2 Relaxometry Study Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Variables
%---------------------------------------------
T2s = RLXDES.T2s;
T2f = RLXDES.T2f;
TEmin = RLXDES.TEmin;
TEmax = RLXDES.TEmax;
Power = RLXDES.Power;
SMNR = (RLXDES.smnrmin:RLXDES.smnrstep:RLXDES.smnrmax);
N = (RLXDES.Nmin:RLXDES.Nmax);
nTests = RLXDES.MonteCarlo;

%---------------------------------------------
% Get Time Points
%---------------------------------------------
t = (TEmin:0.001:TEmax);
IntSig = -0.6*exp(-t/T2f)*(T2f^Power) - 0.4*exp(-t/T2s)*(T2s^Power);
figure(999);
plot(t,IntSig);

%---------------------------------------------
% Regression 
%---------------------------------------------
Est = [T2f T2s];
T2fout = zeros(length(N),length(SMNR),nTests);
T2sout = zeros(length(N),length(SMNR),nTests);
for n = 1:length(N)
    Varr = linspace(IntSig(1),IntSig(length(IntSig)),N(n));
    TEarr{n} = interp1(IntSig,t,Varr);
    Sig = 0.6*exp(-TEarr{n}/T2f) + 0.4*exp(-TEarr{n}/T2s);
    figure(1000);
    plot(TEarr{n},Sig,'k*-');
    for m = 1:length(SMNR);
        for p = 1:nTests
            NoisySig = Sig + (1/SMNR(m))*randn(size(Sig));
            beta = nlinfit(TEarr{n},NoisySig,@Reg_biexT2,Est);
            T2fout(n,m,p) = beta(1); 
            T2sout(n,m,p) = beta(2);
        end
        Status2('busy',['SMNR: ',num2str(SMNR(m)),'  N: ',num2str(N(n))],2);
    end
end

%--------------------------------------------
% Return
%--------------------------------------------
RLXDES.SMNR = SMNR;
RLXDES.N = N;
RLXDES.nTests = nTests;
RLXDES.T2fout = T2fout;
RLXDES.T2sout = T2sout;
RLXDES.TEarr = TEarr;

Status2('done','',2);
Status2('done','',3);


