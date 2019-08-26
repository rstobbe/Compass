%=========================================================
% 
%=========================================================

function [EXPORT,err] = ExportImageAnlz_v1c_Func(EXPORT,INPUT)

Status2('busy','Export Images in Analyze Format',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
folder = INPUT.folder;
name = INPUT.imagename;
subset = EXPORT.subset;
clear INPUT

%---------------------------------------------
% Image Info
%---------------------------------------------
if not(isfield(IMG,'ReconPars'))
    err.flag = 1;
    err.msg = '''ReconPar'' missing';
    return
end
ReconPars = IMG.ReconPars;
Im = IMG.Im;
sz = size(Im);

%---------------------------------------------
% Determine SubSet
%---------------------------------------------
if strcmp(subset,'All')
    start = 1;
    sz = size(Im);
    stop = max(sz);
else
    inds = strfind(subset,':');
    if isempty(inds)
        start = str2double(subset);
        stop = str2double(subset);
    else
        start = str2double(subset(1:inds(1)-1));
        stop = str2double(subset(inds(1)+1:length(subset))); 
    end
end
if stop > sz(3)
    stop = sz(3);
end
%----
%Im = Im(:,:,start:stop,:,:,:);
%----
Im2 = zeros(size(Im));
Im2(:,:,start:stop,:,:,:) = Im(:,:,start:stop,:,:,:);
Im = Im2;
%----
[x,y,z] = size(Im);

%---------------------------------------------
% Handle Multiple Dimensions
%---------------------------------------------
if length(size(Im))>3
    if length(size(Im)) == 4
        dim4 = inputdlg('Enter 4th Dimension Number:','4th Dimension',1,{'1'});
        Im = Im(:,:,:,str2double(dim4{1}));
    else
        error();        % not supported
    end
end

%---------------------------------------------
% Type
%---------------------------------------------
if strcmp(EXPORT.type,'Abs')
    Im = abs(Im);
elseif strcmp(EXPORT.type,'Real')
    Im = real(Im);
elseif strcmp(EXPORT.type,'Imaginary')
    Im = imag(Im);
end
    
%---------------------------------------------
% Orientation
%---------------------------------------------
Im = permute(Im,[2,1,3]);       % for analyze

%---
Im = flip(Im,1);
%---

Im = flip(Im,2);
Im = flip(Im,3);

%---------------------------------------------
% Write Header
%---------------------------------------------
voxy = ReconPars.ImvoxTB;                                  % backwards for analyze
voxx = ReconPars.ImvoxLR;  
voxz = ReconPars.ImvoxIO;  
%voxy = round(1e6*ReconPars.ImfovTB/x)/1e6;        
%voxx = round(1e6*ReconPars.ImfovLR/y)/1e6;
%voxz = round(1e6*ReconPars.ImfovIO/z)/1e6;
[x,y,z] = size(Im);
avw = avw_hdr_make_rob(x,y,z,voxx,voxy,voxz,max(Im(:)),0);      

%---------------------------------------------
% Name
%---------------------------------------------
%name = name(1:end-4);
[file,path] = uiputfile('*.img','Name Export Image File',[folder,'\',name,'.img']);
filename = [path,file];
ind1 = strfind(filename,'.img');
ind2 = strfind(filename,'.hdr');
if isempty(ind1) && isempty(ind2)
    err.flag = 4;
    err.msg = '';
    return
end
filename = filename(1:end-4);        

%---------------------------------------------
% Write Image
%---------------------------------------------
avw.img = Im;
avw_img_write(avw,filename,[],'ieee-le',1);

Status2('done','',2);
Status2('done','',3);
