%=========================================================
% (v3e) change in definition of Tro
%       Tro: duration of readout until sampling of last point
%            (does not include initial sampstart value)
%=========================================================

function [PROJimp,SAMP,SCRPTipt,err] = TrajSamp_ConstTR_v3e(PROJdgn,PROJimp,SAMP,SCRPTipt,err)

sampling0 = str2double(SCRPTipt(strcmp('OverSamp_Des',{SCRPTipt.labelstr})).entrystr);
filter0 = str2double(SCRPTipt(strcmp('RelBW_Des',{SCRPTipt.labelstr})).entrystr);
startfrac0 = str2double(SCRPTipt(strcmp('StartFrac_Des',{SCRPTipt.labelstr})).entrystr);

dwellcrit = PROJdgn.iseg/(PROJdgn.rad*PROJdgn.p);
dwell0 = dwellcrit/sampling0;
npro0 = round(PROJdgn.tro/dwell0);
dwell1 = PROJdgn.tro/npro0;
dwell2 = (dwell1*1e6 - rem(dwell1*1e6,12.5))/1e6;                %12.5 ns limit for INOVA
%dwell2 = (dwell1*1e6 - rem(dwell1*1e6,25))/1e6;  
tro = dwell2*npro0;

SAMP.osampdes = sampling0;
SAMP.sampstart = (round(dwell0*startfrac0*1000))/1000;
SAMP.dwell = dwell2;
SAMP.tro = tro;
SAMP.osamp = dwellcrit/dwell2;
if strcmp(SAMP.writeout,'no')
    return
end

PROJimp.sampstartfrac = startfrac;
PROJimp.sampstart = start/1e6;
PROJimp.dwell = dwell2/1e6;
PROJimp.npro = npro0 + 1;   % includes centre. 
PROJimp.tro = PROJimp.dwell*npro0+PROJimp.sampstart;
PROJimp.tdp = PROJimp.npro*PROJdgn.nproj;
PROJimp.osamp = PROJimp.tro/(PROJdgn.rad*PROJimp.dwell*PROJdgn.projlen);
PROJimp.filBW = 1000*round((filter0/PROJimp.osamp*(1000/PROJimp.dwell)/2)/1000);
PROJimp.relfil = PROJimp.filBW/(1/PROJimp.osamp*(1000/PROJimp.dwell)/2);

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'sampstart (ms)','0output',PROJimp.sampstart,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'dwell (ms)','0output',PROJimp.dwell,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'filter (Hz)','0output',PROJimp.filBW,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'npro','0output',PROJimp.npro,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'tdp','0output',PROJimp.tdp,'0text');
if (PROJimp.relfil > PROJimp.osamp)
    [SCRPTipt] = AddToPanelOutput(SCRPTipt,'OverSamp_Imp','0output',PROJimp.osamp,'0error');
    if length(err) ~= 1
        errn = length(err)+1;
    else
        errn = 1;
    end
    err(errn).flag = 2;
    err(errn).msg = 'Increase OverSamp_Des';
else
    [SCRPTipt] = AddToPanelOutput(SCRPTipt,'OverSamp_Imp','0output',PROJimp.osamp,'0text');
end
if (PROJimp.relfil > PROJimp.osamp)
    [SCRPTipt] = AddToPanelOutput(SCRPTipt,'RelBW_Imp','0output',PROJimp.relfil,'0error');
else
    [SCRPTipt] = AddToPanelOutput(SCRPTipt,'RelBW_Imp','0output',PROJimp.relfil,'0text');
end
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'StartFrac_Imp','0output',PROJimp.sampstartfrac,'0text');



