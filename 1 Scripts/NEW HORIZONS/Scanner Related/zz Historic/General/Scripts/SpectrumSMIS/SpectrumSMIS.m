%====================================================
%
%====================================================

function [SCRPTipt] = SpectrumSMIS(SCRPTipt,SCRPTGBL)

addpath('D:\0 Programs\A0 AID_TRICS\1 Underlying\3 System\2 SMIS\ReadSMIS');

Exp = str2double(SCRPTipt(strcmp('Experiment',{SCRPTipt.labelstr})).entrystr);

DataSetOffset = Exp-1;
nSets = 1;

SCRPTGBL.outpath
[Cplx_Data,Pars] = ReadSMIS(SCRPTGBL.outpath,DataSetOffset,nSets);
set(findobj('tag','TestBox'),'string',Pars);

t = (0:0.1:204.7);
figure(10); hold on;
plot(t,real(Cplx_Data));

figure(11); hold on;
FT = fftshift(fft([Cplx_Data;ones(10000,1)]));
f = linspace(-50000,50000,12048);
plot(f,abs(FT),'r');