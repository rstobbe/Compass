%================================================================
%  
%================================================================

classdef ShapeAlongTraj_v2a < handle

properties (SetAccess = public)
    kArr;
    tArr;
    kMagArr;
    dRdt,dRdt2,dRdt3;
    dAdt,dAdt2,dAdt3;
    VelRad; VelCirc; Vel; 
    AccRad; AccCirc; Acc; 
    JrkRad; JrkCirc; Jrk;
    MaxJrk; MaxAcc;
    Gamma;
    tSamp;
    tSegArray;
    tSeg0Array;
    TrajLen;
    PolarAngleRad; PolarAngleDeg;
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
function obj = ShapeAlongTraj_v2a(kArr,tArr,GradSlewMax,GradAccMax,PROJdgn,PROJimp,TST)
    obj.kArr = kArr;
    obj.tArr = tArr;
    obj.TrajLen = length(tArr);
    obj.kMagArr = sqrt(kArr(:,1).^2 + kArr(:,2).^2 + kArr(:,3).^2);
    obj.tSamp = zeros(size(tArr));
    obj.Vel = zeros(size(tArr));
    obj.Acc = zeros(size(tArr));
    obj.Jrk = zeros(size(tArr)); 
    obj.VelRad = zeros(size(tArr));
    obj.AccRad = zeros(size(tArr));
    obj.JrkRad = zeros(size(tArr));  
    obj.VelCirc = zeros(size(tArr));
    obj.AccCirc = zeros(size(tArr));
    obj.JrkCirc = zeros(size(tArr));  
    obj.dRdt = zeros(size(tArr));    
    obj.dRdt2 = zeros(size(tArr));  
    obj.dRdt3 = zeros(size(tArr));    
    obj.dAdt = zeros(size(tArr));    
    obj.dAdt2 = zeros(size(tArr));    
    obj.dAdt3 = zeros(size(tArr));    
    obj.tSegArray = zeros(size(tArr(1:end-1)));
    obj.PolarAngleRad = zeros([obj.TrajLen-1,3]);
    obj.PolarAngleDeg = zeros([obj.TrajLen-1,3]);    
    obj.Loc = 2;
    obj.MaxJrk = GradAccMax*PROJimp.gamma;
    obj.MaxAcc = GradSlewMax*PROJimp.gamma;
    obj.Gamma = PROJimp.gamma;
    obj.Tro = tArr(end);
    obj.PROJdgn = PROJdgn;
    obj.TST = TST;
    obj.tSeg0Array =  tArr(2:end) - tArr(1:end-1);
    CalcPolarAngle(obj);    
end

