%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDSim_PointSpreadFunc_v1a_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SYS = INPUT.IC.IMP.SYS;
PROJdgn = INPUT.IC.IMP.impPROJdgn;
PROJimp = INPUT.IC.IMP.PROJimp;
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
FID.PanelOutput = PanelOutput;
FID.ExpPars = [];

%--------------------------------------------
% Look For Multi-Echo
%--------------------------------------------
echoes = 1;
FIDmat = complex(ones(PROJimp.nproj,PROJimp.npro,1,1,1,echoes),1e-12*ones(PROJimp.nproj,PROJimp.npro,1,1,1,echoes));

%--------------------------------------------
% Return
%--------------------------------------------
FID.ReconPars = ReconPars;
FID.FIDmat = FIDmat;

FID.path = '';

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);


