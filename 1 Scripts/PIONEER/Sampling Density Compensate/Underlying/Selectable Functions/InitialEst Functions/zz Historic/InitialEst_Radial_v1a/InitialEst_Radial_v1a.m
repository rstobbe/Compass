%====================================================
% 
%====================================================

function [iSDC,SDCS,SDCipt,err] = InitialEst_Radial_v1a(Kmat,PROJdgn,PROJimp,SDCS,SDCipt,SCRPTGBL,err)

visuals = 0;

Rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
Rad = mean(Rad);
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
if visuals == 1
    figure(40); plot(iSDC,'*-'); xlabel('Readout Point'); ylabel('Initial SDC Estimate');
end

iSDC = meshgrid(iSDC,(1:PROJdgn.nproj));