%====================================================
%  
%====================================================

function [EXPORT,err] = ExportImage_v1b_Func(EXPORT,INPUT)

Status('busy','Export Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
EF = INPUT.EF;
IMSCL = INPUT.IMSCL;
dfilename = INPUT.dfilename;
type = EXPORT.type;
orient = EXPORT.orient;
rotation = EXPORT.rotation;
Image = IMG.Im;
clear INPUT;

%---------------------------------------------
% Orientation
%---------------------------------------------
if strcmp(orient,'Axial')
    Image = Image;
elseif strcmp(orient,'Sagittal')
    Image = permute(Image,[1 3 2]);
elseif strcmp(orient,'Coronal')    
    Image = permute(Image,[3 2 1]);
end

%---------------------------------------------
% Rotate
%---------------------------------------------
if strcmp(rotation,'90')
    Image = permute(Image,[2 1 3]);
elseif strcmp(rotation,'-90')
    Image = permute(Image,[2 1 3]);
    Image = flipdim(Image,2);
end

%---------------------------------------------
% Determine Scaling
%---------------------------------------------
func = str2func([EXPORT.scalefunc,'_Func']);  
INPUT.Image = Image;
INPUT.type = type;
[IMSCL,err] = func(IMSCL,INPUT);
if err.flag
    return
end
clear INPUT;
Image = IMSCL.Image;
minval = IMSCL.minval;
maxval = IMSCL.maxval;
test = max(abs(Image(:)))

%---------------------------------------------
% Determine Scaling
%---------------------------------------------
if strcmp(type,'Abs')
    Image = abs(Image);
elseif strcmp(type,'Real')
    Image = real(Image);
elseif strcmp(type,'Imag')
    Image = imag(Image);
elseif strcmp(type,'Phase')
    Image = angle(Image);
end

%----------------------------------------------
% Export Image
%----------------------------------------------
func = str2func([EXPORT.exportfunc,'_Func']);  
INPUT.Image = Image;
INPUT.dfilename = dfilename;
[EF,err] = func(EF,INPUT);
if err.flag
    return
end
clear INPUT;

Status('done','');
Status2('done','',2);
Status2('done','',3);

