%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_SPGR3dMT_v1a_Func(FID,INPUT)

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
% Read Parameters
%-------------------------------------------
[Text,err] = Load_ProcparV_v1a([FID.path,'procpar']);
if err.flag 
    return
end
params = {'np','nv1','nv2','fovro','fovpe1','fovpe2','voxpe1','rcvrs','rosamp','rfilt',...
          'rfcoil','gcoil',...
          'Efa','Epw','MTpw','MTfa','MToff','tr','te','tro','fildel','graddel','orp',...
          'tof','date','comment','subject'};
out = Parse_ProcparV_v1a(Text,params);
ExpPars = cell2struct(out.',params.',1);

%-------------------------------------------
% Count Numbers of Receivers
%-------------------------------------------
ExpPars.nrcvrs = length(strfind(ExpPars.rcvrs,'y'));

%-------------------------------------------
% Read Shim Values
%-------------------------------------------
params = {'z1c','z2c','z3c','z4c','x1','y1',...
          'xz','yz','xy','x2y2','x3','y3','xz2','yz2','zxy','zx2y2',...
          'tof'};
out = Parse_ProcparV_v1a(Text,params);
Shim = cell2struct(out.',params.',1);

%-------------------------------------------
% Get relevant variables
%-------------------------------------------
np = ExpPars.np/2;
nv1 = ExpPars.nv1;
nv2 = ExpPars.nv2;
nrcvrs = ExpPars.nrcvrs;

%-------------------------------------------
% Read in data
%-------------------------------------------
FIDmat0 = ImportFIDgenV_v1a([FID.path,'\fid'],nrcvrs);
sz = size(FIDmat0);
if length(sz) == 3
    sz(4) = 1;
end

%-------------------------------------------
% Visuals
%-------------------------------------------
testing = 'No';
if strcmp(testing,'Yes');
    figure(1000); hold on;                         
    plot(abs(FIDmat0(1,:)));
    title('First Data Point Magnitude Test');
    xlabel('Trajectory Number');
    
    figure(1001); hold on;
    plot(abs(mean(mean(FIDmat0,2),3)));
    title('Readout Centre Test');
    xlabel('Readout Sample Number');       
end
    
%-------------------------------------------
% Sort
%-------------------------------------------
FIDmat = zeros(np,nv1,nv2,2,nrcvrs);
for m = 1:nv2
    for n = 1:nv1
        FIDmat(:,n,m,:,:) = FIDmat0(:,((m-1)*nv2)+n,:,:);
    end
end

%-------------------------------------------
% Test
%-------------------------------------------
sz = size(FIDmat);
if length(sz) == 4
    sz(5) = 1;
end
if sz(1)~= np || sz(2)~= nv1 || sz(3)~= nv2 || sz(4)~= 2 || sz(5)~= nrcvrs
    err.flag = 1;
    err.msg = 'FID file err. Probably Using Pre-Processed File.';
    return
end

%-------------------------------------------
% Visuals
%-------------------------------------------
if strcmp(FID.visuals,'Yes');
    for n = 1:nrcvrs
        figure(2000); hold on;
        plot(squeeze(abs(FIDmat(np/2,nv1/2,:,1,n))));
        plot(squeeze(abs(FIDmat(np/2,:,nv2/2,1,n))));
        title('Phase Encode Centre Test');
        xlabel('Phanse Encode Number');      

        tFIDmat = squeeze(FIDmat(:,:,:,1,n));
        IMSTRCT.type = 'imag'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = nv2; 
        IMSTRCT.rows = floor(sqrt(nv2)+1); IMSTRCT.lvl = [-max(abs(tFIDmat(:))) max(abs(tFIDmat(:)))]; IMSTRCT.SLab = 0; IMSTRCT.figno = 2000+n; 
        IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
        AxialMontage_v2a(tFIDmat,IMSTRCT);
    end
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
INPUT.imtype = '3Dmulti';
[DCCOR,err] = func(DCCOR,INPUT);
if err.flag
    return
end
clear INPUT;
FIDmat = DCCOR.FIDmat;

%---------------------------------------------
% Plot  (update for nrcvrs > 1)
%---------------------------------------------
FID.visuals = 'Yes';
if strcmp(FID.visuals,'Yes');
end

%---------------------------------------------
% Max Value Test
%---------------------------------------------
for n = 1:nrcvrs
    for m = 1:2
        tFIDmat = FIDmat(:,:,:,m,n);
        MaxRealVal(m,n) = max(real(tFIDmat(:)));
        MaxImagVal(m,n) = max(imag(tFIDmat(:)));
        MaxAbsVal(m,n) = max(abs(tFIDmat(:)));
    end
end
%MaxRealVal
%MaxImagVal
%MaxAbsVal

%--------------------------------------------
% Image Params for Recon
%--------------------------------------------
ReconPars.Imfovro = ExpPars.fovro*ExpPars.rosamp;
ReconPars.Imfovpe1 = ExpPars.fovpe1;
ReconPars.Imfovpe2 = ExpPars.fovpe2;
ReconPars.Imvoxro = ExpPars.fovro*ExpPars.rosamp/(ExpPars.np/2);
ReconPars.Imvoxpe1 = ExpPars.fovpe1/ExpPars.nv1;
ReconPars.Imvoxpe2 = ExpPars.fovpe2/ExpPars.nv2;
ReconPars.orp = ExpPars.orp;

%--------------------------------------------
% Panel
%--------------------------------------------
n = 1;
Panel(n,:) = {'FID',FID.DatName,'Output'};
n = n+1;
Panel(n,:) = {'Date',ExpPars.date,'Output'};
n = n+1;
Panel(n,:) = {'Subject',ExpPars.subject,'Output'};
n = n+1;
Panel(n,:) = {'Comment',ExpPars.comment,'Output'};
n = n+1;
Panel(n,:) = {'','','Output'};
n = n+1;
Panel(n,:) = {'TR (ms)',ExpPars.tr,'Output'};
n = n+1;
Panel(n,:) = {'TE (ms)',ExpPars.te,'Output'};
n = n+1;
Panel(n,:) = {'flip (deg)',ExpPars.Efa,'Output'};
n = n+1;
Panel(n,:) = {'pw (us)',ExpPars.Epw,'Output'};
n = n+1;
Panel(n,:) = {'MTfa (ms)',ExpPars.MTfa,'Output'};
n = n+1;
Panel(n,:) = {'MToff (Hz)',ExpPars.MToff,'Output'};
n = n+1;
Panel(n,:) = {'MTpw (ms)',ExpPars.MTpw,'Output'};
n = n+1;
Panel(n,:) = {'Tro (ms)',ExpPars.tro,'Output'};
n = n+1;
Panel(n,:) = {'rfcoil',ExpPars.rfcoil,'Output'};
n = n+1;
Panel(n,:) = {'gcoil',ExpPars.gcoil,'Output'};
n = n+1;
Panel(n,:) = {'','','Output'};

PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FID.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
FID.FIDmat = FIDmat;
FID.ExpPars = ExpPars;
FID.Shim = Shim;
FID.ReconPars = ReconPars;
Status2('done','',2);
Status2('done','',3);


