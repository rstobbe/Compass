%=========================================================
% 
%=========================================================

function [PROJimp,SAMP,SCRPTipt,err] = TrajSamp_ConstTR_v3d(PROJdgn,PROJimp,SAMP,SCRPTipt,err)


sampling0 = str2double(SCRPTipt(strcmp('OverSamp_Des',{SCRPTipt.labelstr})).entrystr);
filter0 = str2double(SCRPTipt(strcmp('RelBW_Des',{SCRPTipt.labelstr})).entrystr);
startfrac0 = str2double(SCRPTipt(strcmp('StartFrac_Des',{SCRPTipt.labelstr})).entrystr);

dwell0 = PROJdgn.tro/(PROJdgn.rad*sampling0*PROJdgn.projlen);
dwell0 = (PROJdgn.tro-dwell0*startfrac0)/(PROJdgn.rad*sampling0*PROJdgn.projlen);
npro0 = round((PROJdgn.tro-dwell0*startfrac0)/dwell0);

dwell1 = (PROJdgn.tro-dwell0*startfrac0)/npro0;
%dwell1 = dwell1*1e6 - rem(dwell1*1e6,12.5);                % 12.5 ns limit for INOVA
%dwell1 = dwell1*1e6 - rem(dwell1*1e6,25);                  
dwell1 = dwell1*1e6 - rem(dwell1*1e6,50);                   % choose larger to avoid excessive number 'length' 
go = 1;
while go == 1
    start = PROJdgn.tro*1e6 - npro0*dwell1;
    startfrac = start/dwell1;
    if startfrac > startfrac0+0.05
        npro0 = npro0 + 1;
    elseif startfrac < startfrac0-0.05
        dwell1 = dwell1 - 12.5;
    else
        break
    end
end
    
if startfrac < startfrac0-0.05 || startfrac > startfrac0+0.05
    error();
end
if npro0*dwell1+start ~= PROJdgn.tro*1e6
    error();
end

SAMP.osampdes = sampling0;
SAMP.sampstart = start/1e6;
SAMP.dwell = dwell1/1e6;
SAMP.tro = SAMP.dwell*npro0+SAMP.sampstart;
SAMP.osamp = SAMP.tro/(PROJdgn.rad*SAMP.dwell*PROJdgn.projlen);
if strcmp(SAMP.writeout,'no')
    return
end

PROJimp.sampstartfrac = startfrac;
PROJimp.sampstart = start/1e6;
PROJimp.dwell = dwell1/1e6;
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
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'StartFrac_Imp','0output',PROJimp.sampstartfrac,'0text');



