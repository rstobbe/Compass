%====================================================
% Uniform
%====================================================

function [G] = ATSi_Uniform(PROJipt)

OverSpin = str2double(PROJipt(strcmp('OverSpin',{PROJipt.labelstr})).entrystr);

G = @(r) OverSpin;

