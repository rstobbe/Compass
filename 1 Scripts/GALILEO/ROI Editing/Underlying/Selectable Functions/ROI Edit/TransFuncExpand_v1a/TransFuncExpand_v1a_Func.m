%===========================================
% 
%===========================================

function [MASK,err] = TransFuncExpand_v1a_Func(MASK,INPUT)

Status2('busy','Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
ROIARR = INPUT.ROI;
clear INPUT;

%---------------------------------------------
% Turn ROI into Mask
%---------------------------------------------
for n = 1:length(ROIARR)
    if isfield(ROIARR(n),'loc')
        load(ROIARR(n).loc,'ROI');
    else
        ROI = ROIARR(n);
    end
    Mask0 = ROI.roimask;

    %---------------------------------------------
    % Expand
    %---------------------------------------------
    TransFunc = MASK.TF.tf;
    ZfTransFunc = zeros(size(Mask0));
    szMask0 = size(Mask0);
    szTf = size(TransFunc);
    dim1 = (szMask0(1)/2 - floor(szTf(1)/2) + 1: szMask0(1)/2 + ceil(szTf(1)/2)); 
    dim2 = (szMask0(2)/2 - floor(szTf(2)/2) + 1: szMask0(2)/2 + ceil(szTf(2)/2)); 
    dim3 = (szMask0(3)/2 - floor(szTf(3)/2) + 1: szMask0(3)/2 + ceil(szTf(3)/2)); 
    ZfTransFunc(dim1,dim2,dim3) = TransFunc;

    %--
    % figure(23462346); hold on;
    % plot(squeeze(ZfTransFunc(:,szMask0(2)/2+1,szMask0(3)/2+1)),'b');
    % plot(squeeze(ZfTransFunc(szMask0(1)/2+1,:,szMask0(3)/2+1)),'g--');
    % plot(squeeze(ZfTransFunc(szMask0(1)/2+1,szMask0(2)/2+1,:)),'r:');
    %--
    % Mask0 = zeros(size(Mask0));          % PSF display
    % Mask0(161,161,161) = 1;
    %--
    
    Mask1 = ifftn(fftn(Mask0).*ifftshift(ZfTransFunc));
    Mask1 = abs(Mask1);

    %---------------------------------------------
    % Create
    %---------------------------------------------
    if strcmp(MASK.Output,'Value')
        Mask = Mask1;
    else
        Mask = ones(size(Mask1));
    end
    Mask(Mask1<MASK.MaskThresh) = 0;
    ROI.ExternalDefineRoiMask('Axial',size(Mask),Mask);
    ROI.SetInfo('TransFuncExpand');
    MASK.ROI(n) = ROI;
end

MASK.Suffix = 'TfExpand';
MASK = rmfield(MASK,'TF');

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);

