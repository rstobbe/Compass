%=====================================================
%   
%=====================================================

function [KSMP,err] = kSamp_WithDelay_v1b_Func(KSMP,INPUT)

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
SYSRESP = INPUT.SYSRESP;
SYS = INPUT.SYS;
clear INPUT

if SYS.SampTransitTime ~= 0
    error;                          % will require an update to add
end

%---------------------------------------------
% Sample to very end
%---------------------------------------------
Samp0 = (0:PROJimp.dwell:qTrecon(end)+KSMP.delay/1000) - KSMP.delay/1000;      
[Kmat0,Kend] = ReSampleKSpace_v7a(Grecon,qTrecon-qTrecon(1),Samp0-qTrecon(1),PROJimp.gamma);                % negative time fixup

%---------------------------------------------
% Sample to very end
%---------------------------------------------
TrajEndTime = TSMP.tro + SYSRESP.efftrajdel + KSMP.delay/1000;
SampTraj = (0:PROJimp.dwell:TrajEndTime+0.00001) - KSMP.delay/1000;                % sampling timing on waveform   

KSMP.DiscardStart = floor((SYSRESP.efftrajdel+(KSMP.delay/1000)+0.00001)/PROJimp.dwell)+1;                   
KSMP.DiscardEnd = TSMP.nproMag - length(SampTraj);                                 % last point on end of wfm
if KSMP.DiscardEnd < 0
    error;                                                                         % look at traj samp - sample more
end

SampRecon = SampTraj(KSMP.DiscardStart+1:end);
if SampRecon(1) < 0 
    test0 = SampRecon(1)
    error
end
KSMP.StartTimeOnWfm = SampRecon(1);
KSMP.EndTimeOnWfm = SampRecon(end);
KSMP.nproRecon = length(SampRecon);

ind1 = find(round(Samp0*1e6) == round(SampRecon(1)*1e6));
ind2 = find(round(Samp0*1e6) == round(SampRecon(end)*1e6));
if (isempty(ind1) || isempty(ind2))
    error
end
KmatRecon = Kmat0(:,ind1:ind2,:);


%---------------------------------------------
% Return
%---------------------------------------------
KSMP.Samp0 = Samp0;  
KSMP.Kmat0 = Kmat0;    
KSMP.SampRecon = SampRecon;  
KSMP.KmatRecon = KmatRecon;   
KSMP.Kend = Kend;   

Status2('done','',2);
Status2('done','',3);
