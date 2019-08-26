%=========================================================
%
%=========================================================

function [TSMP,err] = TrajSamp_LRstandard_v3f_Func(TSMP,INPUT)

Status2('busy','Define Trajectory Sampling Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
SYS = INPUT.SYS;
clear INPUT;

%---------------------------------------------
% Test SampBase
%---------------------------------------------
if rem(TSMP.sampbase,SYS.SampBase)
    err.flag = 1;                                           % 12.5 ns limit for INOVA - choose larger to avoid excessive number 'length'  
    err.msg = ['SampBase must be a multiple of ',num2str(SYS.SampBase)];
    return
end 

%---------------------------------------------
% Dwell time for critical sampling
%---------------------------------------------                 
TSMP.dwellcrit = PROJimp.maxsmpdwell;                                   % in ms

%---------------------------------------------
% Determine Filter BW (factor of 1000 Hz)
%---------------------------------------------
TSMP.filtBW = 1000*ceil(TSMP.relfiltbw0*(1/(2*TSMP.dwellcrit)));
if TSMP.filtBW > SYS.MaxFB
    err.flag = 1;
    err.msg = 'Anti-Alias Filter Bandwith too Great for System';
    return
end
TSMP.relfiltbw = TSMP.filtBW/(1000/(2*TSMP.dwellcrit));

%---------------------------------------------
% Determine OverSampling
%---------------------------------------------
oversamp = TSMP.relfiltbw*TSMP.relsamp2filt0;

%---------------------------------------------
% Initial estimate of dwell and npro  
%---------------------------------------------
dwell0 = TSMP.dwellcrit/oversamp;
npro0 = round((PROJdgn.tro-dwell0*TSMP.startfrac0)/dwell0);
dwell0 = (PROJdgn.tro-dwell0*TSMP.startfrac0)/npro0;
dwell0 = (dwell0*1e6 - rem(dwell0*1e6,TSMP.sampbase))/1e6; 
npro0 = round((PROJdgn.tro-dwell0*TSMP.startfrac0)/dwell0);
dwell0 = (PROJdgn.tro-dwell0*TSMP.startfrac0)/npro0;

%---------------------------------------------
% Make dwell a multiple of sampbase
%---------------------------------------------              
dwell = dwell0*1e6 - rem(dwell0*1e6,TSMP.sampbase);                  

%---------------------------------------------
% Fiddle to get Startfrac
%---------------------------------------------   
npro = npro0;
go = 1;
while go == 1
    start = PROJdgn.tro*1e6 - npro*dwell;
    startfrac = start/dwell;
    if startfrac > TSMP.startfrac0+0.1
        npro = npro + 1;
    elseif startfrac < TSMP.startfrac0-0.1
        dwell = dwell - TSMP.sampbase;
    else
        break
    end
end

%---------------------------------------------
% Tests 
%---------------------------------------------
sftest1 = 0;
sftest2 = 0;
relaxstartfrac = 0;
if 1e9/dwell > SYS.MaxSW;
    dwell = 1e9/SYS.MaxSW;
    npro = round((PROJdgn.tro-(dwell/1e6)*TSMP.startfrac0)/(dwell/1e6));
    go = 1;
    while go == 1
        start = PROJdgn.tro*1e6 - npro*dwell;
        startfrac = start/dwell;
        if sftest1 == 1 && sftest2 == 1
            relaxstartfrac = 1;
            break
        end
        if startfrac > TSMP.startfrac0+0.1
            npro = npro + 1;
            sftest1 = 1;
        elseif startfrac < TSMP.startfrac0-0.1
            npro = npro - 1;
            sftest2 = 1;
        else
            break
        end
    end
    TSMP.usingmaxdwell = 'Yes';
else
    TSMP.usingmaxdwell = 'No';    
end

%---------------------------------------------
% Tests 
%---------------------------------------------
relsamp2filt = (1e9*(1/dwell)/2)/TSMP.filtBW;
if relsamp2filt < SYS.RelSamp2Filt && strcmp(TSMP.usingmaxdwell,'Yes')
    button = questdlg(['Using max sampling rate and RelSamp2Filt less than ',num2str(SYS.RelSamp2Filt),'.  Continue:'],'Error','Yes','No','Yes');
    if strcmp(button,'No')
        err.flag = 1;
        err.msg = ['Max SampRate -> RelSamp2Filt Less Than ',num2str(SYS.RelSamp2Filt)];
        return
    end
elseif relsamp2filt < SYS.RelSamp2Filt
    button = questdlg(['RelSamp2Filt less than ',num2str(SYS.RelSamp2Filt),'.  Continue:'],'Error','Yes','No','Yes');
    if strcmp(button,'No')
        err.flag = 1;
        err.msg = ['RelSamp2Filt Less Than ',num2str(SYS.RelSamp2Filt)];
        return
    end    
end

%---------------------------------------------
% Tests 
%---------------------------------------------
if relaxstartfrac == 0
    if startfrac < TSMP.startfrac0-0.1 || startfrac > TSMP.startfrac0+0.1
        error();
    end
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
TSMP.trajosamp = TSMP.dwellcrit/TSMP.dwell;                  % how much oversampled from design
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






