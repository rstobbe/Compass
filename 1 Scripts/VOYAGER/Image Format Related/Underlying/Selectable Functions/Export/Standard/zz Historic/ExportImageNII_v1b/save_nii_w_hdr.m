function save_nii_w_hdr(img,par,filename,voxsize,opt)
%   Function to create header and write NIFTI file
%   Required functions: NIFTI functions by Jimmy Shen
%   
%   Author: C. A. Baron
%   Date: 03/2011
%
%   
%   Usage: save_nii_w_hdr(img,par,filename,voxsize)
%   
%   Input:
%   img: image stack of size M x N (x O)
%       M x N: inplane resolution
%       O    : number of slices
%   par: varian parameter structure
%        Use readprocpar to import procpar into matlab
%   filename: filename of NIFTI file (excluding nii extension). The NIFTI
%       file is saved in the current directory
%   voxsize: size of a voxel (mm), [dim1, dim2, dim3]
%   multivol_flg: set to 1 to save 4D data as a series of 3D NIFTI files.
%   Otherwise, a 4D NIFTI is created.
%   
%   Image orientation notes:
%
%   NIFTI follows a convention where positive x,y,z correspond to the
%   right,anterior,superior directions, respectively.
%
%   Input images should conform to the following orientation:
%   Axial images: img(1,:,:) = anterior edge; img(:,1,:) = right edge;
%       img(:,:,1) = superior edge;
%



if (nargin < 5) || isempty(opt)
    opt=se_epi_dw_optset;
end

if islogical(img)
    img = single(img);
end

multivol_flg = opt.multivol_flg;

if strcmp(par.seqfil,'mp_flash3d')
    par.phi = par.phi-180;
    par.psi = par.psi - 180;
    par.theta = -par.theta;
    par.pro = -par.pro;
    par.ppe = -par.ppe;
    img = flipdim(img,3);
end

if abs(par.theta) > 45
    disp('WARNING (save_nii_w_hdr.m): code not yet tested for non-axial images.')
end

% Modify the slice select voxel size to incorporate the gap between slices
voxsize(3) = voxsize(3) + par.gap*10;

% Make definitions based on whether each volume is saved seperately or not.
sz = size(img);
direct = pwd;
filename = sprintf('%s.nii',filename);
if (multivol_flg~=1) || (length(sz) < 4)
    N = 1;
else
    N = prod(sz(4:end));
    mkdir(sprintf('NIFTIs_%s',filename))
    cd(sprintf('NIFTIs_%s',filename))
end

% Perform calculations for header info.
    
% Use the corrected phi value
if isfield(par,'phi_dicom')
    par.phi = par.phi_dicom; % this is needed to get proper orientations
end

% Make pro and pss negative to account for different direction definitions
% in VNMR
par.ppe = -par.ppe;
par.pss = -fliplr(par.pss); % Note that the fliplr is needed because of the flip of the 3rd dimension in calling of make_nii above.

% The following seems to be needed (I think because of the flipping operations in the calling of make_nii)
par.phi = par.phi+180;

% Find transformation matrix
phi   = par.phi * pi/180;
theta = par.theta * pi/180;
psi   = -par.psi   * pi/180;
Rtheta1 = [1 0 0;0 cos(theta) sin(theta);0 -sin(theta) cos(theta)];
Rpsi1   = [cos(psi) sin(psi) 0;-sin(psi) cos(psi) 0;0 0 1];
Rphi1   = [cos(phi) sin(phi) 0;-sin(phi) cos(phi) 0;0 0 1];
R1 = round(1e6*Rpsi1(:,:) * Rtheta1(:,:) * Rphi1(:,:))*1e-6;

% Find position of first voxel
% Define slice centers
Ox = round(1e6*(R1(1,1)*par.ppe*10 + R1(1,2)*par.pro*10 + R1(1,3)*par.pss(1)*10))*1e-6;
Oy = round(1e6*(R1(2,1)*par.ppe*10 + R1(2,2)*par.pro*10 + R1(2,3)*par.pss(1)*10))*1e-6;
Oz = round(1e6*(R1(3,1)*par.ppe*10 + R1(3,2)*par.pro*10 + R1(3,3)*par.pss(1)*10))*1e-6;
% Define span/2
Px = round(1e6*(R1(1,1)*par.lpe/2*10 + R1(1,2)*par.lro/2*10))*1e-6;
Py = round(1e6*(R1(2,1)*par.lpe/2*10 + R1(2,2)*par.lro/2*10))*1e-6;
Pz = round(1e6*(R1(3,1)*par.lpe/2*10 + R1(3,2)*par.lro/2*10))*1e-6;
% Create corner position vector
corner = [Ox-Px; Oy-Py; Oz-Pz];

