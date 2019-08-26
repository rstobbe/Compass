%====================================================
% Uniform
%====================================================

function [G] = OS_Uniform_v1a(PROJipt)

OverProj = str2double(PROJipt(strcmp('OSfactor',{PROJipt.labelstr})).entrystr);

G = @(r,nproj) round(nproj/OverProj);

