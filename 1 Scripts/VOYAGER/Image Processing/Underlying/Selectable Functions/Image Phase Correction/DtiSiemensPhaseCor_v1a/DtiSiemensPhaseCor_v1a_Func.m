%=========================================================
% 
%=========================================================

function [PCOR,err] = DtiSiemensPhaseCor_v1a_Func(PCOR,INPUT)

Status2('busy','Phase Correct Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG{1};
AbsIm = INPUT.IMG{1}.Im;
PhaseIm = INPUT.IMG{2}.Im;
clear INPUT;

%---------------------------------------------
% Analyze Slice
%---------------------------------------------
Slc = 38;
AbsIm = AbsIm(:,:,Slc,:);
PhaseIm = PhaseIm(:,:,Slc,:);
sz = size(AbsIm);

%---------------------------------------------
% Create CSF Mask
%---------------------------------------------
Mask0 = mean(AbsIm(:,:,:,32:61),4);
NanCsfMask = ones(size(Mask0));
ZeroCsfMask = ones(size(Mask0));
NanCsfMask(Mask0<20) = NaN;
ZeroCsfMask(Mask0<20) = 0;

%---------------------------------------------
% StripMask
%---------------------------------------------
StripMask02 = ones(sz(1),sz(2));
StripMask02((AbsIm(:,:,1,1))<170) = 0;

%---------------------------------------------
% Create Complex Image
%---------------------------------------------
PhaseIm = 2*pi*PhaseIm/4095;
Im = AbsIm .* exp(1i*PhaseIm);

%---------------------------------------------
% Create Complex Image
%---------------------------------------------
Im2 = zeros(size(Im));
bot = 101;
top = 156;
dim = top-bot+1;
beta = 8;

Filt0 = Kaiser2D_v1b(dim,dim,beta,'unsym');
Filt = zeros(sz(1),sz(2));
Filt(bot:top,bot:top) = Filt0; 

for n = 1:sz(4)
    Im0 = Im(:,:,1,n).*StripMask02.*ZeroCsfMask;
    Ft0 = fftshift(fftn(Im0));
    FtLow = zeros(size(Ft0));
    FtLow(bot:top,bot:top) = Ft0(bot:top,bot:top); 
    
%     figure(2134678); hold on;
%     plot(Filt(:,sz(1)/2+1)/max(Filt(:)));
%     plot(abs(FtLow(:,sz(1)/2+1))/max(abs(FtLow(:))));    
    
    Im2(:,:,1,n) = ifftn(ifftshift(FtLow.*Filt));
end

%---------------------------------------------
% Mask Outside
%---------------------------------------------
StripMask01 = ones(sz(1),sz(2));
StripMask01(abs(Im2(:,:,1,1))<230) = 0;
StripMask01(80:180,80:180) = 1;

%---------------------------------------------
% Total Mask
%---------------------------------------------
Mask0 = StripMask01.*StripMask02.*ZeroCsfMask;
Mask = repmat(Mask0,[1 1 1 65]);

%---------------------------------------------
% Return
%---------------------------------------------
PhaseIm = Mask.*Im2;

OutIm = Im.*exp(-1i*angle(PhaseIm));

ImArr = cat(5,Im,PhaseIm,OutIm);

IMG.Im = single(ImArr);

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PCOR.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
if isfield(IMG,'PanelOutput')
    IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
else
     IMG.PanelOutput = PanelOutput; 
end
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);

%---------------------------------------------
% Return
%---------------------------------------------
if strfind(IMG.name,'.mat')
    IMG.name = IMG.name(1:end-4);
end
IMG.name = [IMG.name,'_Cplx'];
PCOR.IMG = IMG;

Status2('done','',2);
Status2('done','',3);
