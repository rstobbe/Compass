%===============================================
% Read File Header
%===============================================

function [nblocks,ntraces,np,Info] = Read_File_HeaderV_v1a(infid)

nblocks    = fread(infid, 1, 'int32');
ntraces    = fread(infid, 1, 'int32');
np         = fread(infid, 1, 'int32');
ebytes     = fread(infid, 1, 'int32');
tbytes     = fread(infid, 1, 'int32');
bbytes     = fread(infid, 1, 'int32'); 
vers_id    = fread(infid, 1, 'int16');
status     = fread(infid, 1, 'int16');
nbheaders  = fread(infid, 1, 'int32');

data = bitand(status,1)/1;                          % 0 = no data   1 = data
spec = bitand(status,2)/2;                          % 0 = FID       1 = spectrum
d32 = bitand(status,4)/4;                           % 0 = 16 bits   1 = 32 bits    (only valid for integers)
float = bitand(status,8)/8;                         % 0 = integer   1 = floating point
cplx = bitand(status,16)/16;                        % 0 = real      1 = complex
hcplx = bitand(status,32)/32;                       % 1 = hypercomplex

if d32
    Info.datsize = '32 bits';
else
    Info.datsize = '16 bits';
end
if float
    Info.dattype = 'floating point';
else
    Info.dattype = 'integer';
end
%if cplx
%    Info.datcplx = 'complex';
%else
%    Info.datcplx = 'real';
%end