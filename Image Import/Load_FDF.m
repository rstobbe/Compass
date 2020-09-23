%===================================================
% Load_Analyze
%===================================================

function [IMG,ImInfo,err] = Load_FDF(impath,imfile)

err.flag = 0;
err.msg = '';
ImInfo = '';
IMG = struct();

%----------------------------------------------
% Determine 3DOrtho Image
%----------------------------------------------
[ProcPar,err] = Load_ProcparV_v1a([impath,'\procpar']);
if err.flag == 1
    return
end
params = {'orient'};
out = Parse_ProcparV_v1b(ProcPar,params);
orient = out{1}{1};

if not(strcmp(orient,'3orthogonal'))
    err.flag = 1;
    err.msg = 'Compass needs to be updated for this kind of image';
    return
end

%----------------------------------------------
% Read Image
%----------------------------------------------
files = dir(impath);
m = 0;
for n = 3:length(files)
    if files(n).isdir
        continue
    end
    if strcmp(files(n).name(end-2:end),'fdf')
        m = m+1;
    end
    if strcmp(files(n).name,imfile)
        number = m;
    end
end

[Im,~] = FDF_2D(impath,imfile);
IMG.Im = Im;

%----------------------------------------------
% Get Info
%----------------------------------------------
params = {'np','nv','lro','lpe','thk','date','tr','name','ident','time_complete','pslabel','seqfil','te'};
out = Parse_ProcparV_v1b(ProcPar,params);
np = out{1}/2;
nv = out{2};
lro = out{3};
lpe = out{4};
thk = out{5};
date = out{6}{1};
tr = out{7}*1000;
name = out{8}{1};
ident = out{9}{1};
time = out{10}{1};
pslabel = out{11}{1};
seqfil = out{12}{1};
te = out{13}*1000;

%----------------------------------------------
% Image Info
%----------------------------------------------
ImInfo.pixdim = [10*lpe/nv 10*lro/np thk];
ImInfo.vox = ImInfo.pixdim(1)*ImInfo.pixdim(1)*ImInfo.pixdim(3);
ImInfo.acqorient = 'Axial';  
ImInfo.baseorient = 'Axial';  

%----------------------------------------------
% Display Info
%----------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Volunteer',name,'Output'};
Panel(3,:) = {'ID',ident,'Output'};
Panel(4,:) = {'Date',date,'Output'};
Panel(5,:) = {'Time',time,'Output'};
Panel(6,:) = {'Protocol Name',pslabel,'Output'};
Panel(7,:) = {'Sequence Name',seqfil,'Output'};
Panel(8,:) = {'Voxel (mm)',[num2str(ImInfo.pixdim(1),'%2.2f'),' x ',num2str(ImInfo.pixdim(2),'%2.2f'),' x ',num2str(ImInfo.pixdim(3),'%2.2f')],'Output'};
Panel(9,:) = {'TR (ms)',tr,'Output'};
Panel(10,:) = {'TE (ms)',te,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMG.PanelOutput = PanelOutput;
IMG.ExpDisp = PanelStruct2Text(PanelOutput);
ImInfo.info = IMG.ExpDisp;

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

