%=====================================================
% (v2a)
%       
%=====================================================

function [Dat,Info] = ImportFIDgenV_v2a(file,rcvrs)

fileid = fopen(file,'r','b');                             % use big-endian byte order
if fileid == -1
    error('not a valid file');
end

%---------------------------------------------
% - Read File Header
%---------------------------------------------
[nblocks,ntraces,np,Info] = Read_File_HeaderV_v1a(fileid); 		

%---------------------------------------------
% - Test
%---------------------------------------------
if not(strcmp(Info.datsize,'32 bits'))
    error();
end
if not(strcmp(Info.dattype,'integer'))
    error();
end

np = np/2;                                                  % combining real and complex
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

%---------------------------------------------
% Return
%---------------------------------------------
fclose(fileid);

