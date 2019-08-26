%===========================================
% 
%===========================================

function [IMG,err] = Combine3TShimCal_v1a_Func(IMG,INPUT)

Status('busy','Combine Images');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG1 = INPUT.IMG1;
IMG2 = INPUT.IMG2;
ShimFile = INPUT.ShimFile;
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
sz = size(IMG1.Im);
Im = cat(length(sz)+1,IMG1.Im,IMG2.Im);

IMG = IMG1;
ExpPars = IMG1.ExpPars;
ExpPars.te1 = IMG1.ExpPars.te;
ExpPars.te2 = IMG2.ExpPars.te;
IMG.ExpPars = ExpPars;

ReconPars = IMG1.ReconPars;
ReconPars.te1 = IMG1.ExpPars.te;
ReconPars.te2 = IMG2.ExpPars.te;
IMG.ReconPars = ReconPars;

IMG.Im = Im;

%---------------------------------------------
% Read Shim Info
%---------------------------------------------
Shim = ReadShimsMRS_v1a(ShimFile.file);
IMG.FID.Shim = Shim;
IMG.name = 'CombinedImage';

%---------------------------------------------
% Panel Update
%---------------------------------------------
PanelOutput0 = IMG.PanelOutput;
n = 1;
Panel(n,:) = {'','','Output'};
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
PanelOutput = [PanelOutput0;cell2struct(Panel,{'label','value','type'},2)];

IMG.PanelOutput = PanelOutput;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

