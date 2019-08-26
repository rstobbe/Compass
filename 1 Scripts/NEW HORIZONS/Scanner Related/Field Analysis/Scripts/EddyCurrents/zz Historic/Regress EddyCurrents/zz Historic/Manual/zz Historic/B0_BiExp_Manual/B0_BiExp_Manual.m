%==================================
% Biexponential
%==================================

function [B0beta,B0fit,SCRPTipt] = B0_BiExp_Manual(gofftime,B0eddy1,SCRPTipt,Params,Clr,figno)

B0beta = 0;
tc1 = str2double(SCRPTipt(strcmp('B0_TC1 (ms)',{SCRPTipt.labelstr})).entrystr)/1000;
mag1 = str2double(SCRPTipt(strcmp('B0_mag1 (uT)',{SCRPTipt.labelstr})).entrystr)/1000;
tc2 = str2double(SCRPTipt(strcmp('B0_TC2 (ms)',{SCRPTipt.labelstr})).entrystr)/1000;
mag2 = str2double(SCRPTipt(strcmp('B0_mag2 (uT)',{SCRPTipt.labelstr})).entrystr)/1000;

B0fit.fulltime = gofftime;
B0fit.fullvals = mag1*(exp(-(B0fit.fulltime)/tc1)) + mag2*(exp(-(B0fit.fulltime)/tc2));

B0fit.tottime = [0 gofftime];
B0fit.totvals = mag1*(exp(-(B0fit.tottime)/tc1)) + mag2*(exp(-(B0fit.tottime)/tc2));
B0fit.interptime = (0:0.01:B0fit.tottime(length(B0fit.tottime)));
B0fit.interpvals = mag1*(exp(-(B0fit.interptime)/tc1)) + mag2*(exp(-(B0fit.interptime)/tc2));

figure(figno); hold on;
plot(B0fit.interptime,B0eddy1-B0fit.interpvals*1000,[Clr,'-']);