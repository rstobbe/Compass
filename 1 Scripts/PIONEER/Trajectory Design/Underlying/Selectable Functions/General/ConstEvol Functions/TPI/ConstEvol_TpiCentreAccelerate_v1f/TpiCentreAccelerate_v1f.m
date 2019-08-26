%================================================================
%  
%================================================================

classdef TpiCentreAccelerate_v1f < handle

properties (SetAccess = public)
    kArr;
    tArr;
    kMagArr;
    Vel0; Acc0;
    Vel; Acc; Jrk;
    MaxJrk; MaxAcc;
    Gamma;
    tSamp;
    tSegArray;
    tSeg0Array;
    TrajLen;
    DefAngle;
    Loc;
    Tro;
    PlotEvFigHand; PlotEvFullFigHand;
    PlotEvLineHands; PlotEvFullLineHands;
    PROJdgn;
    TST;
end

methods 

%---------------------------------------------
% Constructor
%---------------------------------------------
function obj = TpiCentreAccelerate_v1f(kArr,tArr,GradSlewMax,GradAccMax,PROJdgn,PROJimp,TST)
    obj.kArr = kArr;
    obj.tArr = tArr;
    obj.TrajLen = length(tArr);
    obj.kMagArr = sqrt(kArr(:,1).^2 + kArr(:,2).^2 + kArr(:,3).^2);
    obj.tSamp = zeros(size(tArr));
    obj.Vel = zeros(size(tArr));
    obj.Acc = zeros(size(tArr));
    obj.Jrk = zeros(size(tArr));  
    obj.Vel0 = zeros(size(tArr));
    obj.Acc0 = zeros(size(tArr));
    obj.tSegArray = zeros(size(tArr(1:end-1)));
    obj.DefAngle = zeros([obj.TrajLen-1,3]);
    obj.Loc = 2;
    obj.MaxJrk = GradAccMax*PROJimp.gamma;
    obj.MaxAcc = GradSlewMax*PROJimp.gamma;
    obj.Gamma = PROJimp.gamma;
    obj.Tro = tArr(end);
    obj.PROJdgn = PROJdgn;
    obj.TST = TST;
    obj.tSeg0Array =  tArr(2:end) - tArr(1:end-1);
    CalcDeflectionAngle(obj);
    EstimateInitVelAcc(obj);
end

