%===========================================
% 
%===========================================

function [RESZ,err] = ReduceMatrixSpecify_v1a_Func(RESZ,INPUT)

Status2('busy','Reduce Matrix Size',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Get Input
%--------------------------------------------- 
ind = strfind(RESZ.leftright,':');
LR(1) = str2double(RESZ.leftright(1:ind-1));
LR(2) = str2double(RESZ.leftright(ind+1:length(RESZ.leftright))); 
ind = strfind(RESZ.topbot,':');
TB(1) = str2double(RESZ.topbot(1:ind-1));
TB(2) = str2double(RESZ.topbot(ind+1:length(RESZ.topbot))); 
ind = strfind(RESZ.inout,':');
IO(1) = str2double(RESZ.inout(1:ind-1));
IO(2) = str2double(RESZ.inout(ind+1:length(RESZ.inout))); 

%---------------------------------------------
% Reduce Matrix
%---------------------------------------------
IMG.Im = IMG.Im(TB(1):TB(2),LR(1):LR(2),IO(1):IO(2)); 

%---------------------------------------------
% Update ReconPars
%---------------------------------------------
if isfield(IMG,'ReconPars')
    ReconPars = IMG.ReconPars;
    ReconPars.ImszTB = TB(2)-TB(1)+1;
    ReconPars.ImszLR = LR(2)-LR(1)+1;
    ReconPars.ImszIO = IO(2)-IO(1)+1;
    ReconPars.ImfovTB = ReconPars.ImszTB*ReconPars.ImvoxTB;
    ReconPars.ImfovLR = ReconPars.ImszLR*ReconPars.ImvoxLR;
    ReconPars.ImfovIO = ReconPars.ImszIO*ReconPars.ImvoxIO;
    IMG.ReconPars = ReconPars;
end

%---------------------------------------------
% Update ImDisp
%---------------------------------------------
IMG.IMDISP.IMDIM.x2 = LR(2)-LR(1)+1;
IMG.IMDISP.IMDIM.y2 = TB(2)-TB(1)+1;
IMG.IMDISP.IMDIM.z2 = IO(2)-IO(1)+1;
IMG.IMDISP.SCALE.xmax = IMG.IMDISP.IMDIM.x2+0.5;
IMG.IMDISP.SCALE.ymax = IMG.IMDISP.IMDIM.y2+0.5;
IMG.IMDISP.SCALE.zmax = IMG.IMDISP.IMDIM.z2+0.5;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',RESZ.method,'Output'};
Panel(3,:) = {'LeftRight',[num2str(LR(1)),':',num2str(LR(2))],'Output'};
Panel(4,:) = {'TopBot',[num2str(TB(1)),':',num2str(TB(2))],'Output'};
Panel(5,:) = {'InOut',[num2str(IO(1)),':',num2str(IO(2))],'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
IMG.IMDISP.ImInfo.info = IMG.ExpDisp;

%---------------------------------------------
% Return
%---------------------------------------------
if strfind(IMG.name,'.mat')
    IMG.name = IMG.name(1:end-4);
end
IMG.name = [IMG.name,'_Rsz'];
RESZ.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

