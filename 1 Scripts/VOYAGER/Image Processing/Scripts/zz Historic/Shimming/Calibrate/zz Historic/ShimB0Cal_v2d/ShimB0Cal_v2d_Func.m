%===========================================
% 
%===========================================

function [CAL,err] = ShimB0Cal_v2d_Func(CAL,INPUT)

Status('busy','Measure Shim Coil Effects');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
Im = INPUT.Im;
ReconPars = INPUT.ReconPars;
Shims = INPUT.Shim;
SHIMMEAS = INPUT.SHIMMEAS;
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
    [SHIMMEAS,err] = func(SHIMMEAS,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    maxoffres(n) = SHIMMEAS.maxoffres;
    V = SHIMMEAS.V;
    CalData(n).Shim = ReconPars(n).shimcalname;
    CalData(n).CalVal = ReconPars(n).shimcalval;
    CalData(n).SphWgts = V;
    CalData(n).resnorm = SHIMMEAS.FIT.resnorm;

    figure(100+n); hold on;
    plot(CalData(n).SphWgts,'k*') 
    title(CalData(n).Shim);
end

maxoffres
CAL.CalData = CalData;

Status2('done','',2);
Status2('done','',3);

