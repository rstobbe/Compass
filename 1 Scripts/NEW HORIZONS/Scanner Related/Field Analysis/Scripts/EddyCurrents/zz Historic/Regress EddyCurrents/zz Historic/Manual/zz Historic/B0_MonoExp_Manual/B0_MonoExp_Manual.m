%==================================
% Monoexponential
%==================================

function [B0beta,B0fit,SCRPTipt] = B0_MonoExp_Manual(gofftime,B0eddy1,SCRPTipt,Clr,figno)

tc = str2double(SCRPTipt(strcmp('B0_TC (ms)',{SCRPTipt.labelstr})).entrystr)/1000;
mag = str2double(SCRPTipt(strcmp('B0_mag (uT)',{SCRPTipt.labelstr})).entrystr)/1000;

B0fit.fulltime = gofftime;
B0fit.fullvals = mag*(exp(-(B0fit.fulltime)/tc));

figure(figno); hold on;
plot(B0fit.fulltime,B0fit.fullvals,[Clr,'-']);

figure(601); hold on;
plot([0 max(gofftime)],[0 0],'k:');
plot(B0fit.fulltime,B0eddy1-B0fit.fullvals,[Clr,'-']);
B0beta = '';