%=========================================================
% 
%=========================================================

function [IMPLD,err] = ImpLoadSeparated_v1a_Func(IMPLD,INPUT)

Status2('busy','Load Implementation Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test/fix
%---------------------------------------------
if not(isfield(IMPLD.IMP,'projsampscnr'))
    projsampscnr = (1:IMPLD.IMP.impPROJdgn.nproj);
    IMPLD.IMP.projsampscnr = projsampscnr;
end

sz = size(IMPLD.SDC);
if sz(2) == 1
    nproj = sz(1)/IMPLD.IMP.PROJimp.npro;
    IMPLD.SDC = SDCArr2Mat(IMPLD.SDC,nproj,IMPLD.IMP.PROJimp.npro);
end

Status2('done','',2);
Status2('done','',3);
