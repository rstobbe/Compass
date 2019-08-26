%==================================
% Monoexponential
%==================================

function [Gbeta,Gfit,SCRPTipt] = Grad_MonoExp_Add(gofftime,Geddy1,SCRPTipt,Clr,figno)

tc = str2double(SCRPTipt(strcmp('Grad_TC (ms)',{SCRPTipt.labelstr})).entrystr)/1000;
mag = str2double(SCRPTipt(strcmp('Grad_mag (mT/m)',{SCRPTipt.labelstr})).entrystr);

Gfit.fulltime = gofftime;
Gfit.fullvals = mag*(exp(-(Gfit.fulltime)/tc));

figure(figno); hold on;
plot(Gfit.fulltime,Gfit.fullvals,[Clr,'-']);

figure(600); hold on;
plot([0 max(gofftime)],[0 0],'k:');
plot(Gfit.fulltime,Geddy1-Gfit.fullvals,[Clr,'-']);
Gbeta = '';