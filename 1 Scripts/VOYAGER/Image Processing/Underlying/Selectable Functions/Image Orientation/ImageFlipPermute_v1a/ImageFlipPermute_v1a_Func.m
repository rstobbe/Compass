%=========================================================
% 
%=========================================================

function [ORNT,err] = ImageFlipPermute_v1a_Func(ORNT,INPUT)

Status2('busy','Flip/Permute Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Permute
%---------------------------------------------
permuteval(1) = str2double(ORNT.permute(1));
permuteval(2) = str2double(ORNT.permute(2));
permuteval(3) = str2double(ORNT.permute(3));
IMG.Im = permute(IMG.Im,permuteval);

%---------------------------------------------
% Flip
%---------------------------------------------
if str2double(ORNT.flip(1)) == 1
    IMG.Im = flip(IMG.Im,1);
end
if str2double(ORNT.flip(2)) == 1
    IMG.Im = flip(IMG.Im,2);
end
if str2double(ORNT.flip(3)) == 1
    IMG.Im = flip(IMG.Im,3);
end

%---------------------------------------------
% ReconPars
%---------------------------------------------
if isfield(IMG,'ReconPars')
    Imsz(1) = IMG.ReconPars.ImszTB;
    Imsz(2) = IMG.ReconPars.ImszLR;
    Imsz(3) = IMG.ReconPars.ImszIO;
    Imsz2 = Imsz(permuteval);
    IMG.ReconPars.ImszTB = Imsz2(1);
    IMG.ReconPars.ImszLR = Imsz2(2);
    IMG.ReconPars.ImszIO = Imsz2(3);

    Imfov(1) = IMG.ReconPars.ImfovTB;
    Imfov(2) = IMG.ReconPars.ImfovLR;
    Imfov(3) = IMG.ReconPars.ImfovIO;
    Imfov2 = Imfov(permuteval);
    IMG.ReconPars.ImfovTB = Imfov2(1);
    IMG.ReconPars.ImfovLR = Imfov2(2);
    IMG.ReconPars.ImfovIO = Imfov2(3);

    Imvox(1) = IMG.ReconPars.ImvoxTB;
    Imvox(2) = IMG.ReconPars.ImvoxLR;
    Imvox(3) = IMG.ReconPars.ImvoxIO;
    Imvox2 = Imvox(permuteval);
    IMG.ReconPars.ImvoxTB = Imvox2(1);
    IMG.ReconPars.ImvoxLR = Imvox2(2);
    IMG.ReconPars.ImvoxIO = Imvox2(3);

    %----------------------------------------------
    % Set Up Compass Display
    %----------------------------------------------
    MSTRCT.type = 'abs';
    MSTRCT.dispwid = [0 max(abs(IMG.Im(:)))];
    MSTRCT.ImInfo.pixdim = [IMG.ReconPars.ImvoxTB,IMG.ReconPars.ImvoxLR,IMG.ReconPars.ImvoxIO];
    MSTRCT.ImInfo.vox = IMG.ReconPars.ImvoxTB*IMG.ReconPars.ImvoxLR*IMG.ReconPars.ImvoxIO;
    MSTRCT.ImInfo.info = IMG.ExpDisp;
    MSTRCT.ImInfo.baseorient = 'Axial';             % all images should be oriented axially
    INPUT.Image = IMG.Im;
    INPUT.MSTRCT = MSTRCT;
    IMDISP = ImagingPlotSetup(INPUT);
    IMG.IMDISP = IMDISP;
    
elseif isfield(IMG,'IMDISP')
    IMG.IMDISP.ImInfo.pixdim = IMG.IMDISP.ImInfo.pixdim(permuteval);
end
    
%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',ORNT.method,'Output'};
Panel(3,:) = {'Permute',ORNT.permute,'Output'};
Panel(4,:) = {'Flip',ORNT.flip,'Output'};
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
IMG.name = [IMG.name,'_Ornt'];
ORNT.IMG = IMG;

Status2('done','',2);
Status2('done','',3);