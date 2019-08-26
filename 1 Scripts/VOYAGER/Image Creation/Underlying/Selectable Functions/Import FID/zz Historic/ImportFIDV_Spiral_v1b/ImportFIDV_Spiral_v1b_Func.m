%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_Spiral_v1b_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IC.IMP;
DCCOR = FID.DCCOR;
clear INPUT;

%---------------------------------------------
% Build Structure to Test with AcqPars
%---------------------------------------------
ImpPars.fov = IMP.impPROJdgn.fov;
ImpPars.vox = IMP.impPROJdgn.vox;
ImpPars.elip = IMP.impPROJdgn.elip;
ImpPars.nproj = IMP.PROJimp.nproj;
ImpPars.tro = IMP.PROJimp.tro;
ImpPars.sampstart = round(IMP.PROJimp.sampstart*1000*1e9)/1e9;
ImpPars.dwell = round(IMP.PROJimp.dwell*1000*1e9)/1e9;
ImpPars.fb = IMP.TSMP.filtBW;

%---------------------------------------------
% Get Parameters
%---------------------------------------------
[Text,err] = Load_ParamsV_v1a([FID.path,'\params']);
if err.flag == 1
    return
end
[ProcPar,err] = Load_ProcparV_v1a([FID.path,'procpar']);
if err.flag == 1
    return
end

%---------------------------------------------
% Create Parameter Structure 
%---------------------------------------------
func = str2func('CreateParamStructV_Spiral_v1a');
[ExpPars,err] = func(Text);
if err.flag == 1;
    return
end

%---------------------------------------------
% Compare
%---------------------------------------------
params = {'fov','vox','elip','nproj','tro','sampstart','dwell','fb'};
out = Parse_ProcparV_v1a(ProcPar,params);
AcqPars = cell2struct(out.',params.',1);
[~,~,comperr] = comp_struct(ImpPars,AcqPars,'ImpPars','AcqPars');
if not(isempty(comperr))
    err.flag = 1;
    err.msg = 'Data Does Not Match ''Imp_File''';
    return
end

%-------------------------------------------
% Get Array Info
%-------------------------------------------
[ArrayParams,err] = ArrayAssessVarian_v1b(ProcPar);           
if length(ArrayParams) > 1
    err.flag = 1;
    err.msg = 'ImportFIDfunc does not handle multidim arrays';
    return
end
if not(isempty(ArrayParams))
    Array.ArrayParams = ArrayParams{1};
    Array.ArrLen = ArrayParams{1}.ArrayLength;
    Array.ArrayName = ArrayParams{1}.ArrayName;
    ExpPars.Array = Array;
    blocks = Array.ArrLen;
else
    blocks = 1;
end

%---------------------------------------------
% Get Necessary Params
%---------------------------------------------
%slices = ExpPars.Acq.slices;
params = {'ns'};
out = Parse_ProcparV_v1a(ProcPar,params);
slices = out{1};
npro = IMP.PROJimp.npro;
nproj = IMP.PROJimp.nproj;
nrcvrs = 1;                         

%---------------------------------------------
% Load FID
%---------------------------------------------
[FIDmat0,FIDparams] = ImportSplitArrayFIDmatV_v1a([FID.path,'\fid']);

%---------------------------------------------
% Fix array
%---------------------------------------------
FIDmat = zeros(nproj,npro,slices,blocks,nrcvrs);
FIDmat(1,:,:,:,:) = permute(FIDmat0,[2 1 3 4 5]);
% - will need future update once coil fixed

% test = (abs(FIDmat(1,:,10,1,1)));
% test = squeeze((real(FIDmat0(5,:,1))));
% figure(1); hold on;
% plot(test);
% test2 = max(abs(FIDmat0(:)))
% error()

%--------------------------------------------
% DC correction
%--------------------------------------------
func = str2func([FID.dccorfunc,'_Func']);  
INPUT.FIDmat = FIDmat;
INPUT.visuals = FID.visuals;
[DCCOR,err] = func(DCCOR,INPUT);
if err.flag
    return
end
clear INPUT;
FIDmat = DCCOR.FIDmat;
DCCOR = rmfield(DCCOR,'FIDmat');
DataInfo.dcvals = DCCOR.dcvals;
DataInfo.meandcvals = DCCOR.meandcvals;

%--------------------------------------------
% Data Test
%--------------------------------------------
[DataInfo,err] = DataTestVarian_v1a(DataInfo,FIDmat);
if err.flag == 1
    return
end

%--------------------------------------------
% k-Space Plot
%--------------------------------------------
% figure(1000); hold on;
% sz = size(FIDmat);
% plot(abs(FIDmat(1,:,1,1)))
% plot(real(FIDmat(1,:,1,1)))
% plot(imag(FIDmat(1,:,1,1)))

%--------------------------------------------
% Image Params for Recon
%--------------------------------------------
ReconPars.Imfovx = AcqPars.fov;
ReconPars.Imfovy = AcqPars.fov;
ReconPars.Imfovz = AcqPars.fov;     %update...
ReconPars.slices = slices;
ReconPars.blocks = blocks;
ReconPars.nrcvrs = nrcvrs;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'FID',FID.DatName,'Output'};
Panel(2,:) = {'',Text,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FID.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
FID.DataInfo = DataInfo;
FID.FIDmat = FIDmat;
FID.ExpPars = ExpPars;
FID.ReconPars = ReconPars;
FID.DCCOR = DCCOR;


Status2('done','',2);
Status2('done','',3);


