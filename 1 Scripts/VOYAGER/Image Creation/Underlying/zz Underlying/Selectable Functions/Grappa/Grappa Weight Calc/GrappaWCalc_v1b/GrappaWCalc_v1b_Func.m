%=====================================================
%
%=====================================================

function [GWCALC,err] = GrappaWCalc_v1b_Func(GWCALC,INPUT)

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
% Get Kernel Info
%---------------------------------------------
Kern = GKERN.Kern;
[Csz,~,~,Nrcvrs] = size(CalDat);                % assume symmetric
[Krnsz,~,~] = size(Kern);                    
zfKern = zeros(size(CalDat));
repKern = repmat(Kern,[1 1 1 Nrcvrs]);
zfKern(1:Krnsz,1:Krnsz,1:Krnsz,:) = repKern;
kerninds0 = find(logical(zfKern));
clear zfKern

cenKern = zeros(size(Kern));
cenKern(GKERN.cen,GKERN.cen,GKERN.cen) = 1;
zfcenKern = zeros(size(CalDat));
repcenKern = repmat(cenKern,[1 1 1 Nrcvrs]);
zfcenKern(1:Krnsz,1:Krnsz,1:Krnsz,:) = repcenKern;
ceninds0 = find(logical(zfcenKern));
clear zfcenKern

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
X = zeros(Ncalpts,sum(Kern(:))*Nrcvrs);         % remember:  M(down,across)
xi = zeros(Ncalpts,Nrcvrs);
calpt = 1;
for n = 0:Csz-Krnsz
    for m = 0:Csz-Krnsz 
        for p = 0:Csz-Krnsz
            kerninds = kerninds0 + n + m*Csz + p*Csz^2; 
            X(calpt,:) = CalDat(kerninds);
            ceninds = ceninds0 + n + m*Csz + p*Csz^2; 
            xi(calpt,:) = CalDat(ceninds);
            calpt = calpt+1;
        end
    end
    Status2('busy',['n: ',num2str(n)],3);
end

%---------------------------------------------
% Solve for weights (gi)
%---------------------------------------------
%gi = mldivide(X,xi);
gi = pinv(X)*xi;                    % see malab (mldivide tips)

%---------------------------------------------
% Return
%---------------------------------------------
GWCALC.G = gi;

Status2('done','',2);
Status2('done','',3);



