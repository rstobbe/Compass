%====================================================
% 
%====================================================

function [SYS,err] = SysImp_InovaSpiral_v1a_Func(SYS,INPUT)

Status2('busy','Determine System Implementation Aspects',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
qTscnr = INPUT.GWFM.qTscnr;
clear INPUT

%----------------------------------------------------
% Sampling Limits
%----------------------------------------------------
SYS.MaxSW = 500000;
SYS.MaxFB = 256000;
SYS.SampBase = 12.5;
SYS.RelSamp2Filt = 1.2;

%----------------------------------------------------
% Define Extra Words Per Projection (overhead)
%----------------------------------------------------
%SYS.extrawords = 8;       
SYS.extrawords = 9;  

%----------------------------------------------------
% Gradient Words
%----------------------------------------------------
SYS.gwpproj = length(qTscnr);
SYS.totgw = (SYS.gwpproj+SYS.extrawords)*PROJdgn.nproj;              

%----------------------------------------------------
% Calculate Split
%----------------------------------------------------
split0 = ceil(SYS.totgw/64000);
split = split0;
go = 1;
while go == 1
    if rem(PROJdgn.nproj,split) == 0
        break
    end    
    split = split + 1;
end
%if split > 2*split0
%    err.flag = 1;
%    err.msg = ['Projection number error.  Try ',num2str(2*split0*round((PROJdgn.nproj)/split0)),' projections'];
%    return
%end
SYS.split = split;
SYS.sym = 'None';

%----------------------------------------------------
% System and Proj-Mult
%----------------------------------------------------
projpersplit = (PROJdgn.nproj)/split;
go = 1;
n = 1;
while go == 1
    if rem(projpersplit,n) == 0 
        if projpersplit/n <= 670
            SYS.projmult = projpersplit/n;
            break
        end
    end
    n = n+1;
    if n > 20
        err.flag = 1;
        err.msg = 'Projection Number Error (projmult). Try Different Number of Projections';
        return
    end
end

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'split',SYS.split,'Output'};
Panel(2,:) = {'projmult',SYS.projmult,'Output'};
Panel(3,:) = {'totgw',SYS.totgw,'Output'};
Panel(4,:) = {'gwpproj',SYS.gwpproj,'Output'};
Panel(5,:) = {'gwpsplit',SYS.gwpproj*SYS.projmult,'Output'};

PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SYS.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);

