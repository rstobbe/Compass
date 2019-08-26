%====================================================
% Uniform
%====================================================

function [spincalcnprojifunc,spincalcndiscsifunc] = USI_Uniform_v2a(PROJipt,nproj)

USIfactor = str2double(PROJipt(strcmp('USIfactor',{PROJipt.labelstr})).entrystr);

spincalcnproj = round(nproj/USIfactor)
spinclacndiscs = sqrt(spincalcnproj/2)

spincalcnprojifunc = @(r) spincalcnproj;
spincalcndiscsifunc = @(r) spinclacndiscs;

