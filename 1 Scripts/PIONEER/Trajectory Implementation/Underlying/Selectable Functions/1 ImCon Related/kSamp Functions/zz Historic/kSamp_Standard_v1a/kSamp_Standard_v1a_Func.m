%=====================================================
%   
%=====================================================

function [KSMP,err] = kSamp_Standard_v1a_Func(KSMP,INPUT)

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

%---------------------------------------------
% Sample
%---------------------------------------------
if SYS.SampTransitTime == 0
    subsamp = PROJimp.dwell;
else
    subsamp = 0.001;
end
Samp0 = (0:subsamp:qTrecon(end));    
[Kmat0,Kend] = ReSampleKSpace_v7a(Grecon,qTrecon,Samp0,PROJimp.gamma);

TrajEndMag = TSMP.tro + SYSRESP.efftrajdel;
SampTrajEndMagRealTime = TrajEndMag + SYS.SampTransitTime;                                  % real time when end of trajectory sampled
EffWfmSampMag = (0:PROJimp.dwell:SampTrajEndMagRealTime+0.00001) - SYS.SampTransitTime;     % sampling timing on waveform   

KSMP.DiscardStart = 1;                                                                      % default = first point only
KSMP.DiscardEnd = TSMP.nproMag - length(EffWfmSampMag);

SampRecon = EffWfmSampMag(KSMP.DiscardStart+1:end);
if SampRecon(1) < 0 
    test0 = SampRecon(1)
    error
end
KSMP.StartTimeOnWfm = SampRecon(1);
KSMP.EndTimeOnWfm = SampRecon(end);
KSMP.nproRecon = length(SampRecon);

if SYS.SampTransitTime == 0
    ind1 = find(round(Samp0*1e6) == round(SampRecon(1)*1e6));
    ind2 = find(round(Samp0*1e6) == round(SampRecon(end)*1e6));
    if (isempty(ind1) || isempty(ind2))
        error
    end
    KmatRecon = Kmat0(:,ind1:ind2,:);
else
    [nproj,~,~] = size(Grecon);
    KmatRecon = zeros(nproj,KSMP.nproRecon,3);  
    for n = 1:nproj
        for d = 1:3
            %KmatRecon(n,:,d) = interp1(Samp0,Kmat0(n,:,d),SampRecon,'pchip');
            KmatRecon(n,:,d) = interp1(Samp0,Kmat0(n,:,d),SampRecon,'linear');
        end
    end
end

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
