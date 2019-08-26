%====================================================
% 
%====================================================

function [GVP,err] = GvelProf_Exp2Uniform_v1a_Func(GVP,INPUT)

Status2('busy','Get Desired Acceleration Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------

%GVP.Accprof = ['@(Acc0,AccMax,t,tro) Acc0+(AccMax-((1./(1+exp(',num2str(GVP.decayrate),'*(-t+',num2str(GVP.decayshift),'))))*AccMax*',num2str(GVP.startfrac/100-1),')-AccMax*',num2str(GVP.enddrop/100),'*(t/tro)-Acc0).*(1 - exp(-t/',num2str(GVP.tau),'))'];

GVP.Accprof = ['@(Acc0,AccMax,t) Acc0+(AccMax-((1./(1+exp(',num2str(GVP.decayrate),'*(-t+',num2str(GVP.decayshift/100),'))))*AccMax*',num2str(GVP.startfrac/100-1),')-heaviside(t-',num2str(GVP.decayshift/100),').*AccMax.*',num2str(GVP.enddrop/100),'.*(t-',num2str(GVP.decayshift/100),')-Acc0).*(1 - exp(-t/',num2str(GVP.tau),'))'];

Status2('done','',3);
