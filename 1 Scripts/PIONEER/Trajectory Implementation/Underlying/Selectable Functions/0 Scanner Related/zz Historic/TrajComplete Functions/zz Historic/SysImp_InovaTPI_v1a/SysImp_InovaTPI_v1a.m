%====================================================
% 
%====================================================

function [SCRPTipt,SYSout,err] = SysImp_InovaTPI_v1a(SCRPTipt,SYS)

Status('busy','Determine System Implementation Aspects');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------------
% Get Working Structures / Variables
%----------------------------------------------------
PROJdgn = SYS.PROJdgn;
twwords = SYS.twwords;

%----------------------------------------------------
% Define Extra Words Per Projection (overhead)
%----------------------------------------------------
SYSout.extrawords = 8;

%----------------------------------------------------
% Calculate Split
%----------------------------------------------------
totwpp = twwords+SYSout.extrawords+1;                           % +1 is for the zeroing (not counted yet)
tw = totwpp*(PROJdgn.nproj/2);
split0 = ceil(tw/64000);
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
if split > split0
    err.flag = 1;
    err.msg = ['Split can be reduced. Try ',num2str(2*split0*round((PROJdgn.nproj/2)/split0)),' projections'];
    return;
end
SYSout.split = split;
SYSout.sym = 'PosNeg';

%----------------------------------------------------
% System and Proj-Mult
%----------------------------------------------------
projpersplit = (PROJdgn.nproj/2)/split;
go = 1;
n = 1;
while go == 1
    if rem(projpersplit,n) == 0 
        if projpersplit/n <= 670
            SYSout.projmult = projpersplit/n;
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