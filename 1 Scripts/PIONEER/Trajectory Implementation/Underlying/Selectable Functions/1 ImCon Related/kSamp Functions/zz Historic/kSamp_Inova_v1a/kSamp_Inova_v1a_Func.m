%=====================================================
% 
%=====================================================

function [KSMP,err] = kSamp_Inova_v1a_Func(KSMP,INPUT)

Status2('busy','Sample k-Space',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJimp = INPUT.PROJimp;
IMETH = INPUT.IMETH;
TSMP = INPUT.TSMP;
T = INPUT.T;
G = INPUT.G;
clear INPUT;

%----------------------------------------------------
% Resample k-Space
%----------------------------------------------------
PROJimp.sampstart = TSMP.sampstart;
Status('busy','Resample k-Space');
zerotime = IMETH.qTscnr(length(IMETH.qTscnr));
[samp,Kmat,Kend] = ReSampleKSpace_v6c(PROJimp,G,T,zerotime);      

KSMP.tatr = (PROJimp.sampstart:PROJimp.dwell:PROJimp.tro);  

KSMP.samp = samp;
KSMP.Kmat = Kmat;
KSMP.Kend = Kend;

Status2('done','',2);
Status2('done','',3);


    
    