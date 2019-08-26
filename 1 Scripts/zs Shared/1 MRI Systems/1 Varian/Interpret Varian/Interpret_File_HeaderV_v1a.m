%===============================================
% Interpret File Header
% - this is used in TRICS 4.4 and earlier
% - assumes bytes read with wrong byte order
%===============================================

function [nblocks,ntraces,np] = Interpret_File_Header(A)

nblocks1 = bitshift(A(3),8);                        % Blocks per file (1-4)
nblocks = nblocks1 + A(4);							

ntraces1 = bitshift(A(7),8);						% Traces (readouts) per block   (5-8)
ntraces = ntraces1 + A(8);

np1 = bitshift(A(11),8);                            % Data points per traces    (9-12)
np = np1 + A(12);									% (divide by 2 because complex)
np = np/2;

ebytes1 = bitshift(A(15),8);                        % Bytes per element     (13-16)
ebytes = ebytes1 + A(16);							

tbytes1 = bitshift(A(19),8);						% Bytes per trace       (17-20)
tbytes = tbytes1 + A(20);

bbytes1 = bitshift(A(22),16);                       % Bytes per block       (21-24)
bbytes2 = bitshift(A(23),8);						
bbytes = bbytes1 + bbytes2 + A(24);

versionid = A(25);                                  % Software Version (25 - 26)

status = A(28);										% Status Bits   (27 - 28)
data = bitand(status,1)/1;                          % 0 = no data   1 = data
spec = bitand(status,2)/2;                          % 0 = FID       1 = spectrum
d32 = bitand(status,4)/4;                           % 0 = 16 bits   1 = 32 bits    (only valid for integers)
float = bitand(status,8)/8;                         % 0 = integer   1 = floating point
cplx = bitand(status,16)/16;                        % 0 = real      1 = complex
hcplx = bitand(status,32)/32;                       % 1 = hypercomplex

nbheaders = A(32);									% Number of Block Headers per data block    (29 - 32)  - should be 1