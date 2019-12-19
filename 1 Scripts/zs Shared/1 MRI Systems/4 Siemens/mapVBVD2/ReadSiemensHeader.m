function Hdr = ReadSiemensHeader(filename)


fid = fopen(filename,'r','l','US-ASCII');
fseek(fid,0,'bof');

firstInt  = fread(fid,1,'uint32');
secondInt = fread(fid,1,'uint32');

if not(and(firstInt < 10000, secondInt <= 64))
    error
end

NScans = secondInt;
MeasId = fread(fid,1,'uint32');
FileId = fread(fid,1,'uint32');
measOffset = fread(fid,1,'uint64');             % points to beginning of header, usually at 10240 bytes
fseek(fid,measOffset,'bof');
HdrLen = fread(fid, 1,'uint32');
[Hdr,~] = read_twix_hdr(fid);

fclose(fid);