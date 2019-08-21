%===================================================
% Load_Analyze
%===================================================

function [IM,IMINFO] = Load_FDF(impath,imfile0,Nim)

n = 0;
while true
    n = n+1;
    N = num2str(n,'%3.3u');
    imfile = [imfile0(1:5) N imfile0(9:length(imfile0))];
    [Im,finish] = FDF_2D(impath,imfile);
    if finish == 1
        break
    end
    IM(:,:,n) = Im;
end
IMINFO = [];


%===================================================
% FDF_2D
%===================================================
function [Im,finish] = FDF_2D(impath,imfile)

[fid] = fopen([impath imfile],'r');
if fid == -1
    finish = 1;
    Im = [];
    return
else
    finish = 0;
end
num = 0;
done = false;
machineformat = 'ieee-be'; % Unix-based  
line = fgetl(fid);
disp(line)
while (~isempty(line) && ~done)
    line = fgetl(fid);
    disp(line)
    if strfind(line,'int    bigendian')
        machineformat = 'ieee-le'; % Linux-based    
    end 
    if strfind(line,'float  matrix[] = ')
        [token, rem] = strtok(line,'float  matrix[] = { , };');
        M(1) = str2double(token);
        M(2) = str2double(strtok(rem,', };'));
    end
    if strfind(line,'float  bits = ')
        [token, rem] = strtok(line,'float  bits = { , };');
        bits = str2double(token);
    end
    num = num + 1; 
    if num > 41
        done = true;
    end
end
status = fseek(fid, -M(1)*M(2)*bits/8, 'eof');
if status~=0
    error
end
Im = fread(fid, [M(1), M(2)], 'float32', machineformat);
fclose(fid);