%---------------------------------------------
% CalcDeflectionAngle
%---------------------------------------------
function CalcDeflectionAngle(obj)
    m = (2:obj.TrajLen);
    Vecs0 = obj.kArr(m,:)-obj.kArr(m-1,:);
    Vecs2 = Vecs0(2:end,:);    
    Vecs1 = Vecs0(1:end-1,:);   
    Dot = dot(Vecs2,Vecs1,2);
    Cross = cross(Vecs2,Vecs1,2); 
    for n = 1:length(Cross)
        NormCross(n) = norm(Cross(n,:));
    end
    obj.DefAngle = atan2(NormCross.',Dot);
    obj.DefAngle = 180*obj.DefAngle/pi;
end    

%---------------------------------------------
% TestDeflectionAngle
%---------------------------------------------
function bool = TestDeflectionAngle(obj,angle)
    bool = 1;
    for n = 1:length(obj.DefAngle)
        if obj.DefAngle(n) > angle
            bool = 0;
        end
    end
end

%---------------------------------------------
% Simple Tests
%---------------------------------------------
function bool = TestGreaterMaxAcc(obj)
    bool = 0;
    if CurAcc(obj) > obj.MaxAcc
        bool = 1;
    end
end
function bool = TestGreaterSpecifyAcc(obj,MaxAcc)
    bool = 0;
    if CurAcc(obj) > MaxAcc
        bool = 1;
    end
end
function bool = TestGreaterZeroAcc(obj)
    bool = 0;
    if CurAcc(obj) > 0
        bool = 1;
    end
end
function bool = TestLessZeroAcc(obj)
    bool = 0;
    if CurAcc(obj) < 0
        bool = 1;
    end
end
function bool = TestLessNegMaxAcc(obj)
    bool = 0;
    if CurAcc(obj) < -obj.MaxAcc
        bool = 1;
    end
end
function bool = TestLessSpecifyAcc(obj,MaxAcc)
    bool = 0;
    if CurAcc(obj) < MaxAcc
        bool = 1;
    end
end
function bool = TestLessSpecifyVel(obj,Vel)
    bool = 0;
    test = CurVel(obj); 
    if test < Vel
        bool = 1;
    end
end

%---------------------------------------------
% Comparison Tests
%---------------------------------------------
function bool = TestGreaterAcc0Seg(obj)
    bool = 0;
    if CurAcc(obj) > obj.Acc0(obj.Loc)
        bool = 1;
    end
end
function bool = TestLessAcc0Seg(obj)
    bool = 0;
    if CurAcc(obj) < obj.Acc0(obj.Loc)
        bool = 1;
    end
end
function bool = TestGreaterVel0Seg(obj)
    bool = 0;
    if CurVel(obj) > obj.Vel0(obj.Loc)
        bool = 1;
    end
end
function bool = TestGreaterVel0SegMult(obj,Mult)
    bool = 0;
    if CurVel(obj) > Mult*obj.Vel0(obj.Loc)
        bool = 1;
    end
end
function bool = TestGreaterVel0SegFact(obj,Fact)
    bool = 0;
    if CurVel(obj) > obj.Vel0(obj.Loc)*Fact
        bool = 1;
    end
end
function bool = TestLessVel0SegMult(obj,Mult)
    bool = 0;
    if CurVel(obj) < Mult*obj.Vel0(obj.Loc)
        bool = 1;
    end
end
function bool = TestLessVel0Seg(obj)
    bool = 0;
    if CurVel(obj) < obj.Vel0(obj.Loc)
        bool = 1;
    end
end

%---------------------------------------------
% TimeSegComp
%---------------------------------------------
function val = TimeSegComp(obj)
    val = obj.tSegArray(obj.Loc-1)/obj.tSeg0Array(obj.Loc-1);
end

%---------------------------------------------
% TestFractionOfP
%---------------------------------------------
function bool = TestFractionOfP(obj,fraction)
    bool = 0;
    if obj.kMagArr(obj.Loc)/obj.kMagArr(end) > fraction*obj.PROJdgn.p
        bool = 1;
    end
end

%---------------------------------------------
% TestPastFractionVel
%---------------------------------------------
function bool = TestPastFractionVel(obj,fraction)
    bool = 0;
    if obj.Vel(obj.Loc) < fraction*obj.Vel0(obj.Loc)
        bool = 1;
    end
end    

%---------------------------------------------
% TestEnd
%---------------------------------------------
function bool = TestEnd(obj)
    bool = 0;
    if obj.Loc > length(obj.tArr)
        bool = 1;
    end
end

%---------------------------------------------
% EstimateInitVelAcc
%---------------------------------------------
function EstimateInitVelAcc(obj)
    for n = 2:length(obj.kMagArr)
        MagDist = obj.kMagArr(n)-obj.kMagArr(n-1);
        tSeg = obj.tArr(n)-obj.tArr(n-1);                                                  
        obj.Vel0(n) = MagDist/tSeg;
        obj.Acc0(n) = (obj.Vel0(n)-obj.Vel0(n-1))/tSeg;
    end
end  

%---------------------------------------------
% CalcDerivTinyDeflect
%       -> D = Vt + (1/2)*At^2 + (1/6)Jt^3  
%       -> Calc for constant jerk across segment
%       -> Valid for tiny deflection angle
%---------------------------------------------
function CalcDerivTinyDeflect(obj,tSeg)
    MagDist = obj.kMagArr(obj.Loc)-obj.kMagArr(obj.Loc-1);
    obj.Jrk(obj.Loc,:) = (MagDist - obj.Vel(obj.Loc-1,:)*tSeg - (1/2)*obj.Acc(obj.Loc-1,:)*tSeg^2)*6/tSeg^3;                                                       
    obj.Acc(obj.Loc,:) = obj.Acc(obj.Loc-1,:) + (obj.Jrk(obj.Loc,:)*tSeg);                                                     
    obj.Vel(obj.Loc,:) = obj.Vel(obj.Loc-1,:) + (obj.Acc(obj.Loc-1,:)*tSeg) + (obj.Jrk(obj.Loc,:)*tSeg^2)/2;                    
end  

%---------------------------------------------
% SolveMaxAcc
%---------------------------------------------
function tSeg = SolveMaxAcc(obj)
    tSegRoots = SegPredictAcc(obj,obj.MaxAcc);
    tSeg0 = min(tSegRoots);
    tSeg = AdjustSegSpecifyAcc(obj,obj.MaxAcc,tSeg0);    
    obj.CalcDerivTinyDeflect(tSeg);
end

%---------------------------------------------
% SolveNegMaxAcc
%---------------------------------------------
function tSeg = SolveNegMaxAcc(obj)
    tSegRoots = SegPredictAcc(obj,-obj.MaxAcc);
    tSeg0 = min(tSegRoots);
    tSeg = AdjustSegSpecifyAcc(obj,-obj.MaxAcc,tSeg0);    
    obj.CalcDerivTinyDeflect(tSeg);
end

%---------------------------------------------
% SolveSpecifyAcc
%---------------------------------------------
function tSeg = SolveSpecifyAcc(obj,MaxAcc)
    tSegRoots = SegPredictAcc(obj,MaxAcc);
    tSeg0 = min(tSegRoots);
    tSeg = AdjustSegSpecifyAcc(obj,MaxAcc,tSeg0);    
    obj.CalcDerivTinyDeflect(tSeg);
end

%---------------------------------------------
% SolveAccAtAcc0Time
%---------------------------------------------
function tSeg = SolveAccAtAcc0Time(obj)
    Acc0Time = GetAcc0Time(obj);
    tSegRoots = SegPredictAcc(obj,Acc0Time);
    tSeg0 = min(tSegRoots);
    tSeg = AdjustSegSpecifyAcc(obj,Acc0Time,tSeg0);    
    obj.CalcDerivTinyDeflect(tSeg);
end

%---------------------------------------------
% SolveAccAtAcc0Seg
%---------------------------------------------
function tSeg = SolveAccAtAcc0Seg(obj)
    Acc0Seg = GetAcc0Seg(obj);
    tSegRoots = SegPredictAcc(obj,Acc0Seg);
    tSeg0 = min(tSegRoots);
    tSeg = AdjustSegSpecifyAcc(obj,Acc0Seg,tSeg0);    
    obj.CalcDerivTinyDeflect(tSeg);
end

%---------------------------------------------
% SolveVelAtVel0Seg
%---------------------------------------------
function tSeg = SolveVelAtVel0Seg(obj)
    Acc0Seg = GetAcc0Seg(obj);
    tSegRoots = SegPredictAcc(obj,Acc0Seg);
    tSeg0 = min(tSegRoots);
    Vel0Seg = GetVel0Seg(obj);
    tSeg = AdjustSegSpecifyVel(obj,Vel0Seg,tSeg0);    
    obj.CalcDerivTinyDeflect(tSeg);
end

%---------------------------------------------
% SolveRampUpAcc
%---------------------------------------------
function tSeg = SolveRampUpAcc(obj)
    tSegRoots = SegSpecifyJrk(obj,obj.MaxJrk);
    tSeg = min(tSegRoots);
    obj.CalcDerivTinyDeflect(tSeg);
end

%---------------------------------------------
% SolveRampDownAcc
%---------------------------------------------
function tSeg = SolveRampDownAcc(obj)
    tSegRoots = SegSpecifyJrk(obj,-obj.MaxJrk);
    tSeg = min(tSegRoots);
    obj.CalcDerivTinyDeflect(tSeg);
end

%---------------------------------------------
% SolveAccRampSpecifyJrk
%---------------------------------------------
function tSeg = SolveAccRampSpecifyJrk(obj,Jrk)
    tSegRoots = SegSpecifyJrk(obj,Jrk);
    tSeg = min(tSegRoots);
    obj.CalcDerivTinyDeflect(tSeg);
end

%---------------------------------------------
% SegSpecifyJrk
%---------------------------------------------
function tSegRoots = SegSpecifyJrk(obj,JrkVal)
    MagDist = obj.kMagArr(obj.Loc)-obj.kMagArr(obj.Loc-1);
    tSegRoots = roots([JrkVal/6 obj.Acc(obj.Loc-1)/2 obj.Vel(obj.Loc-1) -MagDist]);
    for m = 1:length(tSegRoots)
        ind(m) = isreal(tSegRoots(m));                      % return only real
    end
    tSegRoots = tSegRoots(ind);  
    ind = logical([0 0 0]);
    for m = 1:length(tSegRoots)
        ind(m) = logical(tSegRoots(m) > 0);                          % return only positive
    end
    tSegRoots = tSegRoots(ind);       
end

%---------------------------------------------
% SegPredictAcc
%---------------------------------------------
function tSegRoots = SegPredictAcc(obj,AccVal)
    MagDist = obj.kMagArr(obj.Loc)-obj.kMagArr(obj.Loc-1);
    tSegRoots0 = roots([AccVal/2 obj.Vel(obj.Loc-1) -MagDist]);
    for m = 1:2
        ind(m) = isreal(tSegRoots0(m));                      % return only real
    end
    tSegRoots = tSegRoots0(ind);    
    if isempty(tSegRoots)
        error;
    end
    ind = logical([0 0]);
    for m = 1:length(tSegRoots)
        ind(m) = tSegRoots(m) > 0;                          % return only positive
    end
    tSegRoots = tSegRoots(ind);     
end

%---------------------------------------------
% SegPredictVel
%---------------------------------------------
function tSegRoot = SegPredictVel(obj,VelVal)
    Dist = obj.kArr(obj.Loc,:)-obj.kArr(obj.Loc-1,:);
    MagDist = sqrt(Dist(1)^2 + Dist(2)^2 + Dist(3)^2);
    tSegRoot = roots([VelVal -MagDist]);   
end

%---------------------------------------------
% AdjustSegSpecifyAcc
%---------------------------------------------
function tSeg = AdjustSegSpecifyAcc(obj,AccVal,tSeg0)    
    rGradStep = 0.5;
    P = 8;                          % Grad search step
    its = 0;
    CalcDerivTinyDeflect(obj,tSeg0);
    Acc0 = obj.Acc(obj.Loc); 
    MinAcc = Acc0;
    tSegBest = tSeg0;
    while true
        if abs(Acc0) < 1.00001*abs(AccVal) && abs(Acc0) > 0.99999*abs(AccVal)
            tSeg = tSeg0;
            break
        end
        tSeg1 = tSeg0 * (1 + 10^-P);
        CalcDerivTinyDeflect(obj,tSeg1);
        Acc1 = obj.Acc(obj.Loc);
        grad = (Acc1-Acc0)/(tSeg0-tSeg1);
        tSeg0 = tSeg0 + rGradStep*(Acc0-AccVal)/grad; 
        CalcDerivTinyDeflect(obj,tSeg0);
        Acc0 = obj.Acc(obj.Loc); 
        if Acc0 < MinAcc
            MinAcc = Acc0;
            tSegBest = tSeg0;
        end
        its = its + 1;
        if its > 50
            error
            %tSeg = tSegBest;
            %break
        end
    end
end

%---------------------------------------------
% AdjustSegSpecifyVel (AVOID!)
%---------------------------------------------
function tSeg = AdjustSegSpecifyVel(obj,VelVal,tSeg0)    
    rGradStep = 0.5;
    P = 8;                          % Grad search step
    its = 0;
    CalcDerivTinyDeflect(obj,tSeg0);
    Vel0 = obj.Vel(obj.Loc); 
    MinVel = Vel0;
    tSegBest = tSeg0;
    while true
        if abs(Vel0) < 1.000000001*abs(VelVal) && abs(Vel0) > 0.999999999*abs(VelVal)
            tSeg = tSeg0;
            break
        end
        tSeg1 = tSeg0 * (1 + 10^-P);
        CalcDerivTinyDeflect(obj,tSeg1);
        Vel1 = obj.Vel(obj.Loc);
        grad = (Vel1-Vel0)/(tSeg0-tSeg1);
        tSeg0 = tSeg0 + rGradStep*(Vel0-VelVal)/grad; 
        CalcDerivTinyDeflect(obj,tSeg0);
        Vel0 = obj.Vel(obj.Loc); 
        if Vel0 < MinVel
            MinVel = Vel0;
            tSegBest = tSeg0;
        end
        its = its + 1;
        if its > 30
            error
            %tSeg = tSegBest;
            %break
        end
    end
end

%---------------------------------------------
% MoveNext
%---------------------------------------------
function MoveNext(obj)
    obj.Loc = obj.Loc + 1;
end

%---------------------------------------------
% MoveBack
%---------------------------------------------
function MoveBack(obj)
    obj.Loc = obj.Loc - 1;
end

%---------------------------------------------
% GetLoc
%---------------------------------------------
function Loc = GetLoc(obj)
    Loc = obj.Loc;
end

%---------------------------------------------
% SetLoc
%---------------------------------------------
function SetLoc(obj,Loc)
    obj.Loc = Loc;
end

%---------------------------------------------
% GetSeg
%---------------------------------------------
function Seg = GetSeg(obj)
    Seg = obj.tSegArray(obj.Loc-1);                     % '-1' is right between SeqArray is shorter
end

%---------------------------------------------
% GetSeg0
%---------------------------------------------
function Seg = GetSeg0(obj)
    Seg = obj.tSeg0Array(obj.Loc-1);
end

%---------------------------------------------
% GetAcc0Seg
%---------------------------------------------
function Acc0Seg = GetAcc0Seg(obj)
    Acc0Seg = obj.Acc0(obj.Loc);
end

%---------------------------------------------
% GetVel0Seg
%---------------------------------------------
function Vel0Seg = GetVel0Seg(obj)
    Vel0Seg = obj.Vel0(obj.Loc);
end

%---------------------------------------------
% BuildTimeArray
%---------------------------------------------
function BuildTimeArray(obj,tSeg)
    CalcDerivTinyDeflect(obj,tSeg);
    obj.tSegArray(obj.Loc-1) = tSeg;
    obj.tSamp(obj.Loc) = obj.tSamp(obj.Loc-1)+tSeg;
end 

%---------------------------------------------
% Tatkmax
%---------------------------------------------
function Tatkmax = Tatkmax(obj)
    Tatkmax = interp1(obj.kMagArr/obj.PROJdgn.kmax,obj.tSamp,1,'spline'); 
end 

%---------------------------------------------
% FixTiming
%---------------------------------------------
function FixTiming(obj)
    obj.tSamp = obj.PROJdgn.tro*obj.tSamp/obj.Tatkmax ;
end 

%---------------------------------------------
% PlotDeflectionAngle
%---------------------------------------------
function PlotDeflectionAngle(obj)
    figure(99001);
    plot(obj.DefAngle,'k-');      
end 

%---------------------------------------------
% PlotEvolutionSetup
%---------------------------------------------
function PlotEvolutionSetup(obj)
    obj.PlotEvFigHand = figure(99002);
    if not(strcmp(obj.PlotEvFigHand.Name,'Trajectory Evolution'))  
        obj.PlotEvFigHand.Name = 'Trajectory Evolution';
        obj.PlotEvFigHand.NumberTitle = 'off';
        obj.PlotEvFigHand.Position = [260+obj.TST.figshift 150 1400 800];
        subplot(2,3,1); hold on; box on;
        ylim([-20000 20000]); 
        xlim([0 1.0]);
        %xlim([0 obj.Tro*1.1]); 
        title('Gradient Acceleration');
        xlabel('ms'); ylabel('mT/m/ms2');
        subplot(2,3,2); hold on; box on;
        ylim([-220 220]);
        xlim([0 1.0]);
        %xlim([0 obj.Tro*1.1]); 
        title('Gradient Velocity');
        xlabel('ms'); ylabel('mT/m/ms');
        subplot(2,3,3); hold on; box on;
        ylim([0 25]);
        xlim([0 1.0]);
        %xlim([0 obj.Tro*1.1]); 
        title('Gradient Mag');
        xlabel('ms'); ylabel('mT/m');
        subplot(2,3,4); hold on; box on;
        plot(obj.tSeg0Array*1000,'r');
        ind = find(obj.kMagArr/obj.kMagArr(end) > obj.PROJdgn.p,1);
        plot(ind,obj.tSeg0Array(ind)*1000,'r*');
        ind = find(obj.tArr > 1,1);
        xlim([0 ind]);
        ylim([0 0.6]);
        title('Sampling Segment');
        xlabel('Segment Number'); ylabel('us');
        subplot(2,3,5); hold on; box on;
        plot(obj.tSeg0Array*1000,'r');
        ylim([0 6]);
        title('Sampling Segment');
        xlabel('Segment Number'); ylabel('us');
        subplot(2,3,6); hold on; box on;
        ylim([0 40]);
        %ylim([0 max(obj.kMagArr)*1.1]); 
        xlim([0 1.0]);
        %xlim([0 obj.Tro*1.1]); 
        title('Radial Evolution');
        xlabel('ms'); ylabel('1/m');  
        drawnow;
    end
    for n = 1:12
        obj.PlotEvLineHands(n) = plot(0,0);
    end
end

%---------------------------------------------
% PlotEvolution
%---------------------------------------------
function PlotEvolution(obj,num)   
    if rem(obj.Loc,num) == 0 
        delete(obj.PlotEvLineHands(1:8));
        figure(obj.PlotEvFigHand);
        subplot(2,3,1);
        JrkVis = zeros(1,(obj.Loc-1)*2); 
        L = zeros(1,(obj.Loc-1)*2);
        for n = 1:obj.Loc-1
            L((n-1)*2+1) = obj.tSamp(n);
            L(n*2) = obj.tSamp(n+1);
            JrkVis((n-1)*2+1) = obj.Jrk(n+1);
            JrkVis(n*2) = obj.Jrk(n+1);
        end    
        obj.PlotEvLineHands(1) = plot(L,JrkVis/obj.Gamma,'k');
        subplot(2,3,2); 
        obj.PlotEvLineHands(2) = plot(obj.tSamp(obj.Loc)-obj.tArr(obj.Loc)+obj.tArr(obj.Loc:end),obj.Acc0(obj.Loc:end)/obj.Gamma,'r');
        obj.PlotEvLineHands(3) = plot(obj.tSamp(1:obj.Loc),obj.Acc(1:obj.Loc)/obj.Gamma,'k');
        subplot(2,3,3); 
        obj.PlotEvLineHands(4) = plot(obj.tSamp(obj.Loc)-obj.tArr(obj.Loc)+obj.tArr(obj.Loc:end),obj.Vel0(obj.Loc:end)/obj.Gamma,'r');
        obj.PlotEvLineHands(5) = plot(obj.tSamp(1:obj.Loc),obj.Vel(1:obj.Loc)/obj.Gamma,'k');
        subplot(2,3,4); 
        obj.PlotEvLineHands(6) = plot(obj.tSegArray(1:obj.Loc-1)*1000,'k');
        subplot(2,3,5); 
        obj.PlotEvLineHands(7) = plot(obj.tSegArray(1:obj.Loc-1)*1000,'k');
        subplot(2,3,6); 
        obj.PlotEvLineHands(8) = plot(obj.tSamp(1:obj.Loc),obj.kMagArr(1:obj.Loc),'k-');  
        PlotPMarker(obj);
        drawnow;
    end
end 

%---------------------------------------------
% PlotEvolutionEnd
%---------------------------------------------
function PlotEvolutionEnd(obj)   
    figure(obj.PlotEvFigHand);
    subplot(2,3,1);
    JrkVis = zeros(1,(obj.Loc-1)*2); 
    L = zeros(1,(obj.Loc-1)*2);
    for n = 1:obj.Loc-1
        L((n-1)*2+1) = obj.tSamp(n);
        L(n*2) = obj.tSamp(n+1);
        JrkVis((n-1)*2+1) = obj.Jrk(n+1);
        JrkVis(n*2) = obj.Jrk(n+1);
    end    
    plot(L,JrkVis/obj.Gamma,'b');
    subplot(2,3,2); 
    plot(obj.tSamp(1:obj.Loc),obj.Acc(1:obj.Loc)/obj.Gamma,'b');
    subplot(2,3,3); 
    plot(obj.tSamp(1:obj.Loc),obj.Vel(1:obj.Loc)/obj.Gamma,'b');
    subplot(2,3,6); 
    plot(obj.tSamp(1:obj.Loc),obj.kMagArr(1:obj.Loc),'b-');  
    PlotPMarker(obj);
    drawnow;
end 

%---------------------------------------------
% PlotPMarker
%---------------------------------------------
function PlotPMarker(obj)   
    if obj.kMagArr(obj.Loc)/obj.kMagArr(end) > obj.PROJdgn.p
        delete(obj.PlotEvLineHands(9:10));
        itSamp = interp1(obj.kMagArr(1:obj.Loc)/obj.kMagArr(end),obj.tSamp(1:obj.Loc),obj.PROJdgn.p);
        iVel = interp1(obj.kMagArr(1:obj.Loc)/obj.kMagArr(end),obj.Vel(1:obj.Loc),obj.PROJdgn.p);
        figure(obj.PlotEvFigHand);
        subplot(2,3,3);
        obj.PlotEvLineHands(9) = plot(itSamp,iVel/obj.Gamma,'r*');
        subplot(2,3,6);
        obj.PlotEvLineHands(10) = plot(itSamp,obj.PROJdgn.p*obj.kMagArr(end),'r*');
    end
end

%---------------------------------------------
% PlotSegmentMarker
%---------------------------------------------
function PlotSegmentMarker(obj)   
    figure(obj.PlotEvFigHand);
    subplot(2,3,4);
    plot(obj.Loc-2,obj.tSegArray(obj.Loc-2)*1000,'k*');
end
    
%---------------------------------------------
% PlotEvolutionFullSetup
%---------------------------------------------
function PlotEvolutionFullSetup(obj)
    obj.PlotEvFullFigHand = figure(99003);
    if not(strcmp(obj.PlotEvFullFigHand.Name,'Trajectory Evolution (Full)'))  
        obj.PlotEvFullFigHand.Name = 'Trajectory Evolution (Full)';
        obj.PlotEvFullFigHand.NumberTitle = 'off';
        obj.PlotEvFullFigHand.Position = [260+obj.TST.figshift 150 1400 800];
        subplot(2,3,1); hold on; box on;
        ylim([-10000 10000]); 
        xlim([0 obj.Tro*1.1]); 
        title('Gradient Acceleration');
        xlabel('ms'); ylabel('mT/m/ms2');
        subplot(2,3,2); hold on; box on;
        ylim([-220 220]);
        xlim([0 obj.Tro*1.1]); 
        title('Gradient Velocity');
        xlabel('ms'); ylabel('mT/m/ms');
        subplot(2,3,3); hold on; box on;
        ylim([0 25]);
        xlim([0 obj.Tro*1.1]); 
        title('Gradient Mag');
        xlabel('ms'); ylabel('mT/m');
        subplot(2,3,4); hold on; box on;
        plot(obj.tSeg0Array*1000,'r');
        ylim([0 15]);
        title('Sampling Segment');
        xlabel('Segment Number'); ylabel('us');
        subplot(2,3,5); hold on; box on;
        ylim([-max(obj.kMagArr)*1.1 max(obj.kMagArr)*1.1]); 
        xlim([0 obj.Tro*1.1]); 
        title('k-Space Evolution');
        xlabel('ms'); ylabel('1/m');
        subplot(2,3,6); hold on; box on;
        ylim([0 max(obj.kMagArr)*1.1]); 
        xlim([0 obj.Tro*1.1]); 
        title('Radial Evolution');
        xlabel('ms'); ylabel('1/m');  
        drawnow;
    end
end

%---------------------------------------------
% PlotEvolutionFull
%---------------------------------------------
function PlotEvolutionFull(obj)   
    figure(obj.PlotEvFullFigHand);
    subplot(2,3,1);
    JrkVis = zeros(1,(length(obj.Jrk)-1)*2); 
    L = zeros(1,(length(obj.Jrk)-1)*2);
    for n = 1:length(obj.Jrk)-1
        L((n-1)*2+1) = obj.tSamp(n);
        L(n*2) = obj.tSamp(n+1);
        JrkVis((n-1)*2+1) = obj.Jrk(n+1);
        JrkVis(n*2) = obj.Jrk(n+1);
    end    
    plot(L,JrkVis/obj.Gamma,'k');
    subplot(2,3,2); 
    plot(obj.tSamp,obj.Acc/obj.Gamma,'k');
    subplot(2,3,3); 
    plot(obj.tSamp,obj.Vel/obj.Gamma,'k');
    subplot(2,3,4); 
    plot(obj.tSegArray(1:length(obj.Jrk)-1)*1000,'k');
    subplot(2,3,5); 
    plot(obj.tSamp,obj.kArr(:,1),'b-');
    plot(obj.tSamp,obj.kArr(:,2),'g-');
    plot(obj.tSamp,obj.kArr(:,3),'r-');  
    subplot(2,3,6); 
    plot(obj.tSamp,obj.kMagArr,'k-');  
    PlotPMarker(obj);
    drawnow;
end 
    
%---------------------------------------------
% Derivative/Segment Return
%---------------------------------------------
function Vel = CurVel(obj)
    Vel = obj.Vel(obj.Loc);
end
function Vel = PrevVel(obj)
    Vel = obj.Vel(obj.Loc-1);
end
function Acc = CurAcc(obj)
    Acc = obj.Acc(obj.Loc);
end
function Acc = PrevAcc(obj)
    Acc = obj.Acc(obj.Loc-1);
end
function Jrk = CurJrk(obj)
    Jrk = obj.Jrk(obj.Loc);
end
function Jrk = PrevJrk(obj)
    Jrk = obj.Jrk(obj.Loc-1);
end
function tSeg = PrevSeg(obj)
    tSeg = obj.tSegArray(obj.Loc-2);
end


end
end