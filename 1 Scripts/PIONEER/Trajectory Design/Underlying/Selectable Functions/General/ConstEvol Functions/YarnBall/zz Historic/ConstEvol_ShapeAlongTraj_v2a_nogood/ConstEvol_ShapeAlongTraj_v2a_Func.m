%==================================================
% 
%==================================================

function [CACC,err] = ConstEvol_ShapeAlongTraj_v2a_Func(CACC,INPUT)

Status2('busy','Constrain Trajectory Evolution',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input / Build Class
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
TST = INPUT.TST;
tArr = INPUT.TArr.';
kArr = INPUT.kArr*PROJdgn.kmax;
GVP = INPUT.GVP;
EndTime = tArr(end);
clear INPUT

GradSlewMax = 195;
GradAccMax = 8000;

%---------------------------------------------
% Get Gradient Velocity Profile
%---------------------------------------------
gvpfunc = str2func([GVP.method,'_Func']);  
INPUT = struct();         
[GVP,err] = gvpfunc(GVP,INPUT);
if err.flag == 1
    return
end
clear INPUT;
gvpfunc = str2func(GVP.profile);
gvpfunc = @(DecayDrop) gvpfunc(GradSlewMax,DecayDrop,tArr);

%---------------------------------------------
% Build TEVO Class
%---------------------------------------------
TEVO = ShapeAlongTraj_v2a(kArr,tArr,GradSlewMax,GradAccMax,PROJdgn,PROJimp,TST);
TEVO.PlotEvolutionSetup();

%---------------------------------------------
% Test Polar Angle
%---------------------------------------------
% TEVO.PlotPolarAngle();
% title('Polar Angle');

%---------------------------------------------
% First Step
%---------------------------------------------
CACC.gaccstart = GradAccMax;
CACC.gvelstart = GradSlewMax;
JrkFirst = CACC.gaccstart*PROJimp.gamma*1.5;
tSeg = TEVO.SolveAccRampSpecifyJrk(JrkFirst);
TEVO.BuildTimeArrayStart(tSeg);
TEVO.MoveNext();

%---------------------------------------------
% Ramp up acceleration
%---------------------------------------------
JrkStart = CACC.gaccstart*PROJimp.gamma;
AccStart = CACC.gvelstart*PROJimp.gamma;
while true
    tSeg = TEVO.SolveAccRampSpecifyJrk(JrkStart);
    if TEVO.TestGreaterSpecifyAcc(AccStart)
        break
    end
    TEVO.BuildTimeArrayStart(tSeg);
    TEVO.PlotEvolution(10);
    TEVO.MoveNext();
end

%---------------------------------------------
% Maintian acceleration
%---------------------------------------------
regfunc = str2func('SolveAccProf');
Loc = TEVO.GetLoc();
func = @(DecayDrop) regfunc(TEVO,Loc,tArr,PROJimp,gvpfunc,EndTime,DecayDrop);
options = optimset('TolFun',0.001);
lb = -1;
ub = 1.06;
DecayDrop0 = 0.8;
CACC.DecayDrop = lsqnonlin(func,DecayDrop0,lb,ub,options);

TEVO.FixTiming();
TEVO.PlotEvolutionEnd();
CACC.TArr = TEVO.tSamp;
CACC.doconstraint = 'Yes';

Status2('done','',3);
end

%==============================================================
% Solve Acceleration Profile
%==============================================================
function [Rem] = SolveAccProf(TEVO,Loc,tArr,PROJimp,gvpfunc,EndTime,DecayDrop)

DecayDrop
GvelProf = gvpfunc(DecayDrop);
TEVO.SetLoc(Loc); 
while true
    Time = TEVO.GetCurrentTime;
    AccVal = interp1(tArr,GvelProf*PROJimp.gamma,Time);
    tSeg = TEVO.SolveSpecifyAcc(AccVal); 
    TEVO.BuildTimeArray(tSeg);
    TEVO.PlotEvolution(10);
    TEVO.MoveNext();
    if TEVO.TestEnd()
        TEVO.MoveBack();
        TEVO.PlotEvolution(1);
        Time = TEVO.GetCurrentTime;
        Rem = Time - EndTime
        break
    end
end

end

