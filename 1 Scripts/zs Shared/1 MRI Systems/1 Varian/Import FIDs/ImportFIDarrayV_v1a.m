%=====================================================
% (v1a)
%
%=====================================================

function [Dat] = ImportFIDarrayV_v1a(file)

fileid = fopen(file,'r','b');                             % use big-endian byte order
if fileid == -1
    error('not a valid file');
end

%---------------------------------------------
% - Read File Header
%---------------------------------------------
[nblocks,ntraces,np] = Read_File_HeaderV_v1a(fileid); 		

np = np/2;                                                  % combining real and complex
%tnp = nblocks*ntraces*np;                                   % Total Number of Points
DatR = zeros(nblocks,ntraces*np);
DatI = zeros(nblocks,ntraces*np);
BLH = cell(1,nblocks);

%---------------------------------------------
% - Input Data
%---------------------------------------------
blockHlen = 7;
blockDlen = (np*2)*ntraces;
blocklen = blockHlen+blockDlen;
Datlen = blocklen*nblocks;
Dat0 = fread(fileid,Datlen,'int32');

for n = 1:nblocks
    BLH{n} = Dat0((n-1)*blocklen+1:(n-1)*blocklen+blockHlen);
    DatR((n-1)*np*ntraces+1:n*np*ntraces) = Dat0((n-1)*blocklen+blockHlen+1:2:n*blocklen);
    DatI((n-1)*np*ntraces+1:n*np*ntraces) = Dat0((n-1)*blocklen+blockHlen+2:2:n*blocklen);
end

Dat = DatR + 1i*DatI;

fclose(fileid);

