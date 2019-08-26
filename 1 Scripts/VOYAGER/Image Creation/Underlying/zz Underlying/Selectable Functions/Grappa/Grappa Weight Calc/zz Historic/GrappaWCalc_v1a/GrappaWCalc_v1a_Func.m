%=====================================================
%
%=====================================================

function [GWCALC,err] = GrappaWCalc_v1a_Func(GWCALC,INPUT)

Status2('busy','Grappa Weight Calculation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
CalDat = INPUT.cDat;
GKERN = INPUT.GKERN;
clear INPUT;

%---------------------------------------------
% Zero-Fill Kernel to size of Calibration Data
%---------------------------------------------
Kern = GKERN.Kern;
[Csz,~,~,Nrcvrs] = size(CalDat);                % assume symmetric
[Krnsz,~,~] = size(Kern);                       
zfKern = zeros(Csz,Csz,Csz);
zfKern(1:Krnsz,1:Krnsz,1:Krnsz) = Kern;

cenKern = zeros(size(Kern));
cenKern(GKERN.cen,GKERN.cen,GKERN.cen) = 1;
zfcenKern = zeros(Csz,Csz,Csz);
zfcenKern(1:Krnsz,1:Krnsz,1:Krnsz) = cenKern;

%---------------------------------------------
% Test
%---------------------------------------------
Ncalpts = (Csz-Krnsz+1)^3;
if Ncalpts < (sum(Kern(:))*Nrcvrs)
    err.flag = 1;
    err.msg = 'Underdetermined - Increase size of calibration data';
    return
end

%---------------------------------------------
% Create Kernel-Data Matrix (X)
%---------------------------------------------
X = zeros(Ncalpts,sum(Kern(:))*Nrcvrs);
xi = zeros(Ncalpts,Nrcvrs);
calpt = 1;
for n = 0:Csz-Krnsz
    for m = 0:Csz-Krnsz   
        for p = 0:Csz-Krnsz
            tKern = circshift(zfKern,[n m p]);
            sampinds = logical(tKern);
            tcenKern = circshift(zfcenKern,[n m p]);
            cenind = logical(tcenKern);
            tX = [];
            for i = 1:Nrcvrs
                tCalDat = squeeze(CalDat(:,:,:,i));
                tX0 = tCalDat(sampinds);
                tX = [tX;tX0(:)];
                txi = tCalDat(cenind);
                xi(calpt,i) = txi;
            end
            X(calpt,:) = tX;
            calpt = calpt+1;
        end
    end
end

%---------------------------------------------
% Solve for weights (gi)
%---------------------------------------------
beta = 0;
gi = zeros(length(X(1,:)),Nrcvrs);
for i = 1:Nrcvrs
    gi(:,i) = ((X'*X + beta*eye(length(X(1,:))))^-1)*X'*squeeze(xi(:,i));
end

%---------------------------------------------
% Return
%---------------------------------------------
GWCALC.G = gi;

Status2('done','',2);
Status2('done','',3);



