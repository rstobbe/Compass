%======================================================
%
%======================================================

function [RLX,SCRPTipt,err] = SigDec_DataFile_v1a(SCRPTipt,err)

Vis = SCRPTipt(strcmp('SigDec Vis',{SCRPTipt.labelstr})).entrystr;
if iscell(Vis)
    Vis = SCRPTipt(strcmp('SigDec Vis',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('SigDec Vis',{SCRPTipt.labelstr})).entryvalue};
end
sigdecfile = SCRPTipt(strcmp('SigDec File',{SCRPTipt.labelstr})).runfuncoutput{1};
TE = str2double(SCRPTipt(strcmp('TE',{SCRPTipt.labelstr})).entrystr);

load(sigdecfile);

tnew = (0:0.01:Data.t(length(Data.t))-TE);
signew = interp1(Data.t-TE,Data.sig,tnew,'linear','extrap');
Data.tnew = tnew;
Data.signew = signew/signew(1);

if strcmp(Vis,'On')
    figure(10000); hold on;
    plot(Data.t,Data.sig); title('Signal Decay'); ylim([0 1]); xlabel('ms');
    plot(Data.t-TE,Data.sig,'g');
    plot(Data.tnew,Data.signew,'r');
end

RLX.func = @(t) interp1(Data.tnew,Data.signew,t,'linear','extrap'); 


