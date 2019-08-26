%====================================================
% Uniform
%====================================================

function [spincalcnprojifunc,spincalcndiscsifunc] = USA_Uniform_v2a(PROJipt,nproj)

USIfactor = str2double(PROJipt(strcmp('USIfactor',{PROJipt.labelstr})).entrystr);
USAfactor = str2double(PROJipt(strcmp('USAfactor',{PROJipt.labelstr})).entrystr);

spinthetafunc = @(theta) 1 - (1-1/USAfactor)*sin(theta);

spincalcnproj = @(theta) round(nproj*(spinthetafunc(theta)/USIfactor));
spinclacndiscs = @(theta) sqrt(spincalcnproj(theta)/2);

spincalcnprojifunc = @(r,theta) spincalcnproj(theta);
spincalcndiscsifunc = @(r,theta) spinclacndiscs(theta);

