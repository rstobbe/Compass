%==================================
% Biexponential
%==================================

function [Gbeta,Gfit,SCRPTipt] = Grad_BiExp_Manual(gofftime,Geddy1,SCRPTipt,Clr,figno)

tc1 = str2double(SCRPTipt(strcmp('G_TC1 (ms)',{SCRPTipt.labelstr})).entrystr)/1000;
mag1 = str2double(SCRPTipt(strcmp('G_mag1 (mT/m)',{SCRPTipt.labelstr})).entrystr);
tc2 = str2double(SCRPTipt(strcmp('G_TC2 (ms)',{SCRPTipt.labelstr})).entrystr)/1000;
mag2 = str2double(SCRPTipt(strcmp('G_mag2 (mT/m)',{SCRPTipt.labelstr})).entrystr);

Gfit.fulltime = gofftime;
Gfit.fullvals = mag1*(exp(-(Gfit.fulltime)/tc1)) + mag2*(exp(-(Gfit.fulltime)/tc2));

figure(figno); hold on;
plot(Gfit.fulltime,Gfit.fullvals,[Clr,'-']);

figure(600); hold on;
plot([0 max(gofftime)],[0 0],'k:');
plot(Gfit.fulltime,Geddy1-Gfit.fullvals,[Clr,'-']);
Gbeta = '';