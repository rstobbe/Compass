%=========================================================
% 
%=========================================================

function E = qMTmap_v1a_Reg(V,INPUT)

%---------------------------------------------
% Get Input
%---------------------------------------------
Vals = INPUT.Vals;
SeqPrms = INPUT.SeqPrms;
SimPrms = INPUT.SimPrms;
MAP = INPUT.MAP;
SIM = MAP.SIM;
clear INPUT

%--------------------------------------------
% qMT
%--------------------------------------------
NMRPrms.relM0B = V(1);
NMRPrms.T1A = V(2);
NMRPrms.T1B = V(3);
NMRPrms.T2A = V(4);
NMRPrms.T2B = V(5);
NMRPrms.ExchgRate = V(6);
scale = V(7);
func = str2func([MAP.simfunc,'_Func']);  

for n = 1:length(Vals);
    Status2('busy',['Seq: ',num2str(n)],2);
    INPUT.NMRPrms = NMRPrms;
    INPUT.SeqPrms = SeqPrms(n);
    INPUT.SimPrms = SimPrms;
    tic 
    [SIM,err] = func(SIM,INPUT);
    if err.flag
        return
    end
    toc
    Mxy(n) = SIM.Mxy;
end

%--------------------------------------------
% Error Vector
%--------------------------------------------
scale*Mxy
Vals
E = scale*Mxy - Vals;

