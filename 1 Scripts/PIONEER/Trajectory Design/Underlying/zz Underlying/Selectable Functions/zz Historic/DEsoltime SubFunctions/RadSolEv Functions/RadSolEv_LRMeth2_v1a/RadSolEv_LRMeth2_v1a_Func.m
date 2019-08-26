%====================================================
%
%====================================================

function [RADEV,err] = RadSolEv_LRMeth2_v1a_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solving',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
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
% Use Evolution Constraint for Design
%---------------------------------------------
if strcmp(TST.relprojlenmeas,'Yes')                        
    TST.desoltype = 'ConstEvol';
end

%---------------------------------------------
% Solution Timing (Evolution Constraint)
%---------------------------------------------
if strcmp(TST.desoltype,'ConstEvol')
    if PROJdgn.tro >= 0.5 && PROJdgn.tro < 3
        RADEV.Nin = 1500;                 
        RADEV.OutShape = 2e-3;
        if strcmp(TST.relprojlenmeas,'Yes')
            RADEV.outtol = 5e-14; 
            RADEV.intol = 1e-5;
        else
            RADEV.intol = 5e-14;        
            RADEV.outtol = 5e-14;  
        end  
    elseif PROJdgn.tro >= 3 && PROJdgn.tro < 6
        RADEV.Nin = 1500;                 
        RADEV.OutShape = 2e-3;
        if strcmp(TST.relprojlenmeas,'Yes')
            RADEV.outtol = 5e-14; 
            RADEV.intol = 2e-5;
        else
            RADEV.intol = 5e-14;        
            RADEV.outtol = 5e-14;  
        end  
    elseif PROJdgn.tro >= 6 && PROJdgn.tro < 9
        RADEV.Nin = 1500;                 
        RADEV.OutShape = 2e-3;
        if strcmp(TST.relprojlenmeas,'Yes')
            RADEV.outtol = 5e-14; 
            RADEV.intol = 2e-6;
        else
            RADEV.intol = 5e-14;        
            RADEV.outtol = 5e-14;  
        end        
    elseif PROJdgn.tro >= 9 && PROJdgn.tro < 13
        RADEV.Nin = 3000;                 
        RADEV.OutShape = 0.35e-3;
        if strcmp(TST.relprojlenmeas,'Yes')
            RADEV.outtol = 5e-14; 
            RADEV.intol = 2e-6;
        else
            RADEV.intol = 5e-14;        
            RADEV.outtol = 5e-14;  
        end
    elseif PROJdgn.tro >= 13 && PROJdgn.tro < 28
        RADEV.Nin = 1500;                 
        RADEV.OutShape = 0.5e-3;
        if strcmp(TST.relprojlenmeas,'Yes')
            RADEV.outtol = 5e-14; 
            RADEV.intol = 2e-6;
        else
            RADEV.intol = 5e-14;        
            RADEV.outtol = 5e-14;  
        end
    elseif PROJdgn.tro >= 28 && PROJdgn.tro < 70
        RADEV.Nin = 1500;                 
        RADEV.OutShape = 0.20e-3;
        if strcmp(TST.relprojlenmeas,'Yes')
            RADEV.outtol = 5e-14; 
            RADEV.intol = 2e-6;
        else
            RADEV.intol = 5e-14;        
            RADEV.outtol = 5e-14;  
        end         
    end
    
%---------------------------------------------
% Solution Timing (Final Solution)
%---------------------------------------------    
elseif strcmp(TST.desoltype,'FinalSolution')
    if PROJdgn.tro >= 3 && PROJdgn.tro < 8
        RADEV.Nin = 2500;                 
        RADEV.OutShape = 0.4e-3;
        RADEV.intol = 5e-14;        
        RADEV.outtol = 5e-14;         
    end
    if PROJdgn.tro >= 8 && PROJdgn.tro < 13
        RADEV.Nin = 8000;                 
        RADEV.OutShape = 0.06e-3;
        RADEV.intol = 5e-14;        
        RADEV.outtol = 5e-14;         
    end
    if PROJdgn.tro >= 13 && PROJdgn.tro < 28
        RADEV.Nin = 2500;                 
        RADEV.OutShape = 0.1e-3;
        RADEV.intol = 5e-14;        
        RADEV.outtol = 5e-14;         
    end
    if PROJdgn.tro >= 28 && PROJdgn.tro < 70
        RADEV.Nin = 2500;                 
        RADEV.OutShape = 0.05e-3;
        RADEV.intol = 5e-14;        
        RADEV.outtol = 5e-14;         
    end     
end
    
%---------------------------------------------
% Testing
%--------------------------------------------- 
if strcmp(TST.testspeed,'Rapid')
    RADEV.Nin = RADEV.Nin/5;
    RADEV.OutShape = RADEV.OutShape*5;
end
RADEV.relprojlenmeas = TST.relprojlenmeas;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
RADEV.PanelOutput = struct();
Status2('done','',3);
