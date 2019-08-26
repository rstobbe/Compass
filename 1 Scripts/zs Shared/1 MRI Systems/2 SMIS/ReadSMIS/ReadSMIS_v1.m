function [Cplx_Data, Pars] = ReadSMIS_v1(file, DataSetOffset, nSets) 
% [Cplx_Data, Pars] = ReadSMIS(file, DataSetOffset, nSets) 
%
% Gets data and parameters from SMIS file (.MRD, .SUR)
% Input arguments:
%   file - string -  fully qualified name of SMIS data file (includes .MRD, .SUR or other files folowing .MRD structure)
%   DataSetOffset -  integer - Optional number of data sets to be skiped. If missing then DataSetOffset=0.
%   nSets - integer - Optional number of data sets. If missing then nSets=1.   
%                    If nSets < 0 then  nSets = dim2, DataSetOffset = k*dim2, k=0,1... 
%                    If nSets == 0 then Cplx_Data = [NSamples NViews1 NViews2 NSlices NEchos NExperiments]
%
% Output:
%   Cplx_Data - complex matrix of size [NSamples, nSets] where:
%	- NSamples - integer - Number of samples or 1st dimension from .MRD header
%	- nSets - Number of requested data sets.
%   Pars - string -  sample and parameter files appended at the end of .MRD 
%
% Usage:
%   [Cplx_Data, Pars] = ReadSMIS(file); % reads 1st data set in the file i.e. dim1 complex/single points. 
%   [Cplx_Data, Pars] = ReadSMIS(file, 2, 5); % reads data sets 3..7  
%   [Cplx_Data, Pars] = ReadSMIS(file, 0, -1); % reads data sets 1..NViews1  
%   [Cplx_Data, Pars] = ReadSMIS(file, 0, 0); % returns [[NSamples NViews1 NViews2 NSlices NEchos NExperiments], Pars]


%	type	data		bytes
%	---	----		-----
%	0x15	complex float	2*4
%	0x13	complex int     2*2
%	0x11	complex chr	2*1	
%	0x05	real float	  4
%	0x03	real int          2
%	0x01	real chr	  1	

if nargin < 1 
   ErrMsg = 'Missing file name !';
   error(ErrMsg);
elseif nargin < 2
   nSets = 1; 
   DataSetOffset = 0;
elseif nargin < 3
   nSets = 1;
end

if DataSetOffset < 0, DataSetOffset = 0; end

[fid,errmsg] = fopen(file);
if fid < 0
   ErrMsg = [file 13 10 errmsg];
   error(ErrMsg);
end

[header, count] = fread(fid,128,'int');
dim1 = header(1);	% NSamples
dim2 = header(2);	% NViews1
dim3 = header(3);	% NViews2
dim4 = header(4);	% NSlices
dim5 = header(39);	% NEchos
dim6 = header(40);	% NExperiments
type = rem(floor(header(5)/65536),256);

cmpx_data = floor(type/16);
data_bytes = rem(type,16) -1;
if data_bytes == 0 
   data_bytes = 1; 
end

if nSets < 0,	% .SUR file
   nSets = dim2 ; 
   DataSetOffset = floor(DataSetOffset/dim2) .* dim2;
end

TotalSets = dim2 * dim3 * dim4 * dim5 * dim6;
if DataSetOffset + nSets > TotalSets,
   ErrMsg = 'DataSetOffset + nSets exceeds file length !';
   error(ErrMsg);
end

if data_bytes == 4
   precision = 'float';
elseif data_bytes == 2
   precision = 'short';
else
   precision = 'schar';
end
dim1Bytes = (1 + cmpx_data) * data_bytes * dim1;
offs_bytes = 512 + DataSetOffset * dim1Bytes ;
stat= fseek(fid,offs_bytes, 'bof');

data = [];
if nSets > 0,
   [data, count] = fread(fid,[1 + cmpx_data, dim1 * nSets], precision);
   if count ~= (dim1 * (1 + cmpx_data)*nSets), error('Cannot read all data/nSets from file !');return;end
end


% Read parameters to the end of file
offs_bytes = 512 + TotalSets * (dim1 * (1 + cmpx_data) * data_bytes) + 120;
stat= fseek(fid,offs_bytes, 'bof');
[Pars, count] = fread(fid);
fclose(fid);

Pars = setstr(Pars');
if 0 == size(data), 
   Cplx_Data = [dim1  dim2  dim3  dim4  dim5  dim6];
   return; 
end
if cmpx_data > 0 
   data = data';
   j = sqrt(-1);
   data = data(:,1)+j*data(:,2);
end
% Set dim1 data in columns, ready for FFT.
% Helas, after reading .SUR a transpose should be done so 'imagesc()' works ok !
TotalSets = length(data) ./ dim1 ;
Cplx_Data = reshape(data, dim1, TotalSets);
