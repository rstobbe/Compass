%===========================================
% 
%===========================================

function [CAL,err] = ShimB0Cal_v2c_Func(CAL,INPUT)

Status2('busy','Calibrate Shimming',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
Im = INPUT.Im;
ReconPars = INPUT.ReconPars;
Shims = INPUT.Shim;
B0SHIM = INPUT.B0SHIM;
clear INPUT;

%---------------------------------------------
% Setup and Base
%---------------------------------------------
ReconPars(1).shimcalname = 'base';
ReconPars(1).shimcalval = 0;
shimnames = fieldnames(Shims);
for n = 2:length(Shims)
    for m = 1:length(shimnames)-2
        if Shims(n).(shimnames{m}) ~= Shims(1).(shimnames{m})
            shimname = shimnames{m}
            shimval = Shims(n).(shimnames{m})-Shims(1).(shimnames{m})
            ReconPars(n).shimcalname = shimname;
            ReconPars(n).shimcalval = shimval;
        end
    end
end

%---------------------------------------------
% Setup and Base
%---------------------------------------------
TEdif = ReconPars(1).te2 - ReconPars(1).te1;        % work on assumption all same
if not(strcmp(ReconPars(1).shimcalname,'base'))
    error()
end
ImBase = Im{1};

%---------------------------------------------
% Regress Difference Images
%---------------------------------------------
CalData(1).Shim = 'tof';
CalData(1).CalVal = 1;
CalData(1).SphWgts = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
for n = 2:length(Im)
    INPUT.ImB1 = ImBase(:,:,:,1,:);
    INPUT.ImB2 = ImBase(:,:,:,2,:);
    ImV = Im{n};
    INPUT.ImV1 = ImV(:,:,:,1,:);
    INPUT.ImV2 = ImV(:,:,:,2,:);
    INPUT.ReconPars = ReconPars;
    INPUT.TEdif = TEdif;
    func = str2func([CAL.shimfunc,'_Func']);  
    [B0SHIM,err] = func(B0SHIM,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    maxoffres(n) = B0SHIM.maxoffres;
    V = B0SHIM.V;
    CalData(n).Shim = ReconPars(n).shimcalname;
    CalData(n).CalVal = ReconPars(n).shimcalval;
    CalData(n).SphWgts = V;
    CalData(n).resnorm = B0SHIM.FIT.resnorm;
end

maxoffres
CAL.CalData = CalData;

Status2('done','',2);
Status2('done','',3);

