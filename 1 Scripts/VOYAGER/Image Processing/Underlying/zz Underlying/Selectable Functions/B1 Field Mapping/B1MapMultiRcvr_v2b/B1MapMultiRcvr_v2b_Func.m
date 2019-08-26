%====================================================
%  
%====================================================

function [B1MAP,err] = B1MapMultiRcvr_v2b_Func(B1MAP,INPUT)

Status2('busy','Generate B1-Map',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Image;
ReconPars = INPUT.ReconPars;
flip = INPUT.flipangle;
ExpPars = INPUT.ExpPars;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if flip(1) > flip(2)
    dir = 1;
    if flip(1)/flip(2) ~= 2
        err.flag = 1;
        err.msg = 'Flip1 should be 2x Flip2';
        return
    end
else
    dir = 2;
    if flip(2)/flip(1) ~= 2
        err.flag = 1;
        err.msg = 'Flip2 should be 2x Flip1';
        return
    end
end

%---------------------------------------------
% Low Pass Filter (finish for multi...)
%---------------------------------------------
% IMG.ReconPars = ReconPars;
% func = str2func([B1MAP.lpassfunc,'_Func']);  
% for n = 1:2
%     IMG.Im = squeeze(Im(:,:,:,n));
%     INPUT.IMG = IMG;
%     [LPASS,err] = func(LPASS,INPUT);
%     if err.flag
%         return
%     end
%     clear INPUT;
%     Im(:,:,:,n) = LPASS.Im;
% end

%---------------------------------------------
% Image Absolute Value
%---------------------------------------------
AbsIms = abs(Im);

%---------------------------------------------
% Calc
%---------------------------------------------
[x,y,z,~,~] = size(Im);
ImRelArr = zeros([x,y,z,ExpPars.nrcvrs]);
for n = 1:ExpPars.nrcvrs
    if dir == 1
        mask = AbsIms(:,:,:,2,n);
        mask(mask < B1MAP.maskval*max(mask(:))) = NaN;
        mask(mask >= B1MAP.maskval*max(mask(:))) = 1;
        ImRel = (AbsIms(:,:,:,2,n)./AbsIms(:,:,:,1,n)).*mask;
    else
        mask = AbsIms(:,:,:,1,n);
        mask(mask < B1MAP.maskval*max(mask(:))) = NaN;
        mask(mask >= B1MAP.maskval*max(mask(:))) = 1;
        ImRel = (AbsIms(:,:,:,1,n)./AbsIms(:,:,:,2,n)).*mask;
    end
    ImRel(ImRel<0.5) = NaN;             % noise related error 
    ImRelArr(:,:,:,n) = ImRel;    
end
ImRel = nanmean(ImRelArr,4);
%---
% INPUT.Image = ImRel;
% INPUT.MSTRCT.type = 'real';
% INPUT.MSTRCT.colour = 'Yes';
% INPUT.MSTRCT.dispwid = [0.5 1.0];
% PlotMontageImage_v1e(INPUT); 
%---

Imflip = acos(1./(2*ImRel));
if dir == 1
    B1map = (Imflip*180/pi)/flip(2);
else
    B1map = (Imflip*180/pi)/flip(1);
end
    
%---------------------------------------------
% Test
%---------------------------------------------
if not(isreal(B1map));
    error();
end

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',B1MAP.method,'Output'};
B1MAP.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
B1MAP.B1Map = B1map;

Status2('done','',2);
Status2('done','',3);
