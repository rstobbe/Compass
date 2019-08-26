%==================================
% Triexponential
%==================================

function [B0beta,B0fit,SCRPTipt] = B0_TriExp_Manual(gofftime,B0eddy1,SCRPTipt,Clr,figno)

tc1 = str2double(SCRPTipt(strcmp('B0_TC1 (ms)',{SCRPTipt.labelstr})).entrystr)/1000;
mag1 = str2double(SCRPTipt(strcmp('B0_mag1 (uT)',{SCRPTipt.labelstr})).entrystr)/1000;
tc2 = str2double(SCRPTipt(strcmp('B0_TC2 (ms)',{SCRPTipt.labelstr})).entrystr)/1000;
mag2 = str2double(SCRPTipt(strcmp('B0_mag2 (uT)',{SCRPTipt.labelstr})).entrystr)/1000;
tc3 = str2double(SCRPTipt(strcmp('B0_TC3 (ms)',{SCRPTipt.labelstr})).entrystr)/1000;
mag3 = str2double(SCRPTipt(strcmp('B0_mag3 (uT)',{SCRPTipt.labelstr})).entrystr)/1000;

B0fit.fulltime = gofftime;
B0fit.fullvals = mag1*(exp(-(B0fit.fulltime)/tc1)) + ...
                 mag2*(exp(-(B0fit.fulltime)/tc2)) + ...
                 mag3*(exp(-(B0fit.fulltime)/tc3));
             
figure(figno); hold on;
plot(B0fit.fulltime,B0fit.fullvals,[Clr,'-']);

figure(601); hold on;
plot([0 max(gofftime)],[0 0],'k:');
plot(B0fit.fulltime,B0eddy1-B0fit.fullvals,[Clr,'-']);
B0beta = '';