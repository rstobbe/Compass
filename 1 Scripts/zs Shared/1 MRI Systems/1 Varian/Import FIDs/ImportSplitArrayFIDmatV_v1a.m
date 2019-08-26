%=====================================================
% Read FID
%=====================================================

function [FIDmat,FIDparams] = ImportSplitArrayFIDmatV_v1a(file)

fileid = fopen(file,'r','b');                               % use big-endian byte order
   
%---------------------------------------------
% Read File Header
%---------------------------------------------
[nblocks,ntraces,np] = Read_File_HeaderV_v1a(fileid); 		
np = np/2;                                                  % combining real and complex
tnp = nblocks*ntraces*np;                                   % Total Number of Points
i = sqrt(-1);

%---------------------------------------------
% Input FID
%---------------------------------------------
blockHlen = 7;
blockDlen = (np*2)*ntraces;
blocklen = blockHlen+blockDlen;
Datlen = blocklen*nblocks;
Dat0 = fread(fileid,Datlen,'int32');

FIDmat = zeros(ntraces,np,nblocks);
BLH = cell(1,nblocks);
for n = 1:nblocks
    BLH{n} = Dat0((n-1)*blocklen+1:(n-1)*blocklen+blockHlen);
    DatR = Dat0((n-1)*blocklen+blockHlen+1:2:n*blocklen);
    DatI = Dat0((n-1)*blocklen+blockHlen+2:2:n*blocklen);
    Dat = DatR + (DatI*i);
    for m = 1:ntraces
        FIDmat(m,:,n) = Dat((m-1)*np+1:m*np);
    end
end

fclose(fileid);

%---------------------------------------------
% Save FIDparams
%---------------------------------------------
FIDparams.np = np;
FIDparams.ntraces = ntraces;
FIDparams.nblocks = nblocks;
FIDparams.tnp = tnp;


