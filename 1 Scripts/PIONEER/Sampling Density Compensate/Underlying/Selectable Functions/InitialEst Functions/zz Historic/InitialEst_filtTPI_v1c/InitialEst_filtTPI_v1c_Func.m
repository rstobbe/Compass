%====================================================
%
%====================================================

function [IE,err] = InitialEst_filtTPI_v1c_Func(IE,INPUT)

Status2('busy','Determine Initial Estimate',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.IMP.impPROJdgn;
PROJimp = INPUT.IMP.PROJimp;
trajosamp = PROJimp.trajosamp;
projosamp = PROJimp.projosamp;
p = PROJdgn.p;
Kmat = INPUT.IMP.Kmat;
kmax = PROJdgn.kmax;
TFO = INPUT.TFO;
CTFV = INPUT.CTFV;
clear INPUT

%---------------------------------------------
% Initial Estimate
%---------------------------------------------
Rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
Rad = mean(Rad);
visuals = 0;
if visuals == 1
    figure(40); plot(Rad/PROJdgn.kstep,'*-'); xlabel('Readout Point'); ylabel('Radius Step');
end

if isfield(PROJdgn,'p')
    for n = 1:length(Rad)
        if Rad(n) < (PROJdgn.kmax*PROJdgn.p)
            iSDC(n) = ((Rad(n)/PROJdgn.kmax)/PROJdgn.p).^2;
        else
            iSDC(n) = 1;
        end
    end
else
    iSDC = (Rad/PROJdgn.kmax).^2;
end

%---------------------------------------------
% Normalize
%---------------------------------------------
if strcmp(CTFV.Norm,'OneAtCen')
    iSDC = (iSDC*p)/(trajosamp*projosamp);
    TFO.tf = TFO.tf/max(TFO.tf);
end

%--------------------------------------------
% Add Filter
%--------------------------------------------
rKmat = squeeze(sqrt(Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2))/kmax;
filt = interp1(TFO.r,TFO.tf,rKmat);
iSDC = iSDC.*filt;

%--------------------------------------------
% Visuals
%--------------------------------------------
visuals = 1;
if visuals == 1
    figure(41); plot(iSDC,'*-'); xlabel('Readout Point'); ylabel('Initial SDC Estimate');
end

iSDC = meshgrid(iSDC,(1:PROJdgn.nproj));
IE.iSDC = iSDC;
IE.iterations = 0;

Status2('done','',2);
Status2('done','',3);

