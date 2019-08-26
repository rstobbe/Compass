%====================================================
% Kaiser
%====================================================

function [TF,SDCS] = TFKaiser_v1(PROJdgn,SDCS,SDCipt,visuals)

SDCS.TF_KaiserBeta = SDCipt(strcmp('TFbeta',{SDCipt.labelstr})).entrystr;
beta = str2double(SDCS.TF_KaiserBeta);

TF.r = (0:0.01:1);
TF.tf = (1/(PROJdgn.p))*besseli(0,beta * sqrt(1 - TF.r.^2))/besseli(0,beta * sqrt(1 - PROJdgn.p^2)); 

if visuals == 0
    figure; plot(TF.r,TF.tf);
end
%test = 0;