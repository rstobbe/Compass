%====================================================
% Uniform
%====================================================

function [spincalcnprojifunc,spincalcndiscsifunc] = US_Uniform_v2b(PROJipt,USAMP)

USAMP.USfactor = str2double(PROJipt(strcmp('USfactor',{PROJipt.labelstr})).entrystr);

spincalcnproj = round(USAMP.nproj/USAMP.USfactor);
spinclacndiscs = sqrt(spincalcnproj/2);

spincalcnprojifunc = @(r) spincalcnproj;
spincalcndiscsifunc = @(r) spinclacndiscs;

