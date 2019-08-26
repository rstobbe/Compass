%===========================================
% 
%===========================================

function [FAT,err] = Dixon_v1a_Func(FAT,INPUT)

Status2('busy','Dixon Fat Suppression',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG;
Im = IMG.Im;
%Phs0Ims = IMG.Phs0Ims;
%Phs180Ims = IMG.Phs180Ims;
clear INPUT;

%***********************
% Add to Image Output
fattype = 'Dixon';
Phs0Ims = [1 2];
Phs180Ims = [3 4];
%***********************

%---------------------------------------------
% Addition
%---------------------------------------------
ImOut = Im(:,:,:,Phs0Ims) + Im(:,:,:,Phs180Ims);
%test = size(ImOut);

%---------------------------------------------
% Return
%---------------------------------------------
FAT.Im = ImOut;

Status2('done','',2);
Status2('done','',3);

