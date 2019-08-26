%=========================================================
% 
%=========================================================

function [EXPORT,err] = ExportImageAnlz_v1d_Func(EXPORT,INPUT)

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
if isfield(IMG,'IMDISP')
    IMDISP = IMG.IMDISP;
    ImInfo = IMDISP.ImInfo
end
% if not(isfield(IMG,'ReconPars'))
%     err.flag = 1;
%     err.msg = '''ReconPar'' missing';
%     return
% end
% ReconPars = IMG.ReconPars;
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
% Analyze Orientation (don't fiddle - problem elsewhere)
%---------------------------------------------
Im = permute(Im,[2,1,3]);       
Im = flip(Im,2);

%---------------------------------------------
% Write Header
%---------------------------------------------
% voxy = ReconPars.ImvoxTB;                                  % backwards for analyze
% voxx = ReconPars.ImvoxLR;  
% voxz = ReconPars.ImvoxIO;  
voxy = ImInfo.pixdim(1);                                  % backwards for analyze
voxx = ImInfo.pixdim(2); 
voxz = ImInfo.pixdim(3);   
[x,y,z] = size(Im);
avw = avw_hdr_make_rob(x,y,z,voxx,voxy,voxz,max(Im(:)),0);      

%---------------------------------------------
% Name
%---------------------------------------------
%name = name(1:end-4);
[file,path] = uiputfile('*.hdr','Name Export Image File',[folder,'\',name,'.hdr']);
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

EXPORT.name = file(1:end-4);
EXPORT.file = file;
EXPORT.path = path;

Status2('done','',2);
Status2('done','',3);
