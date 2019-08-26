%=====================================================
%
%=====================================================

function [ZF,err] = ZeroFill_FactorMaintainPosTest_v1a_Func(ZF,INPUT)

Status2('busy','ZeroFill',2);
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
ind = strfind(ZF.factor,',');
factor(2) = str2double(ZF.factor(1:ind(1)-1));
factor(1) = str2double(ZF.factor(ind(1)+1:ind(2)-1));
factor(3) = str2double(ZF.factor(ind(2)+1:length(ZF.factor))); 
first = ceil(factor/2);

%---------------------------------------------
% Test
%--------------------------------------------- 
arr = (1:2:25);
ind1 = find(arr == factor(1), 1);
ind2 = find(arr == factor(2), 1);
ind3 = find(arr == factor(3), 1);
if isempty(ind1) || isempty(ind2) || isempty(ind3)
    err.flag = 1;
    err.msg = 'ZeroFill factor must be odd';
    return
end

%---------------------------------------------
% Sample
%---------------------------------------------
sz = size(IMG.Im);
Im = zeros(sz./factor);
sz = size(Im);
for n = 1:sz(1)
    for m = 1:sz(2)
        for p = 1:sz(3)
            Im(n,m,p) = IMG.Im(first(1)+(n-1)*factor(1),first(2)+(m-1)*factor(2),first(3)+(p-1)*factor(3));
        end
    end
end
IMG.Im = Im;

%---------------------------------------------
% Update ReconPars
%---------------------------------------------
if isfield(IMG,'ReconPars')
    ReconPars = IMG.ReconPars;
    ReconPars.ImszTB = sz(1);
    ReconPars.ImszLR = sz(2);
    ReconPars.ImszIO = sz(3);
    ReconPars.ImvoxTB = ReconPars.ImvoxTB*factor(1);
    ReconPars.ImvoxLR = ReconPars.ImvoxLR*factor(2);
    ReconPars.ImvoxIO = ReconPars.ImvoxIO*factor(3);
    ReconPars.ImfovTB = ReconPars.ImszTB*ReconPars.ImvoxTB;
    ReconPars.ImfovLR = ReconPars.ImszLR*ReconPars.ImvoxLR;
    ReconPars.ImfovIO = ReconPars.ImszIO*ReconPars.ImvoxIO;
    IMG.ReconPars = ReconPars;
end

%---------------------------------------------
% Update ImDisp
%---------------------------------------------
IMG.IMDISP.IMDIM.x2 = sz(2);
IMG.IMDISP.IMDIM.y2 = sz(1);
IMG.IMDISP.IMDIM.z2 = sz(3);
IMG.IMDISP.SCALE.xmax = IMG.IMDISP.IMDIM.x2+0.5;
IMG.IMDISP.SCALE.ymax = IMG.IMDISP.IMDIM.y2+0.5;
IMG.IMDISP.SCALE.zmax = IMG.IMDISP.IMDIM.z2+0.5;

IMG.IMDISP.ImInfo.pixdim = IMG.IMDISP.ImInfo.pixdim.*factor;
IMG.IMDISP.ImInfo.vox = IMG.IMDISP.ImInfo.pixdim(1)*IMG.IMDISP.ImInfo.pixdim(2)*IMG.IMDISP.ImInfo.pixdim(3);

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',ZF.method,'Output'};
Panel(3,:) = {'ZeroFill Factors',ZF.factor,'Output'};
Panel(4,:) = {'Voxel(mm)',[num2str(IMG.IMDISP.ImInfo.pixdim(1),'%2.2f'),' x ',num2str(IMG.IMDISP.ImInfo.pixdim(2),'%2.2f'),' x ',num2str(IMG.IMDISP.ImInfo.pixdim(3),'%2.2f')],'Output'};
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
IMG.name = [IMG.name,'_ZF'];
ZF.IMG = IMG;

Status2('done','',2);
Status2('done','',3);



