%=====================================================
% Read FID
%=====================================================

function [DatMat] = ImportFIDmatV_v1a(file)

fileid = fopen(file,'r','b');                             % use big-endian byte order
 
%---------------------------------------------
% - Read File Header
%---------------------------------------------
[nblocks,ntraces,np] = Read_File_Header_v1(fileid); 		

np = np/2;                                                  % combining real and complex
tnp = nblocks*ntraces*np;                                   % Total Number of Points
i = sqrt(-1);
DatR = zeros(1,tnp);
DatI = zeros(1,tnp);
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

Dat = DatR + (DatI*i);

DatMat = zeros(ntraces,np);
for n = 1:ntraces
    DatMat(n,:) = Dat((n-1)*np+1:n*np);
end

fclose(fileid);

