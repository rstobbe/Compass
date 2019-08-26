%===========================================
% 
%===========================================

function [CAL,err] = XYZB0Cal47T_v2e_Func(CAL,INPUT)

Status('busy','Measure X,Y,Z,B0 Interdependencies');
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
BASE = INPUT.BASE;
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
ReconPars = ReconPars0;

%---------------------------------------------
% Get Shim Names
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
% Timing
%---------------------------------------------
if isfield(ExpPars,'Sequence')
    if isfield(ExpPars(1).Sequence,'te1')
        TEdif = ExpPars(1).Sequence.te2 - ExpPars(1).Sequence.te1;        % work on assumption all same
    else
        error();    % fix up importfid            
    end
elseif isfield(ExpPars,'te1') && isfield(ExpPars,'te2')
    TEdif = ExpPars(1).te2 - ExpPars(1).te1;
elseif isfield(ExpPars,'te')
    te = ExpPars.te;
    TEdif = te(2) - te(1);
end

%---------------------------------------------
% Create Base Image for Display
%---------------------------------------------
func = str2func([CAL.baseimfunc,'_Func']);  
INPUT.Im = Im{1};
INPUT.ExpPars = ExpPars;
[BASE,err] = func(BASE,INPUT);
if err.flag
    return
end
clear INPUT;
ImBase = BASE.Im;

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
% ShimValue to mT/m
%---------------------------------------------
CalData = SHIMMEAS.CalData;
fov(1) = ReconPars.ImfovIO/1000;
fov(2) = ReconPars.ImfovLR/1000;
fov(3) = ReconPars.ImfovTB/1000;
for n = 2:4
    for m = (2:4)
        Gval(n-1,m-1) = (CalData(n).SphWgts(m)/42.577e3)/(fov(n-1)/2);      % in mT
    end
end
Gval = Gval

%---------------------------------------------
% Gradient Magnitude Calculation
%---------------------------------------------
for n = 1:3
    Gmag(n) = sqrt(Gval(n,1).^2 + Gval(n,2).^2 + Gval(n,3).^2);
end
Gmag = Gmag

%---------------------------------------------
% Gradient Angles
%---------------------------------------------
for n = 1:3
    for m = (1:3)
        Gcross(n,m) = Gval(n,m)/Gmag(n);
    end
end
Gcross = Gcross

%---------------------------------------------
% Gradient Magnitude Calculation
%---------------------------------------------
for n = 2:4
    Foff(n-1) = CalData(n).SphWgts(1);
    FpG(n-1) = Foff(n-1)/Gval(n-1,n-1);
end
Foff = Foff

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {[num2str(CalData(2).CalVal),' on Z gives (mT) on Z'],num2str(Gval(1,1)),'Output'};
Panel(2,:) = {[num2str(CalData(3).CalVal),' on X gives (mT) on X'],num2str(Gval(2,2)),'Output'};
Panel(3,:) = {[num2str(CalData(4).CalVal),' on Y gives (mT) on Y'],num2str(Gval(3,3)),'Output'};
Panel(4,:) = {'','','Output'};
Panel(5,:) = {'%Zmag in X',num2str(100*abs(Gcross(1,2))),'Output'};
Panel(6,:) = {'%Zmag in Y',num2str(100*abs(Gcross(1,3))),'Output'};
Panel(7,:) = {'%Xmag in Z',num2str(100*abs(Gcross(2,1))),'Output'};
Panel(8,:) = {'%Xmag in Y',num2str(100*abs(Gcross(2,3))),'Output'};
Panel(9,:) = {'%Ymag in Z',num2str(100*abs(Gcross(3,1))),'Output'};
Panel(10,:) = {'%Ymag in X',num2str(100*abs(Gcross(3,2))),'Output'};
Panel(11,:) = {'','','Output'};
Panel(12,:) = {'Foff (Hz) per mT in Z',num2str(FpG(1)),'Output'};
Panel(13,:) = {'Foff (Hz) per mT in X',num2str(FpG(2)),'Output'};
Panel(14,:) = {'Foff (Hz) per mT in Y',num2str(FpG(3)),'Output'};

PanelOutput = cell2struct(Panel,{'label','value','type'},2);
CAL.PanelOutput = PanelOutput;


SphWgts = CalData(1).SphWgts;
CalVal = CalData(1).CalVal;



%---------------------------------------------
% Return
%---------------------------------------------
CAL.CalData = SHIMMEAS.CalData;
CAL.ReconPars = ReconPars;
CAL.ShimCalPars = ShimCalPars;
CAL.shimsused = '1deg';

Status2('done','',2);
Status2('done','',3);

