%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_mpflash3d_v2a_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT;

%-------------------------------------------
% Read in parameters
%-------------------------------------------
ExpPars = readprocpar(FID.path)

%-------------------------------------------
% Get relevant variables
%-------------------------------------------
np = ExpPars.np/2;
nv = ExpPars.nv;
nv2 = ExpPars.nv2;
ppe = ExpPars.ppe;
ppe2 = ExpPars.ppe2;
lpe = ExpPars.lpe;
lpe2 = ExpPars.lpe2;
nseg = ExpPars.nseg;
nrcvrs = ExpPars.nrcvrs;

%-------------------------------------------
% Read in data
%-------------------------------------------
%FIDmat = readfid(FID.path,ExpPars,true,false,true);
FIDmat = ImportFIDgenV_v1a([FID.path,'\fid'],nrcvrs);

%-------------------------------------------
% Test
%-------------------------------------------
sz = size(FIDmat);
if sz(1)~= np || sz(2)~= nv || sz(3)~= nv2 || sz(4)~= nrcvrs
    err.flag = 1;
    err.msg = 'FID file err. Probably Using Pre-Processed File.';
    return
end

%-------------------------------------------
% Sort Segmentation (coded on nv dimension)
%-------------------------------------------
steps = [(1:nseg:nv) (2:nseg:nv)];
[~,inds] = sort(steps);
FIDmat = FIDmat(:,inds,:,:);
%test1 = max(abs(kdata(:)))

%-------------------------------------------
% Apply ppe shift (phase encode position)
%-------------------------------------------
if ppe ~= 0
    pix = -0.5*ppe./(lpe./nv);
    ph_ramp = exp(1i*2*pi*pix*(-1:2/nv:1-1/nv));
    FIDmat = FIDmat .* repmat(ph_ramp,[np 1 nv2 nrcvrs]);
end

%-------------------------------------------
% Apply ppe2 shift (phase encode2 position)
%-------------------------------------------
if ppe2 ~= 0
    pix = 0.5*ppe2./(lpe2./nv2);
    ph_ramp0 = exp(1i*2*pi*pix*(-1:2/nv2:1-1/nv2));
    ph_ramp1 = repmat(ph_ramp0,[nv 1 nrcvrs np]);
    ph_ramp = permute(ph_ramp1,[4 1 2 3]);
    FIDmat = FIDmat .* ph_ramp;
end


%--------------------------------------------
% FlipDim
%--------------------------------------------
FIDmat = flipdim(FIDmat,3);

%--------------------------------------------
% Image Params for Recon
%--------------------------------------------
ReconPars.fovx = 10*ExpPars.lro;
ReconPars.fovy = 10*ExpPars.lpe;
ReconPars.fovz = ExpPars.thk*ExpPars.ns;
ReconPars.voxx = 10*ExpPars.lro/(ExpPars.np/2);
ReconPars.voxy = 10*ExpPars.lpe/ExpPars.nv;
ReconPars.voxz = ExpPars.thk;

%--------------------------------------------
% Panel
%--------------------------------------------
n = 1;
Panel(n,:) = {'FID',FID.DatName,'Output'};
n = n+1;
Panel(n,:) = {'Date',ExpPars.date,'Output'};
n = n+1;
Panel(n,:) = {'','','Output'};
n = n+1;
Panel(n,:) = {'TR',ExpPars.tr,'Output'};
n = n+1;
Panel(n,:) = {'TE',ExpPars.te,'Output'};
if strcmp(ExpPars.ir,'y')
    n = n+1;
    Panel(n,:) = {'TI',ExpPars.ti,'Output'};
end
n = n+1;
Panel(n,:) = {'ESP',ExpPars.esp,'Output'};
n = n+1;
Panel(n,:) = {'','','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FID.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
FID.FIDmat = FIDmat;
FID.ExpPars = ExpPars;
FID.ReconPars = ReconPars;
Status2('done','',2);
Status2('done','',3);


