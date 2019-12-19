%===================================================
%  (v1a)
%   - see (https://nifti.nimh.nih.gov/pub/dist/src/niftilib/nifti1.h)
%
%   - Use Method 3 (image orientation and location in space)
%       hist.qform_code = 1  & hist.sform_code = 1; 
%       
%
%   - based on Jimmy Shen
%===================================================

function nii = MakeNiftiHeaderYB_v1a(varargin)

   nii.img = varargin{1};
   dims = size(nii.img);
   dims = [length(dims) dims ones(1,8)];
   dims = dims(1:8);

   voxel_size = [0 ones(1,7)];
   origin = zeros(1,5);
   descrip = '';

   switch class(nii.img)
      case 'uint8'
         datatype = 2;
      case 'int16'
         datatype = 4;
      case 'int32'
         datatype = 8;
      case 'single'
         datatype = 16;
      case 'double'
         datatype = 64;
      case 'int8'
         datatype = 256;
      case 'uint16'
         datatype = 512;
      case 'uint32'
         datatype = 768;
      otherwise
         error('Datatype is not supported by make_nii.');
   end

   if nargin > 1 & ~isempty(varargin{2})
      voxel_size(2:4) = double(varargin{2});
   end

   if nargin > 2 & ~isempty(varargin{3})
      origin(1:3) = double(varargin{3});
   end

   if nargin > 3 & ~isempty(varargin{4})
      datatype = double(varargin{4});
   end

   if nargin > 4 & ~isempty(varargin{5})
      descrip = varargin{5};
   end

   if datatype == 128
      if ndims(nii.img) > 8
         error('NIfTI only allows a maximum of 7 Dimension matrix.');
      end

     dims(1) = dims(1)-1;
     dims(5:8) = [dims(6:8) 1];

   else
      if ndims(nii.img) > 7
         error('NIfTI only allows a maximum of 7 Dimension matrix.');
      end
   end

   maxval = round(double(max(nii.img(:))));
   minval = round(double(min(nii.img(:))));

   nii.hdr = make_header(dims, voxel_size, origin, datatype, ...
	descrip, maxval, minval);

   switch nii.hdr.dime.datatype
   case 2
      nii.img = uint8(nii.img);
   case 4
      nii.img = int16(nii.img);
   case 8
      nii.img = int32(nii.img);
   case 16
      nii.img = single(nii.img);
   case 32
      nii.img = single(nii.img);
   case 64
      nii.img = double(nii.img);
   case 128
      nii.img = uint8(nii.img);
   case 256
      nii.img = int8(nii.img);
   case 512
      nii.img = uint16(nii.img);
   case 768
      nii.img = uint32(nii.img);
   case 1792
      nii.img = double(nii.img);
   otherwise
      error('Datatype is not supported by make_nii.');
   end

   return;					% make_nii


%---------------------------------------------------------------------
function hdr = make_header(dims, voxel_size, origin, datatype, ...
	descrip, maxval, minval)

   hdr.hk   = header_key;
   hdr.dime = image_dimension(dims, voxel_size, datatype, maxval, minval);
   hdr.hist = data_history(origin, voxel_size, descrip);
    
   return;					% make_header


%---------------------------------------------------------------------
function hk = header_key

    hk.sizeof_hdr       = 348;			% must be 348!
    hk.data_type        = '';
    hk.db_name          = '';
    hk.extents          = 0;
    hk.session_error    = 0;
    hk.regular          = 'r';
    hk.dim_info         = 0;
    
    return;					% header_key


%---------------------------------------------------------------------
function dime = image_dimension(dims, voxel_size, datatype, maxval, minval)
   
   dime.dim = dims;
   dime.intent_p1 = 0;
   dime.intent_p2 = 0;
   dime.intent_p3 = 0;
   dime.intent_code = 0;
   dime.datatype = datatype;
   
   switch dime.datatype
   case   2
      dime.bitpix = 8;  %precision = 'uint8';
   case   4
      dime.bitpix = 16; %precision = 'int16';
   case   8
      dime.bitpix = 32; %precision = 'int32';
   case  16
      dime.bitpix = 32; %precision = 'float32';
   case  32
      dime.bitpix = 64; %precision = 'float32';
   case  64
      dime.bitpix = 64; %precision = 'float64';
   case  128
      dime.bitpix = 24; %precision = 'uint8';
   case 256 
      dime.bitpix = 8;  %precision = 'int8';
   case 512 
      dime.bitpix = 16; %precision = 'uint16';
   case 768 
      dime.bitpix = 32; %precision = 'uint32';
   case  1792
      dime.bitpix = 128; %precision = 'float64';
   otherwise
      error('Datatype is not supported by make_nii.');
   end
   
   dime.slice_start = 0;
   dime.pixdim = voxel_size;
   %-
   dime.pixdim(1) = -1;         % see https://nifti.nimh.nih.gov/pub/dist/src/niftilib/nifti1.h
   %-
   dime.vox_offset = 0;
   dime.scl_slope = 0;
   dime.scl_inter = 0;
   dime.slice_end = 0;
   dime.slice_code = 0;
   dime.xyzt_units = 10;
   dime.cal_max = 0;
   dime.cal_min = 0;
   dime.slice_duration = 0;
   dime.toffset = 0;
   dime.glmax = maxval;
   dime.glmin = minval;
   
   return;					% image_dimension


%---------------------------------------------------------------------
function hist = data_history(origin, voxel_size, descrip)
   
   hist.descrip = descrip;
   hist.aux_file = '';
   %hist.qform_code = 1;                % 'flirt' doesn't like this
   hist.qform_code = 0;
   hist.sform_code = 1;
   hist.quatern_b = 0;                  % see https://nifti.nimh.nih.gov/pub/dist/src/niftilib/nifti1.h
   hist.quatern_c = 0;
   hist.quatern_d = 0;
%    hist.qoffset_x = -origin(1);
%    hist.qoffset_y = -origin(2);
%    hist.qoffset_z = -origin(3);
   hist.qoffset_x = 0;
   hist.qoffset_y = 0;
   hist.qoffset_z = 0;
%    hist.srow_x = [voxel_size(2) 0 0 -origin(1)];
%    hist.srow_y = [0 voxel_size(3) 0 -origin(2)];
%    hist.srow_z = [0 0 voxel_size(4) -origin(3)];
   hist.srow_x = [-voxel_size(2) 0 0 origin(1)];
   hist.srow_y = [0 voxel_size(3) 0 -origin(2)];
   hist.srow_z = [0 0 voxel_size(4) -origin(3)];
   hist.intent_name = '';
   hist.magic = 'n+1';
   hist.originator = origin;
   
   return;					% data_history

