%===========================================
% 
%===========================================

function [FILT,err] = FilterImageKaiser3D_v1a_Func(FILT,INPUT)

Status2('busy','Create Filter',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Im = INPUT.Im;
ReconPars = INPUT.ReconPars;
clear INPUT;

if ndims(Im) == 4
    [x,y,z,nims] = size(Im);
else
    [x,y,z] = size(Im);
    nims = 1;
end

%---------------------------------------------
% Filter
%--------------------------------------------- 
Filt = Kaiser_v1b(x,y,z,FILT.beta,'unsym');
%figure(100);
%plot(squeeze(Filt(sz(1)/2+1,sz(2)/2+1,:)));
for n = 1:nims                   
    Im(:,:,:,n) = fftshift(fftn(ifftshift(Filt.*fftshift(ifftn(ifftshift(Im(:,:,:,n)))))));
end

%---------------------------------------------
% Update ReconPars
%--------------------------------------------- 
ReconPars.Filter = ['Kaiser',num2str(FILT.beta)];
FILT.ReconPars = ReconPars;

%---------------------------------------------
% Return
%--------------------------------------------- 
FILT.Im = Im;

Status2('done','',2);
Status2('done','',3);

