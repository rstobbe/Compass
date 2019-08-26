%=====================================================
% (v1a)
%
%=====================================================

function [DatMat] = ImportFIDgenV_v1a(file,rcvrs)

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
    DatR(n,:) = Dat0((n-1)*blocklen+blockHlen+1:2:n*blocklen);
    DatI(n,:) = Dat0((n-1)*blocklen+blockHlen+2:2:n*blocklen);
end

Dat = DatR + 1i*DatI;

DatMat = zeros(nblocks/rcvrs,np*ntraces,rcvrs);
for n = 1:nblocks/rcvrs
    DatMat(n,:,:) = permute(Dat((n-1)*rcvrs+1:n*rcvrs,:),[2 1]);
end
DatMat = permute(DatMat,[2 1 3]);
clear Dat

DatMat2 = zeros(np,ntraces,nblocks/rcvrs,rcvrs);
for n = 1:ntraces
    DatMat2(:,n,:,:) = DatMat((n-1)*np+1:n*np,:,:);
end
DatMat = DatMat2;

fclose(fileid);

