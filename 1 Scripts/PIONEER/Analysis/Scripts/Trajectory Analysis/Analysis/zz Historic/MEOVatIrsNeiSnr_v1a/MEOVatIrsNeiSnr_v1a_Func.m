%======================================================
% 
%======================================================

function [ANLZ,err] = MEOVatIrsNeiSnr_v1a_Func(ANLZ,INPUT)

Status('busy','Calculate MEOV');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
%PSF = INPUT.PSF;
%PSD = INPUT.PSD;
vox = INPUT.PSF.PROJdgn.vox^3 / INPUT.PSF.PROJdgn.elip;

%---------------------------------------------
% Regression
%---------------------------------------------
options = optimset( 'Algorithm','trust-region-reflective',...
                    'Display','iter','Diagnostics','on',...
                    'FinDiffType','forward',...                    
                    'DiffMinChange',0.1,...                     
                    'TolFun',1e-5,...
                    'TolX',1e-4);
V0 = 25;
func = @(V)MEOVatIrsNeiSnr_v1a_Reg(V,ANLZ,INPUT);
lb = 1;
ub = 200;
V = lsqnonlin(func,V0,lb,ub,options);

%---------------------------------------------
% Test
%---------------------------------------------
[out,ANLZ] = MEOVatIrsNeiSnr_v1a_Reg(V,ANLZ,INPUT);

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'',[],'Output'};
Panel(2,:) = {'MEOV (voxels)',ANLZ.nob,'Output'};
Panel(3,:) = {'MEOV (mm3)',ANLZ.nob*vox,'Output'};
Panel(4,:) = {'Voxel (mm3)',vox,'Output'};
Panel(5,:) = {'IRS',ANLZ.aveirs,'Output'};
Panel(6,:) = {'IRSout',ANLZ.aveirsout,'Output'};
Panel(7,:) = {'rNEI',ANLZ.rnei,'Output'};
Panel(8,:) = {'rNEIout',ANLZ.rneiout,'Output'};
Panel(9,:) = {'SNR',ANLZ.snr,'Output'};
Panel(10,:) = {'Object',ANLZ.objectfunc,'Output'};
Panel(11,:) = {'',[],'Output'};
Panel(12,:) = {'PSF',INPUT.PSF.name,'Output'};
Panel(13,:) = {'PSD',INPUT.PSD.name,'Output'};

ANLZ.Panel = Panel;
ANLZ.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ANLZ.ExpDisp = PanelStruct2Text(ANLZ.PanelOutput);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

