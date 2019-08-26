%=========================================================
%
%=========================================================

function [TSMP,err] = TrajSamp_LRevo_v1a_Func(TSMP,INPUT)

Status2('busy','Define Trajectory Sampling Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
clear INPUT;

%---------------------------------------------
% MRS Evo Parameters (dspe8ex)
%---------------------------------------------
posdwell = [(0.0025:0.0025:0.025) (0.03:0.005:0.05) (0.06:0.02:0.12) (0.16:0.04:0.2)];

%---------------------------------------------
% Dwell time for critical sampling
%---------------------------------------------                 
TSMP.dwellcrit = PROJimp.maxsmpdwell;            % in ms                          

%---------------------------------------------
% Pick minimum sampling time
%---------------------------------------------  
ind = find(posdwell > TSMP.dwellcrit,1,'first');
if isempty(ind)
    error()
end
dwell = posdwell(ind);

%---------------------------------------------
% Dwell time for critical sampling
%---------------------------------------------
start = TSMP.startfrac0*dwell;                 

%---------------------------------------------
% Determine number of sampling points
%---------------------------------------------
npro = round((PROJdgn.tro-start)/dwell);

%---------------------------------------------
% Return
%---------------------------------------------
TSMP.sampstart = start;
TSMP.dwell = dwell;
TSMP.tro = npro*dwell + start;
TSMP.npro = npro + 1;                           % includes initial point. 
TSMP.tdp = TSMP.npro*PROJdgn.nproj;
TSMP.trajosamp = TSMP.dwellcrit/TSMP.dwell;     % how much oversampled from design

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'tro (ms)',TSMP.tro,'Output'};
Panel(2,:) = {'dwell (ms)',TSMP.dwell,'Output'};
Panel(3,:) = {'npro',TSMP.npro,'Output'};
Panel(4,:) = {'tdp',TSMP.tdp,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TSMP.PanelOutput = PanelOutput;






