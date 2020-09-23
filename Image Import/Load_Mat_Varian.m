%===================================================
% Load_RWS
%===================================================

function [IMG,ImInfo,err] = Load_Mat_Varian(Data)

err.flag = 0;
err.msg = '';

Im = Data.img;
par = Data.par;

ImvoxTB = 20*par.lro/par.np;
ImvoxLR = 10*par.lpe/par.nv;
ImvoxIO = par.gap+par.thk;

ImInfo.pixdim = [ImvoxTB,ImvoxLR,ImvoxIO];                    % Finish
ImInfo.vox = ImvoxTB*ImvoxLR*ImvoxIO;
ImInfo.info = '';

ReconPars.ImvoxTB = ImvoxTB;
ReconPars.ImvoxLR = ImvoxLR;  
ReconPars.ImvoxIO = ImvoxIO;  

Panel(1,:) = {'','',''};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

IMG.PanelOutput = PanelOutput;
IMG.ReconPars = ReconPars;
IMG.Im = Im;

