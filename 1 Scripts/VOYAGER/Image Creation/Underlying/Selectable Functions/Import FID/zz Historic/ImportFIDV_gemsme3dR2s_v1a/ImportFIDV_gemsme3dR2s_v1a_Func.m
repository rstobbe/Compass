%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_gemsme3dR2s_v1a_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DCCOR = FID.DCCOR;
clear INPUT;

%-------------------------------------------
% Read in parameters (Robarts)
%-------------------------------------------
ExpPars = readprocpar(FID.path);
ExpPars.rosamp = 1;

%-------------------------------------------
% Read additional params
%-------------------------------------------
%namesExpPars1 = fieldnames(ExpPars);
%cellExpPars1 = struct2cell(ExpPars);
%[Text,err] = Load_ProcparV_v1a([FID.path,'procpar']);
%if err.flag 
%    return
%end
%params = {''};
%out = Parse_ProcparV_v1a(Text,params);
%ExpPars2 = cell2struct([cellExpPars1;out.'],[namesExpPars1;params.'],1);

%-------------------------------------------
% Get relevant variables
%-------------------------------------------
np = ExpPars.np/2;
nv = ExpPars.nv;
nv2 = ExpPars.nv2;
ne = ExpPars.ne;
ppe = ExpPars.ppe;
ppe2 = ExpPars.ppe2;
lpe = ExpPars.lpe;
lpe2 = ExpPars.lpe2;
nrcvrs = ExpPars.nrcvrs;
ad = ExpPars.arraydim/(nrcvrs*nv2);

%-------------------------------------------
% Read in data
%-------------------------------------------
FIDmat = readfid(FID.path,ExpPars,true,false,true);

%-------------------------------------------
% Reshape into image size
%-------------------------------------------
FIDmat = reshape(FIDmat,[np ne nv nrcvrs nv2 ad]);
FIDmat = permute(FIDmat,[1 3 5 2 4 6]);

%-------------------------------------------
% Apply ppe1 shift (phase encode position)
%-------------------------------------------
if ppe ~= 0
    pix = -0.5*ppe./(lpe./nv);
    ph_ramp = exp(1i*2*pi*pix*(-1:2/nv:1-1/nv));
    FIDmat = FIDmat .* repmat(ph_ramp,[np 1 nv2 ne nrcvrs ad]);
end

%-------------------------------------------
% Apply ppe2 shift (phase encode position)
%-------------------------------------------
% - fix? (see mpflash3d) -
if ppe2 ~= 0
    pix = 0.5*ppe2./(lpe2./nv2);
    ph_ramp = exp(1i*2*pi*pix*(-1:2/nv2:1-1/nv2));
    ph_ramp = reshape(ph_ramp,[1 1 nv2]);
    FIDmat = FIDmat .* repmat(ph_ramp,[np nv 1 ne nrcvrs ad]);
end

%-------------------------------------------
% Define pss
%-------------------------------------------
pss = -lpe2/2-lpe2/nv2/2:lpe2/nv2:lpe2/2;
ExpPars.pss = pss + ppe2;

%--------------------------------------------
% DC correction
%--------------------------------------------
func = str2func([FID.dccorfunc,'_Func']);  
INPUT.FIDmat = FIDmat;
INPUT.nrcvrs = nrcvrs;
INPUT.imtype = '3Dmulti';
[DCCOR,err] = func(DCCOR,INPUT);
if err.flag
    return
end
clear INPUT;
FIDmat = DCCOR.FIDmat;

%--------------------------------------------
% Image Params for Recon
%--------------------------------------------
ReconPars.Imfovro = 10*ExpPars.lro;
ReconPars.Imfovpe1 = 10*ExpPars.lpe;
ReconPars.Imfovpe2 = 10*ExpPars.lpe2;
ReconPars.Imvoxro = 10*ExpPars.lro/(ExpPars.np/2);
ReconPars.Imvoxpe1 = 10*ExpPars.lpe/ExpPars.nv;
ReconPars.Imvoxpe2 = 10*ExpPars.lpe2/ExpPars.nv2;
ReconPars.orient = ExpPars.orient;

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


