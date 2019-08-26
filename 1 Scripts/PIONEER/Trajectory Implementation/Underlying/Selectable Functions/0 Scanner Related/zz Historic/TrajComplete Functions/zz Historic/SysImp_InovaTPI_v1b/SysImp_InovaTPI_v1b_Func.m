%====================================================
% 
%====================================================

function [SYS,err] = SysImp_InovaTPI_v1b_Func(SYS,INPUT)

Status2('busy','Determine System Implementation Aspects',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
twwords = INPUT.twwords;
clear INPUT

%----------------------------------------------------
% Define Extra Words Per Projection (overhead)
%----------------------------------------------------
%SYS.extrawords = 8;       
SYS.extrawords = 9;  

%----------------------------------------------------
% Calculate Split
%----------------------------------------------------
totwpp = twwords+SYS.extrawords+2;                           % +1 for centre and +1 for zeroing 
totgw = totwpp*(PROJdgn.nproj/2);
split0 = ceil(totgw/64000);
split = split0;
go = 1;
while go == 1
    if rem(PROJdgn.nproj/2,split) == 0
        break
    end    
    split = split + 1;
end
if split > 2*split0
    err.flag = 1;
    err.msg = ['Projection number error.  Try ',num2str(2*split0*round((PROJdgn.nproj/2)/split0)),' projections'];
    return
end
%if split > split0
%    err.flag = 1;
%    err.msg = ['Split can be reduced. Try ',num2str(2*split0*round((PROJdgn.nproj/2)/split0)),' projections'];
%    return;
%end
SYS.totgw = totgw;
SYS.split = split;
SYS.sym = 'PosNeg';

%----------------------------------------------------
% System and Proj-Mult
%----------------------------------------------------
projpersplit = (PROJdgn.nproj/2)/split;
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
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SYS.PanelOutput = PanelOutput;

Status('done','');
Status2('done','',2);
Status2('done','',3);

