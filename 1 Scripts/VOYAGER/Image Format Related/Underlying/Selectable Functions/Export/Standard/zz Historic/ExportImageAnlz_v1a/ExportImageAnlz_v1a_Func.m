%=========================================================
% 
%=========================================================

function [EXPORT,err] = ExportImageAnlz_v1a_Func(EXPORT,INPUT)

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
clear INPUT

%---------------------------------------------
% Image Info
%---------------------------------------------
if not(isfield(IMG,'ReconPars'))
    err.flag = 1;
    err.msg = 'This Image Reconstruction is Old';
    return
end
ReconPars = IMG.ReconPars;
Im = IMG.Im;
[x,y,z] = size(Im);

%---------------------------------------------
% Ensure Absolute Value
%---------------------------------------------
Im = abs(Im);

%---------------------------------------------
% Orientation
%---------------------------------------------
Im = permute(Im,[2,1,3]);       % for analyze
Im = flipdim(Im,2);

%---------------------------------------------
% Write Header
%---------------------------------------------
voxy = round(1e6*ReconPars.ImfovTB/x)/1e6;         % backwards for analyze
voxx = round(1e6*ReconPars.ImfovLR/y)/1e6;
voxz = round(1e6*ReconPars.ImfovIO/z)/1e6;
[x,y,z] = size(Im);
avw = avw_hdr_make_rob(x,y,z,voxx,voxy,voxz,max(Im(:)),0);      

%---------------------------------------------
% Name
%---------------------------------------------
name = name(1:end-4);
[file,path] = uiputfile('*.*','Name Export Image File',[folder,'\',name,'.img']);
filename = [path,file];
ind = strfind(filename,'.img');
if isempty(ind)
    err.flag = 1;
    err.msg = 'Aborted';
    return
end
filename = filename(1:ind-1);        

%---------------------------------------------
% Write Image
%---------------------------------------------
avw.img = Im;
avw_img_write(avw,filename,[],'ieee-le',1);

Status2('done','',2);
Status2('done','',3);
