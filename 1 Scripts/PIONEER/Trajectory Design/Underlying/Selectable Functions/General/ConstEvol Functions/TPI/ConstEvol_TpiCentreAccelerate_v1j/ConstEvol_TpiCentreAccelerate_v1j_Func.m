%==================================================
% 
%==================================================

function [CACC,err] = ConstEvol_TpiCentreAccelerate_v1j_Func(CACC,INPUT)

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
clear INPUT

%---------------------------------------------
% Build TEVO Class
%---------------------------------------------
GradSlewMax = 195;
GradAccMax = 8000;
TEVO = TpiCentreAccelerate_v1j(kArr,tArr,GradSlewMax,GradAccMax,PROJdgn,PROJimp,TST);
TEVO.PlotEvolutionSetup();

%---------------------------------------------
% Test Deflection Angle
%---------------------------------------------
MaxAngle = 5;       % degree
if(not(TEVO.TestDeflectionAngle(MaxAngle)))
    TEVO.PlotDeflectionAngle();
    title('Deflection Angle');
    err.flag = 1;
    err.msg = 'Trajectory must be solved more finely (deflection angle)';
    return
end

%---------------------------------------------
% First Step
%---------------------------------------------
JrkFirst = CACC.gaccstart*PROJimp.gamma*1.5;
tSeg = TEVO.SolveAccRampSpecifyJrk(JrkFirst);
TEVO.BuildTimeArray(tSeg);
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
    TEVO.BuildTimeArray(tSeg);
    TEVO.PlotEvolution(100);
    TEVO.MoveNext();
end

%---------------------------------------------
% Maintian acceleration
%---------------------------------------------
FracDecel = CACC.fracdecel;
while true
    tSeg = TEVO.SolveSpecifyAcc(AccStart); 
    if TEVO.TestFractionOfP(FracDecel)
        TEVO.PlotSegmentMarker;
        break
    end
    TEVO.BuildTimeArray(tSeg);
    TEVO.PlotEvolution(100);
    TEVO.MoveNext();
end

%---------------------------------------------
% Ramp to deceleration
%---------------------------------------------
JrkTransition = CACC.gacctransition*PROJimp.gamma;
AccReturn = CACC.gvelreturn*PROJimp.gamma;
while true
    tSeg = TEVO.SolveAccRampSpecifyJrk(-JrkTransition); 
    if TEVO.TestLessSpecifyAcc(-AccReturn)
        TEVO.PlotSegmentMarker;
        break
    end
    TEVO.BuildTimeArray(tSeg);
    TEVO.PlotEvolution(100);
    TEVO.MoveNext();
end

%---------------------------------------------
% Decelerate
%---------------------------------------------
if TEVO.TestLessVel0Seg()
    while true
        tSeg = TEVO.SolveSpecifyAcc(-AccReturn); 
        if TEVO.TestGreaterRelRad(CACC.twkloc2)
            break
        end
        ErrorAtVel = 10;
        if TEVO.TestLessSpecifyVel(ErrorAtVel)
            TEVO.MoveBack();
            TEVO.PlotEvolution(1);
            err.flag = 1;
            err.msg = 'Fix Evolution Design';
            return
        end
        TEVO.BuildTimeArray(tSeg);
        TEVO.PlotEvolution(100);
        TEVO.MoveNext();
        AccReturn = AccReturn^CACC.returntwk;
    end    
end

%---------------------------------------------
% Finish
%---------------------------------------------
regfunc = str2func('ReturnTwk2Regression');
Loc = TEVO.GetLoc();
func = @(Twk) regfunc(TEVO,PROJdgn,Loc,AccReturn,Twk);
options = optimoptions(@lsqnonlin,'FiniteDifferenceStepSize',1e-6);
lb = 0.99;
ub = 1.00;
Twk0 = CACC.returntwk;
CACC.returntwk2 = lsqnonlin(func,Twk0,lb,ub,options);

%TEVO.PlotEvolutionFullSetup();
%TEVO.PlotEvolutionFull();
TEVO.FixTiming();
TEVO.PlotEvolutionEnd();
CACC.TArr = TEVO.tSamp;

Status2('done','',3);
end

%==================================================
% ReturnTwk2Regression
%==================================================
function [Rem] = ReturnTwk2Regression(TEVO,PROJdgn,Loc,AccReturn0,ReturnTwk2)

    TEVO.SetLoc(Loc); 
    AccReturn = AccReturn0;
    while true
        tSeg = TEVO.SolveSpecifyAcc(-AccReturn); 
        if TEVO.TestLessAcc0Seg()
            break
        end
        TEVO.BuildTimeArray(tSeg);
        TEVO.PlotEvolution(100);
        TEVO.MoveNext();
        AccReturn = AccReturn^ReturnTwk2;
    end
    while true
        tSeg = TEVO.SolveAccAtAcc0Seg(); 
        TEVO.BuildTimeArray(tSeg);
        TEVO.PlotEvolution(250);
        TEVO.MoveNext();
        if TEVO.TestEnd()
            TEVO.MoveBack();
            break
        end
    end
    ReturnTwk2 = ReturnTwk2
    Tatkmax = TEVO.Tatkmax()       
    Rem = Tatkmax - PROJdgn.tro
end

