%==================================================
% 
%==================================================

function [CACC,err] = ConstEvol_TpiGradMagConstrain_v1a_Func(CACC,INPUT)

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
TEVO = TpiGradMagConstrain_v1a(kArr,tArr,GradSlewMax,GradAccMax,PROJdgn,PROJimp,TST);
TEVO.PlotEvolutionSetup();

%---------------------------------------------
% Test Deflection Angle
%---------------------------------------------
MaxAngle = 1;       % degree
if(not(TEVO.TestDeflectionAngle(MaxAngle)))
    TEVO.PlotDeflectionAngle();
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
% Accelerate to Mag
%---------------------------------------------
Loc = TEVO.GetLoc();
VelMagInit = CACC.gmaginit*PROJimp.gamma; 
VelMagTrans = VelMagInit * 0.8;
while true
    
    %---------------------------------------------
    % Maintian acceleration
    %---------------------------------------------
    while true
        tSeg = TEVO.SolveSpecifyAcc(AccStart); 
        if TEVO.TestGreaterSpecifyVel(VelMagTrans)
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
        if TEVO.TestLessSpecifyAcc(0)
            TEVO.MoveBack();
            TEVO.PlotEvolution(1);
            TEVO.MoveNext();
            break
        end
        TEVO.BuildTimeArray(tSeg);
        TEVO.PlotEvolution(100);
        TEVO.MoveNext();
    end
    
    %---------------------------------------------
    % Test
    %---------------------------------------------
    if TEVO.TestGreaterSpecifyVel(VelMagInit)
        VelMagTrans = VelMagTrans * 0.99;
        TEVO.SetLoc(Loc);
    else
        TEVO.PlotSegmentMarker;
        TEVO.MoveBack();
        TEVO.PlotEvolution(1);
        TEVO.MoveNext();
        break
    end   
end

%---------------------------------------------
% Maintian Magnitude
%---------------------------------------------
while true
    tSeg = TEVO.SolveSpecifyAcc(0.1); 
%     if TEVO.TestGreaterSpecifyVel(VelMagTrans)
%         TEVO.PlotSegmentMarker;
%         TEVO.MoveBack();
%         TEVO.PlotEvolution(1);
%         TEVO.MoveNext();
%         break
%     end
    TEVO.BuildTimeArray(tSeg);
    TEVO.PlotEvolution(100);
    TEVO.MoveNext();
    if rem(TEVO.GetLoc(),500) == 0
        test = 0;
    end
end

%---------------------------------------------
% Test
%---------------------------------------------
if TEVO.TestLessVel0Seg()
    while true
        tSeg = TEVO.SolveSpecifyAcc(-AccReturn); 
        if TEVO.TestGreaterVel0Seg()
            break
        end
        ErrorAtVel = 10;
        if TEVO.TestLessSpecifyVel(ErrorAtVel)
            TEVO.MoveBack();
            TEVO.PlotEvolution(100);
            err.flag = 1;
            err.msg = 'Fix Evolution Design';
            return
        end
        TEVO.BuildTimeArray(tSeg);
        TEVO.PlotEvolution(100);
        TEVO.MoveNext();
    end    
end

%---------------------------------------------
% Maintain deceleration
%---------------------------------------------
MultVel = 5.0;
while true
    tSeg = TEVO.SolveSpecifyAcc(-AccReturn); 
    if TEVO.TestLessVel0SegMult(MultVel)
        break
    end
    TEVO.BuildTimeArray(tSeg);
    TEVO.PlotEvolution(100);
    TEVO.MoveNext();
end

%---------------------------------------------
% Transition to Design
%---------------------------------------------
JrkReturn = CACC.gaccreturn*PROJimp.gamma;
its = 1;
dir = 0;
n = 0;
Loc = TEVO.GetLoc();
while true
    while true
        tSeg = TEVO.SolveAccRampSpecifyJrk(JrkReturn); 
        TEVO.BuildTimeArray(tSeg);
        if TEVO.TestGreaterAcc0Seg()
            TEVO.PlotEvolution(1);
            break
        end
        TEVO.MoveNext();
    end
    if its == 1 || dir == 1
        if TEVO.TestGreaterVel0Seg()
            TEVO.SetLoc(Loc);
            tSeg = TEVO.SolveSpecifyAcc(-AccReturn);
            TEVO.BuildTimeArray(tSeg);
            %TEVO.PlotEvolution(1);
            TEVO.MoveNext();
            Loc = TEVO.GetLoc();
            dir = 1;
        else
            dir = 0;
        end
    else
        if TEVO.TestGreaterVel0Seg()
            break
        end
        n = n+1;
        TEVO.SetLoc(Loc);
        JrkReturn = CACC.gaccreturn*PROJimp.gamma*(1+0.01*n);
    end
    its = its+1;    
end

%---------------------------------------------
% Get it Right
%---------------------------------------------
Tweak = 1.000;
JrkReturn0 = JrkReturn*1.01;
while true
    n = 0;
    while true
        while true
            JrkReturn = JrkReturn0/(1+0.0001*n);
            tSeg = TEVO.SolveAccRampSpecifyJrk(JrkReturn); 
            TEVO.BuildTimeArray(tSeg);
            if TEVO.TestGreaterAcc0Seg()
                %TEVO.PlotEvolution(1);
                break
            end
            TEVO.MoveNext();
        end
        if TEVO.TestLessVel0SegMult(Tweak)
            break
        end
        TEVO.SetLoc(Loc);
        n = n+1;   
    end
    TEVO.BuildTimeArray(tSeg);
    TEVO.PlotEvolution(1);

    %---------------------------------------------
    % Finish
    %---------------------------------------------
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
    Tatkmax = TEVO.Tatkmax()
    if PROJdgn.tro >= (Tatkmax*0.99) && PROJdgn.tro <= (Tatkmax*1.01) 
        break
    elseif PROJdgn.tro > (Tatkmax*1.01)
        Tweak = Tweak*0.99999;
    elseif PROJdgn.tro < (Tatkmax*0.99)
        Tweak = Tweak*1.0001;
    end
    Tweak
    TEVO.SetLoc(Loc);
end

TEVO.PlotEvolutionFullSetup();
TEVO.PlotEvolutionFull();
TEVO.FixTiming();
TEVO.PlotEvolutionEnd();

CACC.TArr = TEVO.tSamp;
Status2('done','',3);
