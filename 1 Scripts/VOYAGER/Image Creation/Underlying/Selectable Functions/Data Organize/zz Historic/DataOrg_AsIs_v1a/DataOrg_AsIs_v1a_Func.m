%=====================================================
% 
%=====================================================

function [DATORG,err] = DataOrg_AsIs_v1a_Func(DATORG,INPUT)

Status2('busy','Data Organization',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMPLD = INPUT.IMPLD;
clear INPUT

%---------------------------------------------
% Return
%---------------------------------------------
if isfield(IMPLD.IMP,'WRTRCN')
    DATORG.projsampscnr = IMPLD.IMP.WRTRCN.projsampscnr;
else
    DATORG.projsampscnr = IMPLD.IMP.projsampscnr.';
end
sz = size(DATORG.projsampscnr);
if sz(1) == 1
    DATORG.projsampscnr = DATORG.projsampscnr.';
end

DATORG.subarrlen = 1;
DATORG.trajpersweep = length(DATORG.projsampscnr);
DATORG.npro = IMPLD.IMP.PROJimp.npro;

Status2('done','',2);
Status2('done','',3);