%---------------------------------------------
% CalcPolarAngle
%---------------------------------------------
function CalcPolarAngle(obj)
    Vecs2 = obj.kArr(2:end,:);    
    Vecs1 = obj.kArr(1:end-1,:);   
    Dot = dot(Vecs2,Vecs1,2);
    Cross = cross(Vecs2,Vecs1,2); 
    for n = 1:length(Cross)
        NormCross(n) = norm(Cross(n,:));
    end
    obj.PolarAngleRad = atan2(NormCross.',Dot);
    obj.PolarAngleDeg = 180*obj.PolarAngleRad/pi;   
    % --- test ----
    %mVecs2 = sqrt(Vecs2(:,1).^2 + Vecs2(:,2).^2 + Vecs2(:,3).^2);
    %mVecs1 = sqrt(Vecs1(:,1).^2 + Vecs1(:,2).^2 + Vecs1(:,3).^2);    
    %TestPolarAngleRad = acos(Dot./(mVecs1.*mVecs2));    
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
% TestGreaterSpecifyAcc
%---------------------------------------------
function bool = TestGreaterSpecifyAcc(obj,MaxAcc)
    bool = 0;
    if CurAcc(obj) > MaxAcc
        bool = 1;
    end
end

%---------------------------------------------
% CalcDerivTinyDeflect
%       -> D = Vt + (1/2)*At^2 + (1/6)Jt^3  
%       -> Calc for constant jerk across segment
%       -> Valid for tiny polar angle
%---------------------------------------------
function CalcDerivTinyDeflect(obj,tSeg)
    DistVec = obj.kArr(obj.Loc,:)-obj.kArr(obj.Loc-1,:);
    MagDist = sqrt(DistVec(1)^2 + DistVec(2)^2 + DistVec(3)^2);
    obj.Jrk(obj.Loc,:) = (MagDist - obj.Vel(obj.Loc-1,:)*tSeg - (1/2)*obj.Acc(obj.Loc-1,:)*tSeg^2)*6/tSeg^3;                                                       
    obj.Acc(obj.Loc,:) = obj.Acc(obj.Loc-1,:) + (obj.Jrk(obj.Loc,:)*tSeg);                                                     
    obj.Vel(obj.Loc,:) = obj.Vel(obj.Loc-1,:) + (obj.Acc(obj.Loc-1,:)*tSeg) + (obj.Jrk(obj.Loc,:)*tSeg^2)/2;                    
end

%---------------------------------------------
% CalcVelAccJrk
%---------------------------------------------
function CalcVelAccJrk(obj,tSeg)  
    dR = obj.kMagArr(obj.Loc+1) - obj.kMagArr(obj.Loc);
    dA = obj.PolarAngleRad(obj.Loc);          

    obj.dRdt(obj.Loc) = dR/tSeg;
    obj.dRdt2(obj.Loc) = (obj.dRdt(obj.Loc)-obj.dRdt(obj.Loc-1))/tSeg;
    obj.dRdt3(obj.Loc) = (obj.dRdt2(obj.Loc)-obj.dRdt2(obj.Loc-1))/tSeg;
    obj.dAdt(obj.Loc) = dA/tSeg;
    obj.dAdt2(obj.Loc) = (obj.dAdt(obj.Loc)-obj.dAdt(obj.Loc-1))/tSeg;
    obj.dAdt3(obj.Loc) = (obj.dAdt2(obj.Loc)-obj.dAdt2(obj.Loc-1))/tSeg;
    
    obj.VelRad(obj.Loc) = obj.dRdt(obj.Loc);
    obj.VelCirc(obj.Loc) = obj.kMagArr(obj.Loc)*obj.dAdt(obj.Loc);        
    obj.Vel(obj.Loc) = sqrt(obj.VelRad(obj.Loc)^2 + obj.VelCirc(obj.Loc)^2);  

    obj.AccRad(obj.Loc) = obj.dRdt2(obj.Loc) - obj.kMagArr(obj.Loc)*obj.dAdt(obj.Loc)^2;
    obj.AccCirc(obj.Loc) = obj.kMagArr(obj.Loc)*obj.dAdt2(obj.Loc) + 2*obj.dRdt(obj.Loc)*obj.dAdt(obj.Loc);   
    obj.Acc(obj.Loc) =  sqrt(obj.AccRad(obj.Loc)^2 + obj.AccCirc(obj.Loc)^2); 
    
    obj.JrkRad(obj.Loc) = obj.dRdt3(obj.Loc) - 3*obj.kMagArr(obj.Loc)*obj.dAdt(obj.Loc)*obj.dAdt2(obj.Loc) - 3*obj.dRdt(obj.Loc)*obj.dAdt(obj.Loc)^2;
    obj.JrkCirc(obj.Loc) = 3*obj.dRdt2(obj.Loc)*obj.dAdt(obj.Loc) + 3*obj.dRdt(obj.Loc)*obj.dAdt2(obj.Loc) + obj.kMagArr(obj.Loc)*obj.dAdt3(obj.Loc) - obj.kMagArr(obj.Loc)*obj.dAdt(obj.Loc)^3;
    obj.Jrk(obj.Loc) = sqrt(obj.JrkRad(obj.Loc)^2 + obj.JrkCirc(obj.Loc)^2);   
end  

%---------------------------------------------
% SolveSpecifyAcc
%---------------------------------------------
function tSeg = SolveSpecifyAcc(obj,MaxAcc)
    tSegRoots = SegPredictAcc(obj,MaxAcc);
    tSeg0 = min(tSegRoots);
    tSeg = AdjustSegSpecifyAcc(obj,MaxAcc,tSeg0);
    obj.CalcVelAccJrk(tSeg);
end

%---------------------------------------------
% SolveAccRampSpecifyJrk
%---------------------------------------------
function tSeg = SolveAccRampSpecifyJrk(obj,Jrk)
    tSegRoots = SegSpecifyJrk(obj,Jrk);
    tSeg = min(tSegRoots);
    obj.CalcVelAccJrk(tSeg);
end

%---------------------------------------------
% SegSpecifyJrk
%---------------------------------------------
function tSegRoots = SegSpecifyJrk(obj,JrkVal)
    DistVec = obj.kArr(obj.Loc,:)-obj.kArr(obj.Loc-1,:);
    MagDist = sqrt(DistVec(1)^2 + DistVec(2)^2 + DistVec(3)^2);
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
    DistVec = obj.kArr(obj.Loc,:)-obj.kArr(obj.Loc-1,:);
    MagDist = sqrt(DistVec(1)^2 + DistVec(2)^2 + DistVec(3)^2);
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
% AdjustSegSpecifyAcc
%---------------------------------------------
function tSeg = AdjustSegSpecifyAcc(obj,AccVal,tSeg0)    
    rGradStep = 0.5;
    P = 8;                          % Grad search step
    its = 0;
    CalcVelAccJrk(obj,tSeg0);
    Acc0 = obj.Acc(obj.Loc); 
    while true
        if AccVal < 1e-5
            if abs(Acc0) < 1.0001*abs(AccVal) && abs(Acc0) > 0.9999*abs(AccVal)
                tSeg = tSeg0;
                break
            end
        else
            if abs(Acc0) < 1.00001*abs(AccVal) && abs(Acc0) > 0.99999*abs(AccVal)
                tSeg = tSeg0;
                break
            end
        end
        tSeg1 = tSeg0 * (1 + 10^-P);
        CalcVelAccJrk(obj,tSeg1);
        Acc1 = obj.Acc(obj.Loc);
        grad = (Acc1-Acc0)/(tSeg0-tSeg1);
        tSeg0 = tSeg0 + rGradStep*(Acc0-AccVal)/grad; 
        CalcVelAccJrk(obj,tSeg0);
        Acc0 = obj.Acc(obj.Loc); 
        its = its + 1;
        if its > 50
            error
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
% BuildTimeArray
%---------------------------------------------
function BuildTimeArrayStart(obj,tSeg)
    %CalcVelAccJrk(obj,tSeg);
    CalcDerivTinyDeflect(obj,tSeg);
    obj.tSegArray(obj.Loc-1) = tSeg;
    obj.tSamp(obj.Loc) = obj.tSamp(obj.Loc-1)+tSeg;
end 

%---------------------------------------------
% BuildTimeArray
%---------------------------------------------
function BuildTimeArray(obj,tSeg)
    CalcVelAccJrk(obj,tSeg);
    obj.tSegArray(obj.Loc-1) = tSeg;
    obj.tSamp(obj.Loc) = obj.tSamp(obj.Loc-1)+tSeg;
end 

%---------------------------------------------
% GetCurrentTime
%---------------------------------------------
function Time = GetCurrentTime(obj)
    Time = obj.tSamp(obj.Loc-1);
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
% PlotPolarAngle
%---------------------------------------------
function PlotPolarAngle(obj)
    figure(3457252);
    plot(obj.PolarAngleDeg,'k-');  
    ylabel('Polar Angle Degrees');
end 

%---------------------------------------------
% PlotEvolutionSetup
%---------------------------------------------
function PlotEvolutionSetup(obj)
    obj.PlotEvFigHand = figure(99002);
    if not(strcmp(obj.PlotEvFigHand.Name,'Trajectory Evolution'))  
        obj.PlotEvFigHand.Name = 'Trajectory Evolution';
        obj.PlotEvFigHand.NumberTitle = 'off';
        obj.PlotEvFigHand.Position = [200+obj.TST.figshift 150 1400 800];
        subplot(2,3,1); hold on; box on;
        %ylim([-20000 20000]); 
        %xlim([0 1.0]);
        title('Gradient Acceleration');
        xlabel('ms'); ylabel('mT/m/ms2');
        subplot(2,3,2); hold on; box on;
        ylim([-100 220]);
        %xlim([0 1.0]);
        title('Gradient Velocity');
        xlabel('ms'); ylabel('mT/m/ms');
        subplot(2,3,3); hold on; box on;
        %ylim([0 25]);
        %xlim([0 1.0]);
        title('Gradient Mag');
        xlabel('ms'); ylabel('mT/m');
        subplot(2,3,4); hold on; box on;
        %ylim([0 0.6]);
        %xlim([0 1.0]);
        title('Sampling Segment');
        xlabel('Segment Number'); ylabel('us');
        xlabel('ms'); ylabel('us');
        subplot(2,3,5); hold on; box on;
        plot(obj.tSeg0Array*1000,'r');
        ind = find(obj.kMagArr/obj.kMagArr(end) > obj.PROJdgn.p,1);
        plot(ind,obj.tSeg0Array(ind)*1000,'r*');
        ind = find(obj.tArr > 1,1);
        %ylim([0 0.6]);
        %xlim([0 ind]);
        title('Sampling Segment');
        xlabel('Segment Number'); ylabel('us');
        subplot(2,3,6); hold on; box on;
        %ylim([0 40]);
        %xlim([0 1.0]);
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
        delete(obj.PlotEvLineHands(1:10));
        obj.PlotEvLineHands(1) = plot(L,JrkVis/obj.Gamma,'k');
        subplot(2,3,2); 
        %obj.PlotEvLineHands(2) = plot(obj.tSamp(obj.Loc)-obj.tArr(obj.Loc)+obj.tArr(obj.Loc:end),obj.Acc0(obj.Loc:end)/obj.Gamma,'r');
        obj.PlotEvLineHands(2) = plot(obj.tSamp(1:obj.Loc),obj.AccRad(1:obj.Loc)/obj.Gamma,'r');
        obj.PlotEvLineHands(3) = plot(obj.tSamp(1:obj.Loc),obj.AccCirc(1:obj.Loc)/obj.Gamma,'b');
        obj.PlotEvLineHands(4) = plot(obj.tSamp(1:obj.Loc),obj.Acc(1:obj.Loc)/obj.Gamma,'k');
        subplot(2,3,3); 
        %obj.PlotEvLineHands(4) = plot(obj.tSamp(obj.Loc)-obj.tArr(obj.Loc)+obj.tArr(obj.Loc:end),obj.Vel0(obj.Loc:end)/obj.Gamma,'r');
        obj.PlotEvLineHands(5) = plot(obj.tSamp(1:obj.Loc),obj.VelRad(1:obj.Loc)/obj.Gamma,'r');
        obj.PlotEvLineHands(6) = plot(obj.tSamp(1:obj.Loc),obj.VelCirc(1:obj.Loc)/obj.Gamma,'b');
        obj.PlotEvLineHands(7) = plot(obj.tSamp(1:obj.Loc),obj.Vel(1:obj.Loc)/obj.Gamma,'k');        
        subplot(2,3,4); 
        obj.PlotEvLineHands(8) = plot(obj.tSamp(1:obj.Loc-1),obj.tSegArray(1:obj.Loc-1)*1000,'k');
        subplot(2,3,5); 
        obj.PlotEvLineHands(9) = plot(obj.tSegArray(1:obj.Loc-1)*1000,'k');
        subplot(2,3,6); 
        obj.PlotEvLineHands(10) = plot(obj.tSamp(1:obj.Loc),obj.kMagArr(1:obj.Loc),'k-');  
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
    plot(obj.tSamp(obj.Loc-2),obj.tSegArray(obj.Loc-2)*1000,'k*');
    subplot(2,3,5);
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