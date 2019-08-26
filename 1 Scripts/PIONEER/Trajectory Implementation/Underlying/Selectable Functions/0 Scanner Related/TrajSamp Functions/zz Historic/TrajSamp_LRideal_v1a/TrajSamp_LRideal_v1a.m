%=========================================================
% 
%=========================================================

function [PROJimp,SAMP,SCRPTipt,err] = TrajSamp_LRIdeal_v1a(PROJdgn,PROJimp,SAMP,SCRPTipt,err)

startfrac = str2double(SCRPTipt(strcmp('StartFrac',{SCRPTipt.labelstr})).entrystr);
oversamp = str2double(SCRPTipt(strcmp('OverSamp',{SCRPTipt.labelstr})).entrystr);

dwell0 = PROJdgn.maxsmpdwell*oversamp;
sampstart = dwell0*startfrac;
dwell = (PROJdgn.tro-sampstart)/ceil(PROJdgn.tro/dwell0);

test = (sampstart:dwell:PROJdgn.tro);

PROJimp.sampstartfrac = startfrac;
PROJimp.sampstart = sampstart;
PROJimp.dwell = dwell;
PROJimp.npro = length(test);   
PROJimp.tro = test(length(test));
PROJimp.tdp = PROJimp.npro*PROJdgn.nproj;
PROJimp.osamp = oversamp;

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'sampstart (ms)','0output',PROJimp.sampstart,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'dwell (ms)','0output',PROJimp.dwell,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'npro','0output',PROJimp.npro,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'tdp','0output',PROJimp.tdp,'0text');



