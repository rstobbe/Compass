%=========================================================
% (v1b)
%       - update for RWSUI_BA
%=========================================================

function [SCRPTipt,TSMPout,err] = TrajSamp_TPIstandard_v1b(SCRPTipt,TSMP)

Status('busy','Define Trajectory Sampling Timing');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
TSMPout = struct();
TSMPout.oversamp0 = str2double(TSMP.('OverSamp_Des'));
TSMPout.filter0 = str2double(TSMP.('RelBW_Des'));
TSMPout.startfrac0 = str2double(TSMP.('StartFrac_Des'));
TSMPout.matchiseg = TSMP.('Match_iSeg');
TSMPout.sampbase = str2double(TSMP.('SampBase'));

%---------------------------------------------
% Test SampBase
%---------------------------------------------
if rem(TSMPout.sampbase,12.5)
    err.flag = 1;                                           % 12.5 ns limit for INOVA - choose larger to avoid excessive number 'length'  
    err.msg = 'SampBase must be a multiple of 12.5 ns for INOVA';
end 

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
PROJdgn = TSMP.PROJdgn;

%---------------------------------------------
% Dwell time for critical sampling
%---------------------------------------------
TSMPout.dwellcrit = PROJdgn.iseg/(PROJdgn.rad*PROJdgn.p);

%---------------------------------------------
% Find an oversampling for 'Matching Iseg'  
%---------------------------------------------
if strcmp(TSMPout.matchiseg,'Yes')
    oversamp = TSMPout.oversamp0;
    while true
        dwell0 = PROJdgn.iseg/((PROJdgn.rad*PROJdgn.p)*oversamp);
        sampstart = dwell0*TSMPout.startfrac0;
        dwell1 = (PROJdgn.tro-sampstart)/ceil(PROJdgn.tro/dwell0);
        test = (sampstart:dwell1:PROJdgn.tro);
        ind = find(test > PROJdgn.iseg,1,'first');
        if test(ind-1) > PROJdgn.iseg * 0.99
            break
        elseif test(ind) < PROJdgn.iseg * 1.01
            break
        end
        oversamp = oversamp + 0.005;
    end
    test = (sampstart:dwell1:PROJdgn.tro);
    if test(length(test)) ~= PROJdgn.tro
        error();
    end
else
    oversamp = TSMPout.oversamp0;
end

%---------------------------------------------
% Initial estimate of dwell and npro  
%---------------------------------------------
dwell0 = PROJdgn.tro/(PROJdgn.rad*oversamp*PROJdgn.projlen);
dwell0 = (PROJdgn.tro-dwell0*TSMPout.startfrac0)/(PROJdgn.rad*oversamp*PROJdgn.projlen);
npro0 = round((PROJdgn.tro-dwell0*TSMPout.startfrac0)/dwell0);
dwell0 = (PROJdgn.tro-dwell0*TSMPout.startfrac0)/npro0;

%---------------------------------------------
% Make dwell a multiple of sampbase
%---------------------------------------------              
dwell = dwell0*1e6 - rem(dwell0*1e6,TSMPout.sampbase);                  
npro = npro0;
go = 1;
while go == 1
    start = PROJdgn.tro*1e6 - npro*dwell;
    startfrac = start/dwell;
    if startfrac > TSMPout.startfrac0+0.05
        npro = npro + 1;
    elseif startfrac < TSMPout.startfrac0-0.05
        dwell = dwell - TSMPout.sampbase;
    else
        break
    end
end

%---------------------------------------------
% Tests 
%---------------------------------------------
if startfrac < TSMPout.startfrac0-0.05 || startfrac > TSMPout.startfrac0+0.05
    error();
end
if npro*dwell+start ~= PROJdgn.tro*1e6
    error();
end

%---------------------------------------------
% Return
%---------------------------------------------
TSMPout.sampstart = start/1e6;
TSMPout.sampstartfrac = startfrac;
TSMPout.dwell = dwell/1e6;
TSMPout.tro = TSMPout.dwell*npro+TSMPout.sampstart;
TSMPout.trajosamp = TSMPout.dwellcrit/TSMPout.dwell;
TSMPout.npro = npro + 1;   % includes centre. 
TSMPout.tdp = TSMPout.npro*PROJdgn.nproj;
TSMPout.filBW = 1000*round((TSMPout.filter0/TSMPout.trajosamp*(1000/TSMPout.dwell)/2)/1000);
TSMPout.relfil = TSMPout.filBW/(1/TSMPout.trajosamp*(1000/TSMPout.dwell)/2);

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'sampstart (ms)',TSMPout.sampstart,'Output'};
Panel(2,:) = {'sampstartfrac',TSMPout.sampstartfrac,'Output'};
Panel(3,:) = {'dwell (ms)',TSMPout.dwell,'Output'};
Panel(4,:) = {'tro (ms)',TSMPout.tro,'Output'};
Panel(5,:) = {'trajosamp',TSMPout.trajosamp,'Output'};
Panel(6,:) = {'npro',TSMPout.npro,'Output'};
Panel(7,:) = {'tdp',TSMPout.tdp,'Output'};
Panel(8,:) = {'filter (Hz)',TSMPout.filBW,'Output'};
Panel(9,:) = {'relfilterBW',TSMPout.relfil,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TSMPout.PanelOutput = PanelOutput;

%---------------------------------------------
% Tests 
%---------------------------------------------
if (TSMPout.relfil > TSMPout.trajosamp)
    err.flag = 1;
    err.msg = 'Relative Filter BW > Relative Sampling BS';
    return
end





