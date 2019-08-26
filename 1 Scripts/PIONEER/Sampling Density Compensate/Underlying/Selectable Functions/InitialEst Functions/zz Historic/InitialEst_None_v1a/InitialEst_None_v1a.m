%====================================================
% 
%====================================================

function [iSDC,SDCS,SDCipt,err] = InitialEst_None_v1a(Kmat,PROJdgn,PROJimp,SDCS,SDCipt,SCRPTGBL,err)

visuals = 0;

Rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
Rad = mean(Rad);
if visuals == 1
    figure(40); plot(Rad/PROJdgn.kstep,'*-'); xlabel('Readout Point'); ylabel('Radius Step');
end

iSDC = ones(size(Kmat));