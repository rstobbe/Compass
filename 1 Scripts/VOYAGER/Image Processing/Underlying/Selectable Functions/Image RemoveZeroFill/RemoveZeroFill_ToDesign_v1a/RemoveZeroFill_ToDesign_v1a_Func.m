%=====================================================
%
%=====================================================

function [ZF,err] = RemoveZeroFill_ToDesign_v1a_Func(ZF,INPUT)

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
vox = Acq.vox;
elip = Acq.elip;
fov = Acq.fov;

rzfsz0 = 2*round((elip*fov/vox)/2);
rzfsz = [rzfsz0/elip rzfsz0/elip rzfsz0];

%---------------------------------------------
% Zero-Fill
%---------------------------------------------
kdat = fftshift(ifftn(ifftshift(IMG.Im)));
sz = size(kdat);
bot = floor((sz - rzfsz)/2)+1;
top = bot + rzfsz - 1;
zfkdat = kdat(bot(1):top(1),bot(2):top(2),bot(3):top(3));
IMG.Im = fftshift(fftn(ifftshift(zfkdat)));

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



