%====================================================
% 
%====================================================

function [TF,SDCS] = MatchSD_v1(PROJdgn,SDCS,SDCipt)

TF.tf = PROJdgn.sdcTF; 
TF.r = PROJdgn.sdcR;

visuals = 0;
if visuals == 1
    figure; plot(TF.r,TF.tf);
end
%test = 0;