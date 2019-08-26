%=========================================================
%
%=========================================================

function [Data,Info,err] = ReadSMIS3d_v1a(file) 

err.flag = 0;
err.msg = '';

%-------------------------------------------
% Load
%-------------------------------------------
[fid,errmsg] = fopen(file);
if fid < 0
   ErrMsg = [file 13 10 errmsg];
   error(ErrMsg);
end

%-------------------------------------------
% Header
%-------------------------------------------
[header,count] = fread(fid,128,'int');
dim1 = header(1);	% NSamples
dim2 = header(2);	% NViews1
dim3 = header(3);	% NViews2
dim4 = header(4);	% NSlices
dim5 = header(39);	% NEchos
dim6 = header(40);	% NExperiments
type = rem(floor(header(5)/65536),256);
cmpx_data = floor(type/16);
if cmpx_data ~= 1
    error();
end
data_bytes = rem(type,16)-1;
if data_bytes == 0 
   data_bytes = 1; 
end
if data_bytes == 4
   precision = 'float';
elseif data_bytes == 2
   precision = 'short';
else
   precision = 'schar';
end

%-------------------------------------------
% Data
%-------------------------------------------
[Data0,count] = fread(fid,[2,dim1*dim2*dim3*dim4*dim5*dim6],precision);
Data0 = Data0(1,:) + 1i*Data0(2,:);

%-------------------------------------------
% Paramters
%-------------------------------------------
[Pars, count] = fread(fid);
fclose(fid);
Pars = char(Pars.');
Pars = Pars(121:end);
Info.dim1 = dim1;
Info.dim2 = dim2;
Info.dim3 = dim3;
Info.dim4 = dim4;
Info.dim5 = dim5;
Info.dim6 = dim6;
Info.cmpx_data = cmpx_data;
Info.data_bytes = data_bytes;
Info.header = header;
Info.Pars = Pars;


%Data = Data0;
%return

%-------------------------------------------
% Sort
%-------------------------------------------
blk = dim1*dim2*dim3*dim4*dim5;
Data1 = zeros(blk,dim6); 
for a = 1:dim6
    Data1(:,a) = Data0((a-1)*blk+1:a*blk);
end
clear Data0
blk = dim1*dim2*dim3*dim4;
Data2 = zeros(blk,dim5,dim6); 
for a = 1:dim5
    Data2(:,a,:) = Data1((a-1)*blk+1:a*blk,:);
end
clear Data1
blk = dim1*dim2*dim3;
Data3 = zeros(blk,dim4,dim5,dim6); 
for a = 1:dim4
    Data3(:,a,:,:) = Data2((a-1)*blk+1:a*blk,:,:);
end
clear Data2
blk = dim1*dim2;
Data4 = zeros(blk,dim3,dim4,dim5,dim6); 
for a = 1:dim3
    Data4(:,a,:,:,:) = Data3((a-1)*blk+1:a*blk,:,:,:);
end
clear Data3
blk = dim1;
Data = zeros(blk,dim2,dim3,dim4,dim5,dim6); 
for a = 1:dim2
    Data(:,a,:,:,:,:) = Data4((a-1)*blk+1:a*blk,:,:,:,:);
end
clear Data4



