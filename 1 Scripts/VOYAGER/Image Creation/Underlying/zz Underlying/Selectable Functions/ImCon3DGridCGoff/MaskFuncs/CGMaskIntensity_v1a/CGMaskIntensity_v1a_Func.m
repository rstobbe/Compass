%=========================================================
% 
%=========================================================

function [MSK,err] = CGMaskIntensity_v1a_Func(MSK,INPUT)

Status2('busy','Create Masks',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Im;
clear INPUT;

%---------------------------------------------
% FoV Mask Generate
%---------------------------------------------
sz = size(Im);
Imsz = sz(1);
Status2('busy','Generate FoV Mask',3);
FoVMask = zeros(Imsz,Imsz,Imsz);
C = Imsz/2;
for n = 1:Imsz
    for m = 1:Imsz
        for p = 1:Imsz
            rad = sqrt((n-C)^2 + (m-C)^2 + (p-C)^2);
            if rad <= C;
                FoVMask(n,m,p) = 1;
            end
        end
    end
end

%---------------------------------------------
% Intensity Mask Generate
%---------------------------------------------
Status2('busy','Generate Intensity Mask',3);
ItsMask = zeros(Imsz,Imsz,Imsz);
Ival = MSK.relintensity*mean(mean(mean(Im(C-10:C+10,C-10:C+10,C-10:C+10))));
for n = 1:Imsz
    for m = 1:Imsz
        for p = 1:Imsz
            if Im(n,m,p) >= Ival
                ItsMask(n,m,p) = 1;
            end
        end
    end
end

%---------------------------------------------
% Test Image
%---------------------------------------------
if strcmp(MSK.test,'Yes')
    MSTRCT.start = Imsz/2; MSTRCT.stop = Imsz/2;
    MSTRCT.imsize = '700,800';
    INPUT.Image = Im.*FoVMask.*ItsMask;
    INPUT.MSTRCT = MSTRCT;
    PlotMontage_v1c(INPUT);
    button = questdlg('Continue?','Mask Test','Yes');
    if not(strcmp(button,'Yes'))
        err.flag = 1;
        err.msg = 'Abort on Mask Test';
        return
    end
end

%--------------------------------------------
% Return
%--------------------------------------------
MSK.Mask = FoVMask.*ItsMask;

Status2('done','',3);


