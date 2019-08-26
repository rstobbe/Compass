%=========================================================
%
%=========================================================

function [TSMP,err] = TrajSamp_IdealLR_v1a_Func(TSMP,INPUT)

Status2('busy','Define Trajectory Sampling Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;

%---------------------------------------------
% Dwell time
%---------------------------------------------  
startfrac = 0.5;
dwell0 = PROJdgn.dwellcrit0/TSMP.oversamp;
sampstart = dwell0*startfrac;
dwell = (PROJdgn.tro-sampstart)/ceil(PROJdgn.tro/dwell0);

%---------------------------------------------
% Test
%---------------------------------------------
test = (sampstart:dwell:PROJdgn.tro);
if test(length(test)) ~= PROJdgn.tro
    error();
end

%---------------------------------------------
% Return
%---------------------------------------------
TSMP.sampstart = sampstart;
TSMP.sampstartfrac = startfrac;
TSMP.dwell = dwell;
TSMP.tro = test(length(test));
TSMP.npro = length(test);   
TSMP.tdp = TSMP.npro*PROJdgn.nproj;
TSMP.trajosamp = TSMP.oversamp;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'tro (ms)',TSMP.tro,'Output'};
Panel(2,:) = {'dwell (ms)',TSMP.dwell,'Output'};
Panel(3,:) = {'sampstart (ms)',TSMP.sampstart,'Output'};
Panel(4,:) = {'npro',TSMP.npro,'Output'};
Panel(5,:) = {'tdp',TSMP.tdp,'Output'};
Panel(6,:) = {'trajosamp',TSMP.trajosamp,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TSMP.PanelOutput = PanelOutput;






