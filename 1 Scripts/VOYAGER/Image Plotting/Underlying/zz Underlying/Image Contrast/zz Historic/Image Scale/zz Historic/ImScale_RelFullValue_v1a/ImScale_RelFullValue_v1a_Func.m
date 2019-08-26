%=====================================================
%
%=====================================================

function [IMSCL,err] = ImScale_RelFullValue_v1a_Func(IMSCL,INPUT)

Status2('busy','Image Scale',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Image = INPUT.Image;
type = INPUT.type;
clear INPUT;

%---------------------------------------------
% Scale Full Value
%---------------------------------------------
if strcmp(type,'Abs')
    maxval0 = max(abs(Image(:)));
    minval = 0;
    maxval = IMSCL.fullintenseval;
elseif strcmp(type,'Real')
    maxval0 = max(real(Image(:)));
    minval = -IMSCL.fullintenseval;
    maxval = IMSCL.fullintenseval;
elseif strcmp(type,'Imag')
    maxval0 = max(imag(Image(:)));
    minval = -IMSCL.fullintenseval;
    maxval = IMSCL.fullintenseval;
elseif strcmp(type,'Phase')
    maxval0 = max(angle(Image(:)));
    minval = -IMSCL.fullintenseval;
    maxval = IMSCL.fullintenseval;
end

Image = IMSCL.fullintenseval*Image/maxval0;

%---------------------------------------------
% Return
%---------------------------------------------
IMSCL.Image = Image;
IMSCL.minval = minval;
IMSCL.maxval = maxval;

Status2('done','',2);
Status2('done','',3);



