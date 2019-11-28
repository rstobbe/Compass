%===========================================
% 
%===========================================

function [MASK,err] = CsfMaskTransFuncExpand_v1a_Func(MASK,INPUT)

Status2('busy','Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Im = INPUT.Im;
clear INPUT;

%---------------------------------------------
% Intensity 
%---------------------------------------------
Im(isnan(Im)) = 0;
Mask0 = zeros(size(Im));

if strcmp(MASK.direction,'Positive')
    Mask0(abs(Im) >= MASK.AbsCsfThresh) = 1;
elseif strcmp(MASK.direction,'Negative')
    Mask0(abs(Im) <= MASK.AbsCsfThresh) = 1;
end

%---------------------------------------------
% Expand
%---------------------------------------------
TransFunc = MASK.TF.tf;
ZfTransFunc = zeros(size(Im));
szIm = size(Im);
szTf = size(TransFunc);
dim1 = (szIm(1)/2 - floor(szTf(1)/2) + 1: szIm(1)/2 + ceil(szTf(1)/2)); 
dim2 = (szIm(2)/2 - floor(szTf(2)/2) + 1: szIm(2)/2 + ceil(szTf(2)/2)); 
dim3 = (szIm(3)/2 - floor(szTf(3)/2) + 1: szIm(3)/2 + ceil(szTf(3)/2)); 
ZfTransFunc(dim1,dim2,dim3) = TransFunc;

figure(23462346); hold on;
plot(squeeze(ZfTransFunc(:,szIm(2)/2+1,szIm(3)/2+1)),'b');
plot(squeeze(ZfTransFunc(szIm(1)/2+1,:,szIm(3)/2+1)),'g--');
plot(squeeze(ZfTransFunc(szIm(1)/2+1,szIm(2)/2+1,:)),'r:');

%--
% Mask0 = zeros(size(Im));          % PSF display
% Mask0(161,161,161) = 1;
%--
Mask1 = ifftn(fftshift(fftn(Mask0)).*ZfTransFunc);

%---------------------------------------------
% Create
%---------------------------------------------
Mask = ones(size(Im));
Mask(abs(Mask1)>MASK.PostConvThresh) = NaN;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASK.method,'Output'};
Panel(3,:) = {'AbsCsfThresh',MASK.AbsCsfThresh,'Output'};
Panel(4,:) = {'ThreshDirection',MASK.direction,'Output'};
Panel(5,:) = {'TF File',MASK.TfFile,'Output'};
Panel(6,:) = {'PostConvThresh',MASK.PostConvThresh,'Output'};
MASK.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
MASK.Mask = Mask;
MASK.FigureName = 'CsfMask';

Status2('done','',2);
Status2('done','',3);

