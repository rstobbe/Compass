%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDM_Shim_v1a_Func(FID,INPUT)

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
[FIDmat0,DataInfo,err] = ReadSMIS3d_v1a([FID.path,FID.file]);
Pars = DataInfo.Pars;

%------------------------------------------
% Build Structure
%------------------------------------------ 
ExpPars.tof = str2double(ParseParsSMIS_v1(Pars,'"1H"'));
ExpPars.np = str2double(ParseParsSMIS_v1(Pars,'no_samples'));
ExpPars.nv1 = str2double(ParseParsSMIS_v1(Pars,'no_views'));
ExpPars.nv2 = str2double(ParseParsSMIS_v1(Pars,'no_views_2'));
ExpPars.fovro = str2double(ParseParsSMIS_v1(Pars,'FOV'));
ExpPars.fovpe1 = ExpPars.fovro;
ExpPars.fovpe2 = str2double(ParseParsSMIS_v1(Pars,'fov_sl'));
ExpPars.no_experiments = str2double(ParseParsSMIS_v1(Pars,'no_experiments'));

ExpPars.Efa = str2double(ParseParsSMIS_v1(Pars,'alpha'));
ExpPars.Epw = '';
ExpPars.tr = str2double(ParseParsSMIS_v1(Pars,'tr'));
ExpPars.te1 = str2double(ParseParsSMIS_v1(Pars,'te1'))/1000;
if ExpPars.no_experiments > 1
    ExpPars.te2 = str2double(ParseParsSMIS_v1(Pars,'te2'))/1000;
end
if ExpPars.no_experiments > 2
    ExpPars.te3 = str2double(ParseParsSMIS_v1(Pars,'te3'))/1000;
end

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
ExpPars.orp = 1;

%-------------------------------------------
% Rearrange Data
%-------------------------------------------
FIDmat0 = permute(FIDmat0,[1 2 3 6 5 4]);
test = size(FIDmat0);

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
        tFIDmat = abs(log(abs(squeeze(FIDmat0(:,:,:,1,n,:)))));
        tFIDmat(isinf(tFIDmat)) = 0;
        IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = nv2; 
        IMSTRCT.rows = floor(sqrt(nv2)+2); IMSTRCT.lvl = [0 max(abs(tFIDmat(:)))]; IMSTRCT.SLab = 1; IMSTRCT.figno = 2000+n; 
        IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
        AxialMontage_v2a(tFIDmat,IMSTRCT);
    end
end

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
DCCOR = rmfield(DCCOR,'FIDmat');
clear FIDmat0;

%---------------------------------------------
% Plot  (update for nrcvrs > 1)
%---------------------------------------------
FID.visuals = 'Yes';
if strcmp(FID.visuals,'Yes');
end

%---------------------------------------------
% Max Value Test
%---------------------------------------------
MaxRealVal = max(real(FIDmat(:)));
MaxImagVal = max(imag(FIDmat(:)));
MaxAbsVal = max(abs(FIDmat(:)));
%MaxRealVal
%MaxImagVal
%MaxAbsVal

%--------------------------------------------
% Image Params for Recon
%--------------------------------------------
ReconPars.Imfovro = ExpPars.fovro*ExpPars.rosamp;
ReconPars.Imfovpe1 = ExpPars.fovpe1;
ReconPars.Imfovpe2 = ExpPars.fovpe2;
ReconPars.Imvoxro = ExpPars.fovro*ExpPars.rosamp/ExpPars.np;
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
Panel(n,:) = {'ecc',ExpPars.ecc,'Output'};
n = n+1;
Panel(n,:) = {'TE1 (ms)',ExpPars.te1,'Output'};
n = n+1;
if ExpPars.no_experiments > 1
    Panel(n,:) = {'TE2 (ms)',ExpPars.te2,'Output'};
    n = n+1;
end
if ExpPars.no_experiments > 2
    Panel(n,:) = {'TE3 (ms)',ExpPars.te3,'Output'};
    n = n+1;
end

%---------------------------------------------
% Read Shim Info
%---------------------------------------------
Shim = ReadShimsMRS_v1a(FID.shim);
Shim.tof = ExpPars.tof;

%---------------------------------------------
% Panel Update
%---------------------------------------------
Panel(n,:) = {'','','Output'};
n = n+1;
Panel(n,:) = {'Freq (Hz)',Shim.tof,'Output'};
n = n+1;
Panel(n,:) = {'X',Shim.X,'Output'};
n = n+1;
Panel(n,:) = {'Y',Shim.Y,'Output'};
n = n+1;
Panel(n,:) = {'Z',Shim.Z,'Output'};
n = n+1;
Panel(n,:) = {'B0',Shim.B0,'Output'};
n = n+1;
Panel(n,:) = {'ZX',Shim.ZX,'Output'};
n = n+1;
Panel(n,:) = {'ZY',Shim.ZY,'Output'};
n = n+1;
Panel(n,:) = {'S2',Shim.S2,'Output'};
n = n+1;
Panel(n,:) = {'C2',Shim.C2,'Output'};
n = n+1;
Panel(n,:) = {'Z2',Shim.Z2,'Output'};
n = n+1;
Panel(n,:) = {'Z2X',Shim.Z2X,'Output'};
n = n+1;
Panel(n,:) = {'Z2Y',Shim.Z2Y,'Output'};
n = n+1;
Panel(n,:) = {'S3',Shim.S3,'Output'};
n = n+1;
Panel(n,:) = {'C3',Shim.C3,'Output'};
n = n+1;
Panel(n,:) = {'Z3',Shim.Z3,'Output'};
n = n+1;
Panel(n,:) = {'ZC2',Shim.ZC2,'Output'};
n = n+1;
Panel(n,:) = {'ZS2',Shim.ZS2,'Output'};
n = n+1;
Panel(n,:) = {'Z4',Shim.Z4,'Output'};
n = n+1;
Panel(n,:) = {'Z5',Shim.Z5,'Output'};
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
FID.DCCOR = DCCOR;
Status2('done','',2);
Status2('done','',3);


