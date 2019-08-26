%=========================================================
% 
%=========================================================

function [RLXANLZ,err] = T2RlxAnlzNa_v1a_Func(RLXANLZ,INPUT)

Status('busy','T2 Relaxometry Study Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get INput
%---------------------------------------------
RLXDES = INPUT.RLXDES;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------
T2s = RLXANLZ.T2s;
N = RLXANLZ.N;
SMNR = (RLXANLZ.smnrmin:RLXANLZ.smnrstep:RLXANLZ.smnrmax);
T2f = (RLXANLZ.T2fmin:RLXANLZ.T2fstep:RLXANLZ.T2fmax);
nTests = RLXANLZ.MonteCarlo;

%---------------------------------------------
% TEarr
%---------------------------------------------
if isfield(RLXDES,'N');
    TEarr = RLXDES.TEarr{RLXDES.N == N};
else
    TEarr = RLXDES.TEarr;
end

%---------------------------------------------
% Regression 
%---------------------------------------------
T2fout = zeros(length(T2f),length(SMNR),nTests);
T2sout = zeros(length(T2f),length(SMNR),nTests);
for n = 1:length(T2f)
    Sig = 0.6*exp(-TEarr/T2f(n)) + 0.4*exp(-TEarr/T2s);
    figure(1000);
    plot(TEarr,Sig,'k*-');
    Est = [T2f(n) T2s];
    for m = 1:length(SMNR);
        NoisySig = zeros(length(Sig),nTests);
        for p = 1:nTests
            NoisySig(:,p) = Sig + (1/SMNR(m))*randn(size(Sig));
            %plot(TEarr,NoisySig(:,p));
            beta = nlinfit(TEarr,squeeze(NoisySig(:,p))',@Reg_biexT2,Est);
            T2fout(n,m,p) = beta(1); 
            T2sout(n,m,p) = beta(2);
        end
        %stdtest = std(NoisySig,0,2)
        Status2('busy',['SMNR: ',num2str(SMNR(m)),'  T2f: ',num2str(T2f(n))],2);
    end
end

%--------------------------------------------
% Return
%--------------------------------------------
RLXANLZ.SMNR = SMNR;
RLXANLZ.T2f = T2f;
RLXANLZ.T2s = T2s;
RLXANLZ.nTests = nTests;
RLXANLZ.T2fout = T2fout;
RLXANLZ.T2sout = T2sout;
RLXANLZ.TEarr = TEarr;

Status2('done','',2);
Status2('done','',3);


