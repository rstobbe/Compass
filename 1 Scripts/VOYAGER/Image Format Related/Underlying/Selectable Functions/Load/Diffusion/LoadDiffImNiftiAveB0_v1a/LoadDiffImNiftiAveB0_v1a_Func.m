%=========================================================
% - Matrix Output:  (x,y,slices,b-values,dirs,aves)
% - b0 images are averaged (i.e. same b0 image for each 'dir' and 'ave')
%=========================================================

function [IMAT,err] = LoadDiffImNiftiAveB0_v1a_Func(IMAT,INPUT)

Status2('busy','Load DW Dicom Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
loc = IMAT.loc;
totb0ims = IMAT.totb0ims;
totslices = IMAT.totslices;
totdirs = IMAT.totdirs;
numaverages = IMAT.numaverages;
numbvalues = IMAT.numbvalues;

%---------------------------------------------
% Load Nifti Image
%---------------------------------------------
%out = load_nii(loc);
out = load_untouch_nii(loc);
IM = out.img;
sz = size(IM);
if sz(3) ~= totslices
    err.flag = 1;
    err.msg = 'number of slices does not match';
    return  
end
totims = ((totdirs*(numbvalues-1) + totb0ims)*numaverages);
if sz(4) ~= totims
    err.flag = 1;
    err.msg = 'total number of images do not match';
    return
end

%---------------------------------------------
% Average B0 Images
%---------------------------------------------
imper = totims/numaverages;
%b0ims = zeros(sz(1),sz(2),sz(3),totb0ims*numaverages);
for n = 1:numaverages
     b0ims(:,:,:,(n-1)*totb0ims+1:n*totb0ims) = IM(:,:,:,(n-1)*imper+1:(n-1)*imper+totb0ims);
end
%test = size(b0ims);
aveb0im = squeeze(mean(b0ims,4));

%---------------------------------------------
% Diffusion Images
%---------------------------------------------
dwims = zeros(sz(1),sz(2),sz(3),numbvalues,totdirs,numaverages);
for n = 1:numaverages
    for a = 1:numbvalues       
        if a == 1
            for d = 1:totdirs 
                dwims(:,:,:,1,d,n) = aveb0im;
            end
        else
            m = totb0ims + (a-2)*(totdirs) + (n-1)*imper +1;
            dwims(:,:,:,a,:,n) = IM(:,:,:,m:m+totdirs-1);
        end
    end
end

dwims = permute(dwims,[2,1,3,4,5,6]);
dwims = flipdim(dwims,1);

%---------------------------------------------
% Return
%---------------------------------------------
IMAT.dwims = dwims;
IMAT.dims = {'x','y','slice','bvalue','dir','ave'};

Status2('done','',2);
Status2('done','',3);
