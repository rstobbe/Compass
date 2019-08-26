%=========================================================
% 
%=========================================================

function [PROJimp,SAMP,SCRPTipt,err] = TrajSamp_TPIstandard_v1a(PROJdgn,PROJimp,SAMP,SCRPTipt,err)


oversamp0 = str2double(SCRPTipt(strcmp('OverSamp_Des',{SCRPTipt.labelstr})).entrystr);
filter0 = str2double(SCRPTipt(strcmp('RelBW_Des',{SCRPTipt.labelstr})).entrystr);
startfrac0 = str2double(SCRPTipt(strcmp('StartFrac_Des',{SCRPTipt.labelstr})).entrystr);
matchiseg = SCRPTipt(strcmp('Match_Iseg',{SCRPTipt.labelstr})).entrystr;
if iscell(matchiseg)
    matchiseg = SCRPTipt(strcmp('Match_Iseg',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Match_Iseg',{SCRPTipt.labelstr})).entryvalue};
end

dwellcrit = PROJdgn.iseg/(PROJdgn.rad*PROJdgn.p);
oversamp = oversamp0;
while true
    dwell0 = PROJdgn.iseg/((PROJdgn.rad*PROJdgn.p)*oversamp);
    sampstart = dwell0*startfrac0;
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

dwell0 = PROJdgn.tro/(PROJdgn.rad*oversamp*PROJdgn.projlen);
dwell0 = (PROJdgn.tro-dwell0*startfrac0)/(PROJdgn.rad*oversamp*PROJdgn.projlen);
npro0 = round((PROJdgn.tro-dwell0*startfrac0)/dwell0);

dwell1 = (PROJdgn.tro-dwell0*startfrac0)/npro0;
SAMP.sampbase = 50;                                          % 12.5 ns limit for INOVA - choose larger to avoid excessive number 'length'                 
dwell1 = dwell1*1e6 - rem(dwell1*1e6,SAMP.sampbase);                  
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

SAMP.osampdes = oversamp0;
SAMP.sampstart = start/1e6;
SAMP.dwell = dwell1/1e6;
SAMP.tro = SAMP.dwell*npro0+SAMP.sampstart;
SAMP.osamp = dwellcrit/dwell;

if strcmp(SAMP.writeout,'no')
    return
end

PROJimp.sampstartfrac = startfrac;
PROJimp.sampstart = start/1e6;
PROJimp.dwell = dwell1/1e6;
PROJimp.npro = npro0 + 1;   % includes centre. 
PROJimp.tro = PROJimp.dwell*npro0+PROJimp.sampstart;
PROJimp.tdp = PROJimp.npro*PROJdgn.nproj;
PROJimp.trajosamp = dwellcrit/dwell;
PROJimp.filBW = 1000*round((filter0/PROJimp.trajosamp*(1000/PROJimp.dwell)/2)/1000);
PROJimp.relfil = PROJimp.filBW/(1/PROJimp.trajosamp*(1000/PROJimp.dwell)/2);

SAMP.panel{1} = {'sampstart (ms)',sampstart};
SAMP.panel{2} = {'dwell (ms)',dwell};
SAMP.panel{3} = {'trajosamp',PROJimp.trajosamp};
SAMP.panel{3} = {'filter (Hz)',PROJimp.filBW};
SAMP.panel{4} = {'relfilterBW',PROJimp.relfil};
SAMP.panel{5} = {'npro',PROJimp.npro};
SAMP.panel{7} = {'tdp',PROJimp.tdp};

%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'sampstart (ms)','0output',PROJimp.sampstart,'0text');
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'dwell (ms)','0output',PROJimp.dwell,'0text');
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'filter (Hz)','0output',PROJimp.filBW,'0text');
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'npro','0output',PROJimp.npro,'0text');
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'tdp','0output',PROJimp.tdp,'0text');
if (PROJimp.relfil > PROJimp.trajosamp)
    %[SCRPTipt] = AddToPanelOutput(SCRPTipt,'trajosamp','0output',PROJimp.trajosamp,'0error');
    if length(err) ~= 1
        errn = length(err)+1;
    else
        errn = 1;
    end
    err(errn).flag = 2;
    err(errn).msg = 'Increase OverSamp_Des';
else
    %[SCRPTipt] = AddToPanelOutput(SCRPTipt,'trajosamp','0output',PROJimp.trajosamp,'0text');
end
%if (PROJimp.relfil > PROJimp.trajosamp)
%    [SCRPTipt] = AddToPanelOutput(SCRPTipt,'RelBW_Imp','0output',PROJimp.relfil,'0error');
%else
%    [SCRPTipt] = AddToPanelOutput(SCRPTipt,'RelBW_Imp','0output',PROJimp.relfil,'0text');
%end
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'StartFrac_Imp','0output',PROJimp.sampstartfrac,'0text');



