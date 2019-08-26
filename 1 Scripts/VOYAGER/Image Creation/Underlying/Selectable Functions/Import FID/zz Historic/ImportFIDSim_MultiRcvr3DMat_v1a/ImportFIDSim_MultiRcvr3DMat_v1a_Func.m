%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDSim_MultiRcvr3DMat_v1a_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT;

%---------------------------------------------
% Image
%---------------------------------------------
Im = zeros(65,65,65);
for n = 1:65
    for m = 1:65
        for p = 1:65
            rad = sqrt((n-33)^2 + (m-33)^2 + (p-33)^2);
            if rad < 30
                Im(n,m,p) = 1;
            end
        end
    end
end


%---------------------------------------------
% Sensitivity Map
%---------------------------------------------
Prof = zeros(65,65,65);
for n = 1:65
    for m = 1:65
        for p = 1:65
            rad = sqrt((n-7)^2 + (m-7)^2 + (p-7)^2);
            Prof(n,m,p) = 1/(rad)^1.8;
            if Prof(n,m,p) > 1
                Prof(n,m,p) = 1;
            end
        end
    end
end
Prof = Prof/max(Prof(:));
%figure(1000);
%imshow(Prof(:,:,6),[0 1]);

%---------------------------------------------
% Scaled Images
%---------------------------------------------
Im1 = Im.*Prof;
Im1 = Im1/max(Im1(:));
%figure(1001);
%imshow(Im1(:,:,40),[0 1]);
Im2 = flipdim(Im1,1);
%figure(1002);
%imshow(Im2(:,:,40),[0 1]);
Im3 = flipdim(Im1,2);
%figure(1003);
%imshow(Im3(:,:,40),[0 1]);
Im4 = flipdim(flipdim(Im1,1),2);
%figure(1004);
%imshow(Im4(:,:,40),[0 1]);
Im5 = flipdim(Im1,3);
%figure(1005);
%imshow(Im5(:,:,40),[0 1]);
Im6 = flipdim(flipdim(Im1,1),3);
%figure(1006);
%imshow(Im6(:,:,40),[0 1]);
Im7 = flipdim(flipdim(Im1,3),2);
%figure(1007);
%imshow(Im7(:,:,40),[0 1]);
Im8 = flipdim(flipdim(flipdim(Im1,1),2),3);
%figure(1008);
%imshow(Im8(:,:,40),[0 1]);

%---------------------------------------------
% Data
%---------------------------------------------
kDatSim = zeros(65,65,65,8);
tkDatSim = fftshift(fftn(ifftshift(Im1)));
kDatSim(:,:,:,1) = tkDatSim;
tkDatSim = fftshift(fftn(ifftshift(Im2)));
kDatSim(:,:,:,2) = tkDatSim;
tkDatSim = fftshift(fftn(ifftshift(Im3)));
kDatSim(:,:,:,3) = tkDatSim;
tkDatSim = fftshift(fftn(ifftshift(Im4)));
kDatSim(:,:,:,4) = tkDatSim;
tkDatSim = fftshift(fftn(ifftshift(Im5)));
kDatSim(:,:,:,5) = tkDatSim;
tkDatSim = fftshift(fftn(ifftshift(Im6)));
kDatSim(:,:,:,6) = tkDatSim;
tkDatSim = fftshift(fftn(ifftshift(Im7)));
kDatSim(:,:,:,7) = tkDatSim;
tkDatSim = fftshift(fftn(ifftshift(Im8)));
kDatSim(:,:,:,8) = tkDatSim;

%---------------------------------------------
% Return
%---------------------------------------------
FID.Dat = kDatSim;

Status2('done','',2);
Status2('done','',3);


