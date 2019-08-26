%====================================================
%
%====================================================

function [RADEV,err] = RadSolEv_LRMeth2_v2a_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solving',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
TST = INPUT.TST;
clear INPUT

%---------------------------------------------
% Define
%---------------------------------------------
RADEV.deradsoloutfunc = '(1/p^2)';
if strcmp(TST.relprojlenmeas,'Yes')
    RADEV.deradsolinfunc = '(1/p^2)';
else
    RADEV.deradsolinfunc = '(1./(abs((r/p).^2.5)*p^2))';
end

%---------------------------------------------
% Solution Tolerences
%---------------------------------------------
if strcmp(TST.relprojlenmeas,'Yes')
    RADEV.outtol = 5e-14; 
    RADEV.intol = 2e-6;
else
    RADEV.intol = 5e-14;        
    RADEV.outtol = 5e-14;  
end  

%---------------------------------------------
% Use Evolution Constraint for Design
%---------------------------------------------
if strcmp(TST.relprojlenmeas,'Yes') || strcmp(TST.desoltype,'ConstEvol')                        
    RADEV.Nin = RADEV.Nin/5;
    RADEV.OutShape = RADEV.OutShape*5;
else
    %---------------------------------------------
    % If Rapid Testing - Speed up waveform generation
    %--------------------------------------------- 
    if strcmp(TST.testspeed,'Rapid')
        RADEV.Nin = RADEV.Nin/5;
        RADEV.OutShape = RADEV.OutShape*5;
    end
end

%---------------------------------------------
% Return
%--------------------------------------------- 
RADEV.relprojlenmeas = TST.relprojlenmeas;
RADEV.PanelOutput = struct();

Status2('done','',3);
