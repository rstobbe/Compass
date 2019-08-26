%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_sems_v1a_Func(FID,INPUT)

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
ns = ExpPars.ns;
pro = ExpPars.pro;
ppe = ExpPars.ppe;
lro = ExpPars.lro;
lpe = ExpPars.lpe;
thk = ExpPars.thk;
gap = ExpPars.gap;
nrcvrs = ExpPars.nrcvrs;
ExpPars = ExpPars;

%-------------------------------------------
% Read in data
%-------------------------------------------
FIDmat = ImportFIDgenV_v1a([FID.path,'\fid'],nrcvrs);
sz = size(FIDmat);

%-------------------------------------------
% Test
%-------------------------------------------
%rvec = [np nv ns nrcvrs 1];
%FIDmat = reshape(FIDmat,rvec);
pvec = [1 3 2 5 4];
FIDmat = permute(FIDmat,pvec);
sz = size(FIDmat);
if sz(1)~= np || sz(2)~= nv || sz(3)~= ns || sz(5)~= nrcvrs
    err.flag = 1;
    err.msg = 'FID file err';
    return
end

%--------------------------------------------
% FlipDim
%--------------------------------------------
%FIDmat = flipdim(FIDmat,3);

%--------------------------------------------
% DC correction
%--------------------------------------------
func = str2func([FID.dccorfunc,'_Func']);  
INPUT.FIDmat = FIDmat;
INPUT.nrcvrs = nrcvrs;
INPUT.imtype = '2D';
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
ReconPars.Imfovslc = ExpPars.ns*(ExpPars.thk+ExpPars.gap);
ReconPars.Imvoxro = 10*ExpPars.lro/(ExpPars.np/2);
ReconPars.Imvoxpe1 = 10*ExpPars.lpe/ExpPars.nv;
ReconPars.Imvoxslc = (ExpPars.thk+ExpPars.gap);
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
if strcmp(ExpPars.ir,'y')
    n = n+1;
    Panel(n,:) = {'TI',ExpPars.ti,'Output'};
end
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


