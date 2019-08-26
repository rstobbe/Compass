%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDSim_SampDat_v1a_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SYS = INPUT.IC.IMP.SYS;
PROJdgn = INPUT.IC.IMP.impPROJdgn;
SAMP = FID.SAMP;
if isfield(INPUT.IC.IMP,'GWFM')
    if isfield(INPUT.IC.IMP.GWFM,'ORNT')
        ORNT = INPUT.IC.IMP.GWFM.ORNT;
    else
        ORNT.dimLR = PROJdgn.vox;
        ORNT.dimTB = PROJdgn.vox;
        ORNT.dimIO = PROJdgn.vox;
    end
else
    ORNT.dimLR = PROJdgn.vox;
    ORNT.dimTB = PROJdgn.vox;
    ORNT.dimIO = PROJdgn.vox;
end
if not(isfield(SYS,'PhysMatRelation'))
    SYS.PhysMatRelation = [];
end
clear INPUT;

%--------------------------------------------
% Image Params for Recon
%--------------------------------------------
ReconPars.ImfovLR = PROJdgn.fov;
ReconPars.ImfovTB = PROJdgn.fov;
ReconPars.ImfovIO = PROJdgn.fov;
ReconPars.ImvoxLR = ORNT.dimLR;
ReconPars.ImvoxTB = ORNT.dimTB;
ReconPars.ImvoxIO = ORNT.dimIO;
ReconPars.PhysMatRelation = SYS.PhysMatRelation;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'FID',FID.DatName,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FID.PanelOutput = [PanelOutput;SAMP.PanelOutput];
FID.ExpPars = [];

%--------------------------------------------
% Look For Multi-Echo
%--------------------------------------------
sz = size(SAMP.SampDat);
if length(sz) == 2
    sz(3) = 1;
end
FIDmat = zeros(sz(1),sz(2),1,1,1,sz(3));
FIDmat(:,:,1,1,1,:) = SAMP.SampDat;

%--------------------------------------------
% Return
%--------------------------------------------
FID = rmfield(FID,'SAMP');
FID.ReconPars = ReconPars;
FID.FIDmat = FIDmat;
FID.CreateZf = SAMP.ZF;
%FID.FIDmat = ones(size(FIDmat));

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);


