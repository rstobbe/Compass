%=========================================================
%
%=========================================================

function [TSMP,err] = TrajSamp_InovaTPI_v3b_Func(TSMP,INPUT)

Status2('busy','Define Trajectory Sampling Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
GWFM = INPUT.GWFM;

%---------------------------------------------
% Test SampBase
%---------------------------------------------
if rem(TSMP.sampbase,12.5)
    err.flag = 1;                                           % 12.5 ns limit for INOVA - choose larger to avoid excessive number 'length'  
    err.msg = 'SampBase must be a multiple of 12.5 ns for INOVA';
end 

%---------------------------------------------
% Dwell time for critical sampling
%---------------------------------------------                 
TSMP.maxspherefreq = GWFM.Gmax*PROJdgn.fov/2*PROJimp.gamma;              % Spherical FoV
TSMP.dwellcrit = 1000/(2*TSMP.maxspherefreq);                         % in ms
TSMP.dwelldesign = PROJdgn.iseg/(PROJdgn.rad*PROJdgn.p);                 % Spherical FoV

%---------------------------------------------
% Determine Filter BW (factor of 1000 Hz)
%---------------------------------------------
TSMP.filtBW = 1000*ceil(TSMP.maxspherefreq*TSMP.relfiltbw0/1000);
TSMP.relfiltbw = TSMP.filtBW/TSMP.maxspherefreq;

%---------------------------------------------
% Determine OverSampling
%---------------------------------------------
oversamp0 = TSMP.relfiltbw*TSMP.relsamp2filt0;
oversamp = oversamp0;

%---------------------------------------------
% Find an oversampling for 'Matching Iseg'  
%---------------------------------------------
if strcmp(TSMP.matchiseg,'Yes')    
    while true
        dwell0 = PROJdgn.iseg/((PROJdgn.rad*PROJdgn.p)*oversamp);
        sampstart = dwell0*TSMP.startfrac0;
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
end

%---------------------------------------------
% Initial estimate of dwell and npro  
%---------------------------------------------
dwell0 = TSMP.dwellcrit/oversamp;
npro0 = round((PROJdgn.tro-dwell0*TSMP.startfrac0)/dwell0);
dwell0 = (PROJdgn.tro-dwell0*TSMP.startfrac0)/npro0;
npro0 = round((PROJdgn.tro-dwell0*TSMP.startfrac0)/dwell0);
dwell0 = (PROJdgn.tro-dwell0*TSMP.startfrac0)/npro0;

%---------------------------------------------
% Make dwell a multiple of sampbase
%---------------------------------------------              
dwell = dwell0*1e6 - rem(dwell0*1e6,TSMP.sampbase);                  
npro = npro0;
go = 1;
while go == 1
    start = PROJdgn.tro*1e6 - npro*dwell;
    startfrac = start/dwell;
    if startfrac > TSMP.startfrac0+0.05
        npro = npro + 1;
    elseif startfrac < TSMP.startfrac0-0.05
        dwell = dwell - TSMP.sampbase;
    else
        break
    end
end

%---------------------------------------------
% Tests 
%---------------------------------------------
if startfrac < TSMP.startfrac0-0.05 || startfrac > TSMP.startfrac0+0.05
    error();
end
if npro*dwell+start ~= PROJdgn.tro*1e6
    error();
end

%---------------------------------------------
% Return
%---------------------------------------------
TSMP.sampstart = start/1e6;
TSMP.sampstartfrac = startfrac;
TSMP.dwell = dwell/1e6;
TSMP.tro = TSMP.dwell*npro+TSMP.sampstart;
TSMP.npro = npro + 1;   % includes centre. 
TSMP.tdp = TSMP.npro*PROJdgn.nproj;
TSMP.trajosamp = TSMP.dwelldesign/TSMP.dwell;                  % how much oversampled from design
TSMP.relsamp2filt = (1000*(1/TSMP.dwell)/2)/TSMP.filtBW;
TSMP.samplingBW = 1000/TSMP.dwell;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'RelfiltBW',TSMP.relfiltbw,'Output'};
Panel(2,:) = {'RelSamp2Filt',TSMP.relsamp2filt,'Output'};
Panel(3,:) = {'StartFrac',TSMP.sampstartfrac,'Output'};
Panel(4,:) = {'tro (ms)',TSMP.tro,'Output'};
Panel(5,:) = {'dwell (ms)',TSMP.dwell,'Output'};
Panel(6,:) = {'sampstart (ms)',TSMP.sampstart,'Output'};
Panel(7,:) = {'npro',TSMP.npro,'Output'};
Panel(8,:) = {'tdp',TSMP.tdp,'Output'};
Panel(9,:) = {'filter (Hz)',TSMP.filtBW,'Output'};
Panel(10,:) = {'trajosamp',TSMP.trajosamp,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TSMP.PanelOutput = PanelOutput;






