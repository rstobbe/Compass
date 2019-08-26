%====================================================
% (v1b)
%       - update for RWSUI_BA
%====================================================

function [SCRPTipt,IEout,err] = InitialEst_Radial_v1b(SCRPTipt,IE)

Status('busy','Determine Initial Estimate');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
PROJdgn = IE.PROJdgn;
Kmat = IE.Kmat;

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
visuals = 01;
if visuals == 1
    figure(41); plot(iSDC,'*-'); xlabel('Readout Point'); ylabel('Initial SDC Estimate');
end

iSDC = meshgrid(iSDC,(1:PROJdgn.nproj));
IEout.iSDC = iSDC;

