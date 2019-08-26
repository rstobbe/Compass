%===========================================
% 
%===========================================

function [OB,err] = LoadSimObjFromFile_v1c_Func(OB,INPUT)

Status2('busy','Return Numerical Object',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Object Size
%---------------------------------------------
M = size(OB.Ob);
M = M(3);

%---------------------------------------------
% Max Object Displacement from Centre
%---------------------------------------------
% Add

%---------------------------------------------
% Return
%---------------------------------------------
OB.ObMatSz = M;
OB.VoxelWid = OB.ObFoV/M;
OB.VoxelVol = (OB.ObFoV/M)^3;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'ObMatSz',OB.ObMatSz,'Output'};
Panel(2,:) = {'ObFoV (mm)',OB.ObFoV,'Output'};
Panel(3,:) = {'ObVoxelWid (mm)',OB.VoxelWid,'Output'};
Panel(4,:) = {'ObVoxelVox (mm3)',OB.VoxelVol,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
OB.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);

