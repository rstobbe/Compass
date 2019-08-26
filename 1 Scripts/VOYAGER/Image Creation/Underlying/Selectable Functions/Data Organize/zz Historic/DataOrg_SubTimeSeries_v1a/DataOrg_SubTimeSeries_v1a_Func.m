%=====================================================
% 
%=====================================================

function [DATORG,err] = DataOrg_SubTimeSeries_v1a_Func(DATORG,INPUT)

Status2('busy','Data Organization',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMPLD = INPUT.IMPLD;
IMP = INPUT.IMPLD.IMP;
clear INPUT

%---------------------------------------------
% Return
%---------------------------------------------
if not(isfield(IMP,'WRTRCN'))
    err.flag = 1;
    err.msg = 'Recon_File not set up for SubTimeSeries';
    return
end
WRTRCN = IMP.WRTRCN;
if not(isfield(WRTRCN,'trajpersweep'))
    err.flag = 1;
    err.msg = 'Recon_File not set up for SubTimeSeries';
    return
end

DATORG.projsampscnr = reshape(IMPLD.IMP.projsampscnr,WRTRCN.trajpersweep,WRTRCN.step);
DATORG.subarrlen = WRTRCN.step;
DATORG.trajpersweep = WRTRCN.trajpersweep;

Status2('done','',2);
Status2('done','',3);





