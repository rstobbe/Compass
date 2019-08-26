%=========================================================
% 
%=========================================================

function [PROJimp,TGSR,GSR,IMPipt,err] = TPI_SRIlinear_v1a(PROJimp,qT,G,IMPipt,err)

TGSR = [];
GSR = [];
PROJimp.SRISR = str2double(IMPipt(strcmp('SRISR (mT/m/ms)',{IMPipt.labelstr})).entrystr);

%--------------------------
SR.step = 0.004;
SR.t = (0:0.004:0.6);
SR.T = 0.6;
SR.N = length(SR.t);
SR.Gmin = 0.5;
SR.Ginc = 0.125;
SR.Gmax = 60;
Garr = (SR.Gmin:SR.Ginc:SR.Gmax);
rise = PROJimp.SRISR*(SR.t+SR.step/2);
SR.x = ones(length(Garr),SR.N);
SR.y = ones(length(Garr),SR.N);
SR.z = ones(length(Garr),SR.N);
for n = (1:length(Garr));
    Gtemp = ones(1,SR.N);
    Gtemp(rise<Garr(n)) = rise(rise<Garr(n))/Garr(n);
    SR.x(n,:) = Gtemp;
    SR.y(n,:) = Gtemp;
    SR.z(n,:) = Gtemp;
end
%--------------------------

MaxGaccomSRIiseg = PROJimp.iseg*PROJimp.SRISR;
initsteps = G(:,1,:);
maxinitG = max(initsteps(:));
if maxinitG > MaxGaccomSRIiseg
    if length(err) ~= 1
        n = length(err)+1;
    else
        n = 1;
    end
    err(n).flag = 1;
    err(n).msg = 'iGseg too short for step response and Gmaxinit';
    return;
end

MaxGaccomSRItwseg = PROJimp.twseg*PROJimp.SRISR;
m = (3:length(qT)-1);
twsteps = G(:,m,:)-G(:,m-1,:);
maxtwG = max(twsteps(:));
if maxtwG > MaxGaccomSRItwseg
    if length(err) ~= 1
        n = length(err)+1;
    else
        n = 1;
    end
    err(n).flag = 1;
    err(n).msg = 'twGseg too short for step response and Gmaxtwstep';
    return;
end

[TGSR,Tsegs] = StepResp_Timing(qT,SR);
GSR = zeros(PROJimp.nproj,length(TGSR),3);    
for n = 1:PROJimp.nproj
    if strcmp(PROJimp.orient,'Axial');    
        [GSR(n,:,1)] = StepResp_Grad('x',G(n,:,1),Tsegs,Garr,SR);
        [GSR(n,:,2)] = StepResp_Grad('y',G(n,:,2),Tsegs,Garr,SR);
        [GSR(n,:,3)] = StepResp_Grad('z',G(n,:,3),Tsegs,Garr,SR);
    elseif strcmp(PROJimp.orient,'Coronal');
        [GSR(n,:,1)] = StepResp_Grad('x',G(n,:,1),Tsegs,Garr,SR);
        [GSR(n,:,2)] = StepResp_Grad('z',G(n,:,2),Tsegs,Garr,SR);
        [GSR(n,:,3)] = StepResp_Grad('y',G(n,:,3),Tsegs,Garr,SR);
    elseif strcmp(PROJimp.orient,'Sagittal');    
        [GSR(n,:,1)] = StepResp_Grad('z',G(n,:,1),Tsegs,Garr,SR);
        [GSR(n,:,2)] = StepResp_Grad('y',G(n,:,2),Tsegs,Garr,SR);
        [GSR(n,:,3)] = StepResp_Grad('x',G(n,:,3),Tsegs,Garr,SR);
    end
    Status('busy',['Add Gradient Step-Response Projection Number: ',num2str(n)]);    
end


%----------------------------------------------
%
%----------------------------------------------
function [TGSR,Tsegs] = StepResp_Timing(qT,SR)
M = length(qT);
TGSR = [];
for m = 2:M                             
    gseg = qT(m) - qT(m-1);
    ts = SR.t(SR.t<gseg);
    TGSR(length(TGSR)+1:length(TGSR)+length(ts)) = qT(m-1)+ts;
    Tsegs(m-1) = length(ts);
end
TGSR(length(TGSR)+1) = qT(M);


%----------------------------------------------
%
%----------------------------------------------
function [GSR] = StepResp_Grad(Orth,G,Tsegs,Garr,SR)
if strcmp(Orth,'x')
    R = SR.x;
elseif strcmp(Orth,'y')    
    R = SR.y;
elseif strcmp(Orth,'z')    
    R = SR.z;  
end
GSR = [];
if G(1) == 0
    rise = zeros(1,Tsegs(1));
else
    ind = find(Garr < (abs(G(1))+SR.Ginc/2),1,'last');
    if isempty(ind)
        ind = 1;
    end
    rise = G(1)*R(ind,1:Tsegs(1));
end
GSR(length(GSR)+1:length(GSR)+Tsegs(1)) = rise;
for m = 2:length(G)                             
    if G(m-1) == G(m)
        rise = G(m-1)*ones(1,Tsegs(m));
    else
        ind = find(Garr < (abs(G(m)-G(m-1))+SR.Ginc/2),1,'last');
        if isempty(ind)
            ind = 1;
        end
        rise = G(m-1) + (G(m)-G(m-1))*R(ind,1:Tsegs(m));
    end
    GSR(length(GSR)+1:length(GSR)+Tsegs(m)) = rise;
end
GSR(length(GSR)+1) = G(length(G));







        
        


