%==================================================
% 
%==================================================

% function [CACC,err] = ConstEvol_TpiCentreAccelerate_v1g_Func(CACC,INPUT)
% 
% Status2('busy','Constrain Trajectory Evolution',2);
% 
% err.flag = 0;
% err.msg = '';
% 
% %---------------------------------------------
% % Get Input / Build Class
% %---------------------------------------------
% PROJdgn = INPUT.PROJdgn;
% PROJimp = INPUT.PROJimp;
% TST = INPUT.TST;
% tArr = INPUT.TArr.';
% kArr = INPUT.kArr*PROJdgn.kmax;
% clear INPUT

%===============================================
function ConstEvol_TpiCentreAccelerate_v1g_Func
load('Test_5ms')
tArr = Test.tArr.';
kArr = Test.kArr * Test.PROJdgn.kmax;
PROJdgn = Test.PROJdgn;
PROJimp.gamma = 11.26;
TST.figshift = -1800;

CACC.gaccstart = 8000;
CACC.gvelstart = 180;
CACC.gacctransition = 4000;
CACC.gvelreturn = 149;
CACC.gaccreturn = 10;
CACC.fracdecel = 0.100;
%===============================================
CACC.returntwk = 0.999515;
CACC.returnhold = 0;

%---------------------------------------------
% Build TEVO Class
%---------------------------------------------
GradSlewMax = 195;
GradAccMax = 8000;
TEVO = TpiCentreAccelerate_v1g(kArr,tArr,GradSlewMax,GradAccMax,PROJdgn,PROJimp,TST);
TEVO.PlotEvolutionSetup();

%---------------------------------------------
% Test Deflection Angle
%---------------------------------------------
MaxAngle = 2.5;       % degree
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
        AccReturn = AccReturn^CACC.returntwk;
        if AccReturn < CACC.returnhold
            AccReturn = CACC.returnhold;
        end
        %AccReturn = AccReturn*0.996;
        %AccReturn = AccReturn - 4;
    end    
end

%---------------------------------------------
% Maintain deceleration
%---------------------------------------------
% while true
%     tSeg = TEVO.SolveSpecifyAcc(-AccReturn); 
%     TEVO.BuildTimeArray(tSeg);
%     TEVO.PlotEvolution(1);
%     TEVO.MoveNext();
% end

Tweak = 1.016;

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
        if TEVO.TestGreaterVel0SegMult(Tweak)
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
JrkReturn0 = JrkReturn*1.01;
Tatkmax0 = 0;
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
            if n == 0
                JrkReturn0 = JrkReturn0*1.05
            end
            n
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
    if PROJdgn.tro >= (Tatkmax*0.995) && PROJdgn.tro <= (Tatkmax*1.005) 
        break
    elseif PROJdgn.tro > (Tatkmax*1.005)
        Tweak = Tweak*0.9999;
    elseif PROJdgn.tro < (Tatkmax*0.995)
        Tweak = Tweak*1.001;
    end
    Tweak
    if round(Tatkmax*100000) == round(Tatkmax0*100000)
        %break;
    end
    Tatkmax0 = Tatkmax;
    TEVO.SetLoc(Loc);
end

TEVO.PlotEvolutionFullSetup();
TEVO.PlotEvolutionFull();
TEVO.FixTiming();
TEVO.PlotEvolutionEnd();
CACC.TArr = TEVO.tSamp;

%====================================================================================================
sz = size(kArr);
kArr0 = zeros(1,sz(1),sz(2));
kArr0(1,:,:) = kArr;
[vel,CACC.Tvel0] = CalcVelMulti_v2a(kArr0,CACC.TArr.');
[acc,CACC.Tacc0] = CalcAccMulti_v2a(vel,CACC.Tvel0);
[jerk,CACC.Tjerk0] = CalcJerkMulti_v2a(acc,CACC.Tacc0);
CACC.GmagMaxTraj = sqrt(vel(:,:,1).^2 + vel(:,:,2).^2 + vel(:,:,3).^2)/PROJimp.gamma;
CACC.GslewMaxTraj = sqrt(acc(:,:,1).^2 + acc(:,:,2).^2 + acc(:,:,3).^2)/PROJimp.gamma;
CACC.GaccMaxTraj = sqrt(jerk(:,:,1).^2 + jerk(:,:,2).^2 + jerk(:,:,3).^2)/PROJimp.gamma;  
fh = figure(15980); 
fh.Name = 'Test Trajectory Evolution';
fh.NumberTitle = 'off';
fh.Position = [400 150 1000 800];
subplot(2,2,1); hold on;
plot(CACC.Tvel0,CACC.GmagMaxTraj,'k-'); 
xlabel('tro (ms)'); ylabel('Gradient Magnitude (mT/m)'); title('Gradient Magnitude');
xlim([0 PROJdgn.tro]);
ylim([0 20]);
subplot(2,2,2); hold on;
plot(CACC.Tacc0,CACC.GslewMaxTraj,'k-');
xlabel('tro (ms)'); ylabel('Gradient Speed (mT/m/ms)'); title('Gradient Speed');
xlim([0 PROJdgn.tro]);
ylim([0 250]); 
subplot(2,2,3); hold on;
plot(CACC.Tjerk0,CACC.GaccMaxTraj,'k-');
xlabel('tro (ms)'); ylabel('Gradient Acceleration (mT/m/ms2)'); title('Gradient Acceleration');
xlim([0 PROJdgn.tro]);     
ylim([0 1e4]);
%====================================================================================================

Status2('done','',3);
