%=====================================================
%
%=====================================================

function [RFOV,err] = ReturnFov_Design_v1a_Func(RFOV,INPUT)

Status2('busy','ReturnFov',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Im;
PROJdgn = INPUT.IMP.PROJdgn;
ReconPars0 = INPUT.ReconPars;
clear INPUT;

%---------------------------------------------
% Head FoV
%---------------------------------------------
ImfovTB = PROJdgn.fov;
ImfovLR = PROJdgn.fov;                 
ImfovIO = PROJdgn.fov;

ReconPars.ImszTB = 2*round(ImfovTB/ReconPars0.ImvoxTB/2);
ReconPars.ImszLR = 2*round(ImfovLR/ReconPars0.ImvoxLR/2);
ReconPars.ImszIO = 2*round(ImfovIO/ReconPars0.ImvoxIO/2);

ReconPars.ImfovTB = ReconPars0.ImfovTB*(ReconPars.ImszTB/ReconPars0.ImszTB);
ReconPars.ImfovLR = ReconPars0.ImfovLR*(ReconPars.ImszLR/ReconPars0.ImszLR);
ReconPars.ImfovIO = ReconPars0.ImfovIO*(ReconPars.ImszIO/ReconPars0.ImszIO);

ReconPars.ImvoxTB = ReconPars.ImfovTB/ReconPars.ImszTB;
ReconPars.ImvoxLR = ReconPars.ImfovLR/ReconPars.ImszLR;
ReconPars.ImvoxIO = ReconPars.ImfovIO/ReconPars.ImszIO;

%---------------------------------------------
% Finish
%---------------------------------------------
sz = size(Im);
botTB = sz(1)/2 - ReconPars.ImszTB/2 + 1;
topTB = sz(1)/2 + ReconPars.ImszTB/2;
botLR = sz(2)/2 - ReconPars.ImszLR/2 + 1;
topLR = sz(2)/2 + ReconPars.ImszLR/2;
botIO = sz(3)/2 - ReconPars.ImszIO/2 + 1;
topIO = sz(3)/2 + ReconPars.ImszIO/2;

RFOV.Im = Im(botTB:topTB,botLR:topLR,botIO:topIO,:,:,:);
RFOV.ReconPars = ReconPars;

Status2('done','',2);
Status2('done','',3);






