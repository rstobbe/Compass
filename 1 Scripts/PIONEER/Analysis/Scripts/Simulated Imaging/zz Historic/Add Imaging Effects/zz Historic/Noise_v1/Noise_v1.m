%=========================================================
% 
%=========================================================

function [ITSTipt,Dat] = Noise_v1(Dat,dwell,nproj,ITSTipt)

noisepower = str2func(ITSTipt(strcmp('Noise_Power',{ITSTipt.labelstr})).entrystr);

Dat = Dat + noisepower*(randn(length(Dat),1) + 1i*randn(length(Dat),1));
