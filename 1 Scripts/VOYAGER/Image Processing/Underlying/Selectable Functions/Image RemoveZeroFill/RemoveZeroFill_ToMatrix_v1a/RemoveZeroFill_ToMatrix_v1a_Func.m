%=====================================================
%
%=====================================================

function [ZF,err] = RemoveZeroFill_ToMatrix_v1a_Func(ZF,INPUT)

Status2('busy','Remove ZeroFill',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Get Input
%--------------------------------------------- 
if isfield(IMG,'ExpPars')
    Acq = IMG.ExpPars.Acq;
end
fov = Acq.fov;
rzfsz = ZF.zfdims;

%---------------------------------------------
% Zero-Fill
%---------------------------------------------
kdat = zeros(size(IMG.Im));
sz = size(kdat);
for n = 1:sz(4)
    kdat(:,:,:,n) = fftshift(ifftn(ifftshift(IMG.Im(:,:,:,n))));
end
bot = ceil((sz(1:3) - rzfsz)/2)+1;
top = bot + rzfsz - 1;
zfkdat = kdat(bot(1):top(1),bot(2):top(2),bot(3):top(3),:);
IMG.Im = zeros(size(zfkdat));
for n = 1:sz(4)
    IMG.Im(:,:,:,n) = fftshift(fftn(ifftshift(zfkdat(:,:,:,n))));
end

%---------------------------------------------
% Update ReconPars
%---------------------------------------------
factor = rzfsz./sz(1:3);
if isfield(IMG,'ReconPars')
    ReconPars = IMG.ReconPars;
    ReconPars.ImszTB = rzfsz(1);
    ReconPars.ImszLR = rzfsz(2);
    ReconPars.ImszIO = rzfsz(3);
    ReconPars.ImvoxTB = ReconPars.ImvoxTB/factor(1);
    ReconPars.ImvoxLR = ReconPars.ImvoxLR/factor(2);
    ReconPars.ImvoxIO = ReconPars.ImvoxIO/factor(3);
    ReconPars.ImfovTB = ReconPars.ImszTB*ReconPars.ImvoxTB;
    ReconPars.ImfovLR = ReconPars.ImszLR*ReconPars.ImvoxLR;
    ReconPars.ImfovIO = ReconPars.ImszIO*ReconPars.ImvoxIO;
    IMG.ReconPars = ReconPars;
end

%---------------------------------------------
% Update ImDisp
%---------------------------------------------
IMG.IMDISP.IMDIM.x2 = rzfsz(2);
IMG.IMDISP.IMDIM.y2 = rzfsz(1);
IMG.IMDISP.IMDIM.z2 = rzfsz(3);
IMG.IMDISP.SCALE.xmax = IMG.IMDISP.IMDIM.x2+0.5;
IMG.IMDISP.SCALE.ymax = IMG.IMDISP.IMDIM.y2+0.5;
IMG.IMDISP.SCALE.zmax = IMG.IMDISP.IMDIM.z2+0.5;

IMG.IMDISP.ImInfo.pixdim = fov./rzfsz;
IMG.IMDISP.ImInfo.vox = IMG.IMDISP.ImInfo.pixdim(1)*IMG.IMDISP.ImInfo.pixdim(2)*IMG.IMDISP.ImInfo.pixdim(3);

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',ZF.method,'Output'};
Panel(3,:) = {'ZeroFill Matrix',ZF.zfdims,'Output'};
Panel(4,:) = {'Voxel(mm)',[num2str(IMG.IMDISP.ImInfo.pixdim(1),'%2.2f'),' x ',num2str(IMG.IMDISP.ImInfo.pixdim(2),'%2.2f'),' x ',num2str(IMG.IMDISP.ImInfo.pixdim(3),'%2.2f')],'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
IMG.IMDISP.ImInfo.info = IMG.ExpDisp;

%---------------------------------------------
% Return
%---------------------------------------------
if strfind(IMG.name,'.mat')
    IMG.name = IMG.name(1:end-4);
end
IMG.name = [IMG.name,'_rZF'];
ZF.IMG = IMG;

Status2('done','',2);
Status2('done','',3);



