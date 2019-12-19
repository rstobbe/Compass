%===========================================
% 
%===========================================

function [MASK,err] = PreviousRoiTransFuncExpand_v1a_Func(MASK,INPUT)

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
% Turn ROI into Mask
%---------------------------------------------
load(MASK.ROI.selectedfile,'ROI');
sz1 = size(Im);
sz2 = size(ROI.roimask);
if sz1(1)~=sz2(1) || sz1(2)~=sz2(2) || sz1(3)~=sz2(3)
    err.flag = 1;
    err.msg = 'Image and ROI do not match';
end
Mask0 = ROI.roimask;

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

% figure(23462346); hold on;
% plot(squeeze(ZfTransFunc(:,szIm(2)/2+1,szIm(3)/2+1)),'b');
% plot(squeeze(ZfTransFunc(szIm(1)/2+1,:,szIm(3)/2+1)),'g--');
% plot(squeeze(ZfTransFunc(szIm(1)/2+1,szIm(2)/2+1,:)),'r:');

%--
% Mask0 = zeros(size(Im));          % PSF display
% Mask0(161,161,161) = 1;
%--
Mask1 = ifftn(fftn(Mask0).*ifftshift(ZfTransFunc));
Mask1 = abs(Mask1);

%---------------------------------------------
% Create
%---------------------------------------------
if strcmp(MASK.Output,'Value')
    Mask = Mask1;
elseif strcmp(MASK.Output,'InvOnes')
    Mask = NaN*ones(size(Mask1));
else
    Mask = ones(size(Mask1));
end
if strcmp(MASK.NanMask,'Positive')
    if strcmp(MASK.Output,'InvOnes')
        Mask(Mask1<MASK.NanMaskThresh) = 1;
    else
        Mask(Mask1<MASK.NanMaskThresh) = NaN;
    end
elseif strcmp(MASK.NanMask,'Negative')
    if strcmp(MASK.Output,'InvOnes')
        Mask(Mask1>MASK.NanMaskThresh) = 1;
    else
        Mask(Mask1>MASK.NanMaskThresh) = NaN;
    end
end

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASK.method,'Output'};
Panel(3,:) = {'ROI File',ROI.roiname,'Output'};
Panel(4,:) = {'TF File',MASK.TfFile,'Output'};
Panel(5,:) = {'NanMask',MASK.NanMask,'Output'};
Panel(6,:) = {'NanMaskThresh',MASK.NanMaskThresh,'Output'};
MASK.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
MASK.Mask = Mask;
MASK.FigureName = 'Mask';
MASK.Prefix = 'MASK';
MASK.Name = ['MASK_',ROI.roiname,'_TFexpand'];

Status2('done','',2);
Status2('done','',3);

