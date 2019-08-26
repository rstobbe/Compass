%=====================================================
% 
%=====================================================

function [DATORG,err] = DataOrg_LowSubTimeSeries_v1b_Func(DATORG,INPUT)

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
KSMP = IMP.KSMP;
rKmag = KSMP.rKmag;
ind = find(rKmag >= DATORG.kmaxrel/100,1,'first');
DATORG.npro = round(IMP.PROJimp.npro*(ind/length(rKmag)));

%---------------------------------------------
% Test
%---------------------------------------------
if not(isfield(IMP,'TORD'))
    err.flag = 1;
    err.msg = 'Recon_File not set up for SubTimeSeries';
    return
end
TORD = IMP.TORD;
if not(isfield(TORD,'trajpersweep'))
    err.flag = 1;
    err.msg = 'Recon_File not set up for SubTimeSeries';
    return
end

DATORG.projsampscnr = reshape(IMPLD.IMP.projsampscnr,TORD.trajpersweep,TORD.images);
DATORG.subarrlen = TORD.images;
DATORG.trajpersweep = TORD.trajpersweep;

Status2('done','',2);
Status2('done','',3);






