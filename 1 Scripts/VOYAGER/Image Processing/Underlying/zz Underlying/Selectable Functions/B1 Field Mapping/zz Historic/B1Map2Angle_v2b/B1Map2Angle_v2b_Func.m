%====================================================
%  
%====================================================

function [B1MAP,err] = B1Map2Angle_v2b_Func(B1MAP,INPUT)

Status2('busy','Generate B1-Map',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG1 = INPUT.IMG1;
IMG2 = INPUT.IMG2;
LPASS = B1MAP.LPASS;
clear INPUT;

%---------------------------------------------
% Get Images/Data
%---------------------------------------------
Flip1 = IMG1.ExpPars.Sequence.flipangle;
Flip2 = IMG2.ExpPars.Sequence.flipangle;

%---------------------------------------------
% Test
%---------------------------------------------
if Flip1 > Flip2
    err.flag = 1;
    err.msg = 'The smaller flip angle should be Image1';
    return
end
if Flip2/Flip1 ~= 2
    err.flag = 1;
    err.msg = 'Flip2 should be 2x Flip1';
    return
end

%---------------------------------------------
% Low Pass Filter
%---------------------------------------------
[x,y,z] = size(IMG1.Im);
Ims = zeros([x,y,z,2]);
func = str2func([B1MAP.lpassfunc,'_Func']);  
for n = 1:2
    if n == 1
        INPUT.IMG = IMG1;
    elseif n == 2
        INPUT.IMG = IMG2;
    end
    [LPASS,err] = func(LPASS,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    Ims(:,:,:,n) = LPASS.Im;
end

%---------------------------------------------
% Calc
%---------------------------------------------
AbsIms = abs(Ims);
ImRel = AbsIms(:,:,:,1)./AbsIms(:,:,:,2);

%---------------------------------------------
% Test
%---------------------------------------------
ImRel(ImRel > 1) = NaN;


Imflip = acos(1./(2*ImRel));
B1rel = (Imflip*180/pi)/Flip1;

%---------------------------------------------
% Mask
%---------------------------------------------
mask = mean(AbsIms,4);
mask(mask < B1MAP.maskval*max(mask(:))) = NaN;
mask(mask >= B1MAP.maskval*max(mask(:))) = 1;
B1MAP.Im = B1rel .* mask;

%---------------------------------------------
% Return
%---------------------------------------------
if isfield(IMG1,'PanelOutput');
    B1MAP.PanelOutput = IMG1.PanelOutput;
else
    Panel(1,:) = {'','','Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);
    B1MAP.PanelOutput = PanelOutput;
end

Status2('done','',2);
Status2('done','',3);

