%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDM_SPGR3dShim_v1a_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DCCOR = FID.DCCOR;
clear INPUT;

%------------------------------------------
% Load Parameters / Data
%------------------------------------------ 
[FIDmat0,DataInfo,err] = ReadSMIS3d_v1a(FID.path);
Pars = DataInfo.Pars;

%------------------------------------------
% Build Structure
%------------------------------------------ 
ExpPars.np = str2double(ParseParsSMIS_v1(Pars,'no_samples'));
ExpPars.nv1 = str2double(ParseParsSMIS_v1(Pars,'no_views'));
ExpPars.nv2 = str2double(ParseParsSMIS_v1(Pars,'no_views_2'));
ExpPars.fovro = str2double(ParseParsSMIS_v1(Pars,'FOV'));
ExpPars.fovpe1 = ExpPars.fovro;
ExpPars.fovpe2 = str2double(ParseParsSMIS_v1(Pars,'fov_sl'));

ExpPars.Efa = str2double(ParseParsSMIS_v1(Pars,'alpha'));
ExpPars.Epw = '';
ExpPars.tr = str2double(ParseParsSMIS_v1(Pars,'tr'));
ExpPars.te1 = str2double(ParseParsSMIS_v1(Pars,'te'));
ExpPars.te2 = str2double(ParseParsSMIS_v1(Pars,'te'));

ind = strfind(Pars,'sample_period');
Text = Pars(ind:ind+200);
ind = strfind(Text,'KHz');
Text = Text(ind(1)+5:length(Text));
ind2 = strfind(Text,'s');
ExpPars.dwell = str2double(Text(2:ind2(1)-2))/1000;         % in us
ExpPars.tro = ExpPars.dwell * ExpPars.np;

ExpPars.nrcvrs = 1;
ExpPars.rosamp = 1;
ExpPars.rfcoil = '';
ExpPars.ecc = '';

ExpPars.tof = str2double(ParseParsSMIS_v1(Pars,'"1H"'));
ExpPars.date = '';
ExpPars.comment = '';
ExpPars.subject = '';

%-------------------------------------------
% Visuals
%-------------------------------------------
testing = 'No';
if strcmp(testing,'Yes');
    figure(1001); hold on;
    plot(abs(FIDmat0(:)));
    drawnow;
    title('Readout Centre Test');
    xlabel('Readout Sample Number');
end
    
%-------------------------------------------
% Visuals
%-------------------------------------------
nrcvrs = ExpPars.nrcvrs;
nv2 = ExpPars.nv2;
if strcmp(FID.visuals,'Yes');
    for n = 1:nrcvrs
        tFIDmat = abs(log(abs(squeeze(FIDmat0(:,:,:,1,n)))));
        tFIDmat(isinf(tFIDmat)) = 0;
        IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = nv2; 
        IMSTRCT.rows = floor(sqrt(nv2)+2); IMSTRCT.lvl = [0 max(abs(tFIDmat(:)))]; IMSTRCT.SLab = 1; IMSTRCT.figno = 2000+n; 
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
INPUT.FIDmat = FIDmat0;
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
Panel(n,:) = {'flip (deg)',ExpPars.Efa,'Output'};
n = n+1;
Panel(n,:) = {'pw (us)',ExpPars.Epw,'Output'};
n = n+1;
Panel(n,:) = {'Tro (ms)',ExpPars.tro,'Output'};
n = n+1;
Panel(n,:) = {'rfcoil',ExpPars.rfcoil,'Output'};
n = n+1;
Panel(n,:) = {'gcoil',ExpPars.gcoil,'Output'};
n = n+1;
Panel(n,:) = {'TE1 (ms)',ExpPars.te1,'Output'};
n = n+1;
Panel(n,:) = {'TE2 (ms)',ExpPars.te2,'Output'};
n = n+1;
Panel(n,:) = {'','','Output'};
n = n+1;
Panel(n,:) = {'tof (Hz)',ExpPars.tof,'Output'};
n = n+1;
Panel(n,:) = {'z1c',Shim.z1c,'Output'};
n = n+1;
Panel(n,:) = {'z2c',Shim.z2c,'Output'};
n = n+1;
Panel(n,:) = {'z3c',Shim.z3c,'Output'};
n = n+1;
Panel(n,:) = {'z4c',Shim.z4c,'Output'};
n = n+1;
Panel(n,:) = {'x1',Shim.x1,'Output'};
n = n+1;
Panel(n,:) = {'y1',Shim.y1,'Output'};
n = n+1;
Panel(n,:) = {'xz',Shim.xz,'Output'};
n = n+1;
Panel(n,:) = {'yz',Shim.yz,'Output'};
n = n+1;
Panel(n,:) = {'xy',Shim.xy,'Output'};
n = n+1;
Panel(n,:) = {'x2y2',Shim.x2y2,'Output'};
n = n+1;
Panel(n,:) = {'x3',Shim.x3,'Output'};
n = n+1;
Panel(n,:) = {'y3',Shim.y3,'Output'};
n = n+1;
Panel(n,:) = {'xz2',Shim.xz2,'Output'};
n = n+1;
Panel(n,:) = {'yz2',Shim.yz2,'Output'};
n = n+1;
Panel(n,:) = {'zxy',Shim.zxy,'Output'};
n = n+1;
Panel(n,:) = {'zx2y2',Shim.zx2y2,'Output'};
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


