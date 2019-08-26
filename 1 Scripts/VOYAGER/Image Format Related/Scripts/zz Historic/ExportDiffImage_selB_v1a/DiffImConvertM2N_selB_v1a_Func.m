%=========================================================
% 
%=========================================================

function [OUTPUT,err] = DiffImConvertM2N_selB_v1a_Func(INPUT)

Status('busy','Convert Matrix into Niftii');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
CVT = INPUT.CVT;
IM = INPUT.IM;
EXPORT = INPUT.EXPORT;
iminfo = IM.iminfo;
clear INPUT;

%---------------------------------------------
% Select Directory
%---------------------------------------------
EXPORT.filename = 'NII';

%---------------------------------------------
% Create 4D Image matrix
%---------------------------------------------
if not(strcmp(IM.dims{3},'slice') && strcmp(IM.dims{4},'bvalue') && strcmp(IM.dims{5},'dir'))
    error;
end
dwims = IM.dwims;
sz = size(dwims);
if length(sz) > 5
    error;
end
%NII = zeros(sz(1),sz(2),sz(3),(sz(4)-1)*sz(5)+1);
NII = zeros(sz(1),sz(2),2,(sz(4)-1)*sz(5)+1);
%NII = zeros(sz(1),sz(2),sz(3),2*sz(5)+1);
NII(:,:,:,1) = dwims(:,:,4:5,1,1);
ind = 1;
for m = 1:sz(5)         % should be backwards
    for n = 2:sz(4)
    %for n = [3 6]  
        ind = ind+1;
        NII(:,:,:,ind) = dwims(:,:,4:5,n,m);
    end
end
test = size(NII)

%---------------------------------------------
% Create Par 
%---------------------------------------------
par.phi = 0;
par.theta = 0;
par.psi = 0;
par.lro = iminfo.pixdim(1)*sz(1);
par.lpe = iminfo.pixdim(2)*sz(2);
par.pro = 0;            % readout offset;
par.ppe = 0;            % phase encode offset;
par.pss = 0;            % slice select offset;
par.gap = 0;
par.seqfil = '';
par.comment = '';
par.permute_flag = 0;
%test = iminfo.info
%test2 = iminfo.info.ImagePositionPatient
%est3 = iminfo.info.ImageOrientationPatient

%---------------------------------------------
% Create PRM Input
%---------------------------------------------
PRM.voxsize = iminfo.pixdim;
PRM.par = par;

%---------------------------------------------
% Export Image
%---------------------------------------------
func = str2func([CVT.exportmeth,'_Func']);
INPUT.IM = NII;
INPUT.PRM = PRM;
[EXPORT,err] = func(EXPORT,INPUT);
if err.flag
    return
end
clear INPUT;



