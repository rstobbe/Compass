%====================================================
% Uniform
%====================================================

function [spincalcnprojifunc,spincalcndiscsifunc] = US_Uniform_v2a(PROJipt,nproj)

USIfactor = str2double(PROJipt(strcmp('USfactor',{PROJipt.labelstr})).entrystr);

spincalcnproj = round(nproj/USIfactor);
spinclacndiscs = sqrt(spincalcnproj/2);

spincalcnprojifunc = @(r) spincalcnproj;
spincalcndiscsifunc = @(r) spinclacndiscs;

