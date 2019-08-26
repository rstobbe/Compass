%===========================================
% 
%===========================================

function [CAL,err] = ShimB0Cal47T_v2e_Func(CAL,INPUT)

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
ExpPars = INPUT.ExpPars;
Shims = INPUT.Shim;
SHIMMEAS = INPUT.SHIMMEAS;
clear INPUT;

%---------------------------------------------
% Ensure all the same ReconPars
%---------------------------------------------
ReconPars0 = ReconPars(1);
for n = 1:length(ReconPars)
    err = comp_struct(ReconPars(n),ReconPars0);
    if not(isempty(err))
        error()
    end
end 

%---------------------------------------------
% Setup and Base
%---------------------------------------------
ShimCalPars(1).shimcalname = 'base';
ShimCalPars(1).shimcalval = 0;
shimnames = fieldnames(Shims);
for n = 1:length(Shims)
    for m = 1:length(shimnames)
        if Shims(n).(shimnames{m}) ~= Shims(1).(shimnames{m})
            shimname = shimnames{m}
            shimval = Shims(n).(shimnames{m})-Shims(1).(shimnames{m})
            ShimCalPars(n).shimcalname = shimname;
            ShimCalPars(n).shimcalval = shimval;
        end
    end
end

%---------------------------------------------
% Setup and Base
%---------------------------------------------
if isfield(ExpPars,'Sequence')
    if isfield(ExpPars(1).Sequence,'te1')
        TEdif = ExpPars(1).Sequence.te2 - ExpPars(1).Sequence.te1;        % work on assumption all same
    else
        error();    % fix up importfid            
    end
elseif isfield(ExpPars,'te')
    te = ExpPars.te;
    TEdif = te(2) - te(1);
end
if not(strcmp(ShimCalPars(1).shimcalname,'base'))
    error();
end
ImBase = Im{1};

%---------------------------------------------
% Calibration
%---------------------------------------------
INPUT.ImBase = ImBase;
INPUT.Im = Im;
INPUT.ShimCalPars = ShimCalPars;
INPUT.TEdif = TEdif;
func = str2func([CAL.shimfunc,'_Func']);  
[SHIMMEAS,err] = func(SHIMMEAS,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
CAL.CalData = SHIMMEAS.CalData;
CAL.ReconPars = ReconPars;
CAL.ShimCalPars = ShimCalPars;
CAL.shimsused = '3degz4';

Status2('done','',2);
Status2('done','',3);