% Convert from dicom coordinate system to NIFTI coordinate system
R1(1:2,:) = -R1(1:2,:);
corner(1:2) = -corner(1:2);


% Convert transformation matrix into quaterns (code taken from
% http://nifti.nimh.nih.gov/pub/dist/src/niftilib/nifti1_io.c)
a = R1(1,1) + R1(2,2) + R1(3,3) + 1.0 ;
if( a > 0.5 )              % simplest case
    a = 0.5 * sqrt(a) ;
    b = 0.25 * (R1(3,2)-R1(2,3)) / a ;
    c = 0.25 * (R1(1,3)-R1(3,1)) / a ;
    d = 0.25 * (R1(2,1)-R1(1,2)) / a ;
else                      % trickier case
    xd = 1.0 + R1(1,1) - (R1(2,2)+R1(3,3)) ;  % 4*b*b
    yd = 1.0 + R1(2,2) - (R1(1,1)+R1(3,3)) ;  % 4*c*c
    zd = 1.0 + R1(3,3) - (R1(1,1)+R1(2,2)) ;  % 4*d*d
    if( xd > 1.0 )
        b = 0.5 * sqrt(xd) ;
        c = 0.25* (R1(1,2)+R1(2,1)) / b ;
        d = 0.25* (R1(1,3)+R1(3,1)) / b ;
        a = 0.25* (R1(3,2)-R1(2,3)) / b ;
    elseif( yd > 1.0 )
        c = 0.5 * sqrt(yd) ;
        b = 0.25* (R1(1,2)+R1(2,1)) / c ;
        d = 0.25* (R1(2,3)+R1(3,2)) / c ;
        a = 0.25* (R1(1,3)-R1(3,1)) / c ;
    else
        d = 0.5 * sqrt(zd) ;
        b = 0.25* (R1(1,3)+R1(3,1)) / d ;
        c = 0.25* (R1(2,3)+R1(3,2)) / d ;
        a = 0.25* (R1(2,1)-R1(1,2)) / d ;
    end
    if( a < 0.0 )
        b=-b ; c=-c ; d=-d; a=-a;
    end
end


% Loop through all volumes.
for n=1:N
    
    if N > 1
        tmp = img(:,:,:,n);
        if n<10
            filename_a = sprintf('%s_00%d',filename,n);
        elseif n<100
            filename_a = sprintf('%s_0%d',filename,n);
        else
            filename_a = sprintf('%s_%d',filename,n);
        end
    else
        tmp = img;
        clear img
        filename_a = filename;
    end
    
    % Create NIFTI structure
    % NB: the flipping and permutations are because make_nii expects the
    % data to be in a specific orientation.
    if ~isreal(tmp)
        tmp = abs(tmp);
    end
    tmp = permute(tmp,[2 1 3 4 5 6]);
    if opt.numchunks > 1
        for m = 1:prod(sz(4:end))
            tmp(:,:,:,m) = flipdim(flipdim(flipdim(tmp(:,:,:,m),2),3),1); 
        end
    else
        tmp = flipdim(flipdim(flipdim(tmp,2),3),1);
    end
%     tmp = flipdim(flipdim(flipdim(permute(abs(tmp),[2 1 3 4 5 6]),2),3),1); 
    nii=make_nii(tmp, voxsize);
    
    % Fill in header info
    
    % Define that qform coordinates correspond to anatomical coordinates, and
    % load quatern values into header.
    nii.hdr.hist.qform_code = 1;
    nii.hdr.hist.quatern_b = b;
    nii.hdr.hist.quatern_c = c;
    nii.hdr.hist.quatern_d = d;
    nii.hdr.hist.qoffset_x = corner(1);
    nii.hdr.hist.qoffset_y = corner(2);
    nii.hdr.hist.qoffset_z = corner(3);
    nii.hdr.dime.pixdim(1) = 1; % this is very important to get right!
    if opt.nii_z_invert
        nii.hdr.dime.pixdim(1) = -1;
    end
    if strcmp(par.seqfil,'se_epi_dw')
        nii.hdr.dime.pixdim(5) = par.tr;
    end
    nii.hdr.hist.sform_code = 0;
    
    % Fill in other misc header info.
    if strcmp(par.seqfil,'se_epi_dw')
        if par.permute_flag > 1
            % NB: these values take into account that the img file is permuted in
            % calling of make_nii
            nii.hdr.hk.dim_info = bin2dec('00110110');
        else
            nii.hdr.hk.dim_info = bin2dec('00111001');
        end
    end
    nii.hdr.dime.slice_end = sz(3)-1;
    nii.hdr.hist.intent_name = par.seqfil;
    nii.hdr.hist.descrip = par.comment;
    
    save_nii(nii, filename_a);
    
end

cd(direct)


















