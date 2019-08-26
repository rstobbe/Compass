%====================================================
% Uniform
%====================================================

function [spincalcnprojafunc,spincalcndiscsafunc] = USA_Uniform_v1a(PROJipt,nproj)

USAfactor = str2double(PROJipt(strcmp('USAfactor',{PROJipt.labelstr})).entrystr);

spincalcnproj = round(nproj/USIfactor)
spinclacndiscs = sqrt(spincalcnproj/2)

spincalcnprojafunc = @(theta) USAfactor;
spincalcndiscsafunc = @(theta) spinclacndiscs;

