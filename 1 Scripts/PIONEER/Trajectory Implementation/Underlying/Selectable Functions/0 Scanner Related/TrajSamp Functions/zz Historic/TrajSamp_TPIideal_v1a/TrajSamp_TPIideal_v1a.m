%=========================================================
% 
%=========================================================

function [PROJimp,SAMP,SCRPTipt,err] = TrajSamp_TPIideal_v1a(PROJdgn,PROJimp,SAMP,SCRPTipt,err)

startfrac = str2double(SCRPTipt(strcmp('StartFrac',{SCRPTipt.labelstr})).entrystr);
oversamp = str2double(SCRPTipt(strcmp('OverSamp',{SCRPTipt.labelstr})).entrystr);
matchiseg = SCRPTipt(strcmp('Match_Iseg',{SCRPTipt.labelstr})).entrystr;
if iscell(matchiseg)
    matchiseg = SCRPTipt(strcmp('Match_Iseg',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Match_Iseg',{SCRPTipt.labelstr})).entryvalue};
end

dwellcrit = PROJdgn.iseg/(PROJdgn.rad*PROJdgn.p);
while true
    dwell0 = PROJdgn.iseg/((PROJdgn.rad*PROJdgn.p)*oversamp);
    sampstart = dwell0*startfrac;
    dwell = (PROJdgn.tro-sampstart)/ceil(PROJdgn.tro/dwell0);
    test = (sampstart:dwell:PROJdgn.tro);
    ind = find(test > PROJdgn.iseg,1,'first');
    if test(ind-1) > PROJdgn.iseg * 0.99
        break
    elseif test(ind) < PROJdgn.iseg * 1.01
        break
    elseif strcmp(matchiseg,'No');
        break
    end
    oversamp = oversamp + 0.005;
end
test = (sampstart:dwell:PROJdgn.tro);
if test(length(test)) ~= PROJdgn.tro
    error();
end

PROJimp.sampstartfrac = startfrac;
PROJimp.sampstart = sampstart;
PROJimp.dwell = dwell;
PROJimp.npro = length(test);   
PROJimp.tro = test(length(test));
PROJimp.tdp = PROJimp.npro*PROJdgn.nproj;
PROJimp.trajosamp = dwellcrit/dwell;

SAMP.panel{1} = {'sampstart (ms)',sampstart};
SAMP.panel{2} = {'dwell (ms)',dwell};
SAMP.panel{3} = {'osamp',PROJimp.trajosamp};
SAMP.panel{4} = {'npro',PROJimp.npro};
SAMP.panel{5} = {'tdp',PROJimp.tdp};
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'sampstart (ms)','0output',PROJimp.sampstart,'0text');
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'dwell (ms)','0output',PROJimp.dwell,'0text');
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'npro','0output',PROJimp.npro,'0text');
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'tdp','0output',PROJimp.tdp,'0text');



