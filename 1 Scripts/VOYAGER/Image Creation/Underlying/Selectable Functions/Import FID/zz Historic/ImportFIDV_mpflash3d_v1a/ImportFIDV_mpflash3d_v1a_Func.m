%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_mpflash3d_v1a_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT;

%-------------------------------------------
% Read in parameters
%-------------------------------------------
ExpPars = readprocpar(FID.path);

%-------------------------------------------
% Get relevant variables
%-------------------------------------------
np = ExpPars.np/2;
nv = ExpPars.nv;
nv2 = ExpPars.nv2;
ppe = ExpPars.ppe;
nrcvrs = ExpPars.nrcvrs;

%-------------------------------------------
% Read in data
%-------------------------------------------
FIDmat = readfid(FID.path,ExpPars,true,false,true);

%-------------------------------------------
% Reshape into image size
%-------------------------------------------
if nrcvrs == 4
    FIDmat = reshape(FIDmat,[np,4,nv2,nv]);
else
    FIDmat = reshape(FIDmat,[np,1,nv2,nv]);
end
FIDmat = permute(FIDmat,[1 4 3 2]);

%-------------------------------------------
% Transform third dimension back into k-space
%-------------------------------------------
for n = 1:nrcvrs
    Dattemp = squeeze(FIDmat(:,:,:,n));
    FIDmat(:,:,:,n) = fftshift(ifft(ifftshift(Dattemp,3),[],3),3);
end

%-------------------------------------------
% Apply ppe shift (phase encode position)
%-------------------------------------------
if ppe ~= 0
    for n = 1:nrcvrs
        pix = -0.5*ppe./(lpe./nv);
        ph_ramp = exp(sqrt(-1)*2*pi*pix*(-1:2/nv:1-1/nv));
        FIDmat(:,:,:,n) = FIDmat(:,:,:,n) .* repmat(ph_ramp,[np/2 1 ns]);
    end
end

%--------------------------------------------
% Return
%--------------------------------------------
FID.FIDmat = FIDmat;
FID.ExpPars = ExpPars;

Status2('done','',2);
Status2('done','',3);


