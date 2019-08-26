%==================================================
% 
%==================================================

% function [CACC,err] = ConstEvol_TpiCentreAccelerate_v1g2_Func(CACC,INPUT)
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
function ConstEvol_TpiCentreAccelerate_v1g2_Func
% load('Test_20ms')
% CACC.gaccstart = 8000;
% CACC.gvelstart = 180;
% CACC.gacctransition = 4900;
% CACC.gvelreturn = 130;
% CACC.fracdecel = 0.10;
% CACC.returntwk = 0.999700;
% CACC.returntwk2 = 0.998800;

load('Test_5ms')
CACC.gaccstart = 8000;
CACC.gvelstart = 180;
CACC.gacctransition = 4200;
CACC.gvelreturn = 130;
CACC.fracdecel = 0.10;
CACC.returntwk = 0.999650;
CACC.returntwk2 = 0.999450;

tArr = Test.tArr.';
kArr = Test.kArr * Test.PROJdgn.kmax;
PROJdgn = Test.PROJdgn;
PROJimp.gamma = 11.26;
TST.figshift = -1800;
%===============================================

%---------------------------------------------
% Build TEVO Class
%---------------------------------------------
GradSlewMax = 195;
GradAccMax = 8000;
TEVO = TpiCentreAccelerate_v1g2(kArr,tArr,GradSlewMax,GradAccMax,PROJdgn,PROJimp,TST);
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
        if TEVO.TestRadGreaterP()
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
Loc = TEVO.GetLoc();
AccReturn0 = AccReturn;
while true
    AccReturn = AccReturn0;
    while true
        tSeg = TEVO.SolveSpecifyAcc(-AccReturn); 
        if TEVO.TestLessAcc0Seg()
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
        AccReturn = AccReturn^CACC.returntwk2;
    end

    %---------------------------------------------
    % Remainder
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
    returntwk2 = CACC.returntwk2    
    Tatkmax = TEVO.Tatkmax()
    if PROJdgn.tro >= (Tatkmax*0.995) && PROJdgn.tro <= (Tatkmax*1.005) 
        break
    elseif PROJdgn.tro > (Tatkmax*1.005)
        CACC.returntwk2 = CACC.returntwk2+0.000005;
    elseif PROJdgn.tro < (Tatkmax*0.995)
        CACC.returntwk2 = CACC.returntwk2-0.000005;
    end
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
