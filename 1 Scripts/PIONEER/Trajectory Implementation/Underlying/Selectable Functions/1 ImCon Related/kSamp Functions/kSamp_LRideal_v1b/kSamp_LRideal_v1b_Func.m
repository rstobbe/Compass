%=====================================================
%   
%=====================================================

function [KSMP,err] = kSamp_LRideal_v1b_Func(KSMP,INPUT)

Status2('busy','Sample k-Space',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJimp = INPUT.PROJimp;
qTrecon = INPUT.qTrecon;
Grecon = INPUT.Grecon;
TSMP = INPUT.TSMP;
clear INPUT

%---------------------------------------------
% Sample to very end
%---------------------------------------------
Samp0 = (TSMP.sampstart:TSMP.dwell:qTrecon(end));    
[Kmat0,Kend] = ReSampleKSpace_v7a(Grecon,qTrecon-qTrecon(1),Samp0-qTrecon(1),PROJimp.gamma);                % negative time fixup

%---------------------------------------------
% Return
%---------------------------------------------
KSMP.Samp0 = Samp0;  
KSMP.Kmat0 = Kmat0;    
KSMP.SampRecon = Samp0;  
KSMP.KmatRecon = Kmat0;   
KSMP.Kend = Kend;   
KSMP.nproRecon = length(Samp0);

Status2('done','',2);
Status2('done','',3);
