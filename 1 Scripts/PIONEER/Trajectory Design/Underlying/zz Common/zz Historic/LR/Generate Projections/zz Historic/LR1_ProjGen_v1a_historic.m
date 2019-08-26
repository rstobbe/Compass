%==================================================
% Generate k-Space Trajectories
%==================================================

function [Tout,KSA,PROJdgn,PROJipt,error,errorflag] = LR1_ProjGen_v1a(PROJdgn,PROJipt,visuals,genproj)

error = '';
errorflag = 0;
Tout = 0;
KSA = 0;
kstep = PROJdgn.kstep;
nproj = PROJdgn.nproj;
ndiscs = PROJdgn.ProjDistStruct.ndiscs;
kmax = PROJdgn.kmax;
rad = PROJdgn.rad;
tro = PROJdgn.tro;
phi0 = PROJdgn.ProjDistStruct.IV(1,:);
theta0 = PROJdgn.ProjDistStruct.IV(2,:);


projreqfun = PROJipt(strcmp('ProjReq',{PROJipt.labelstr})).entrystr;
atsifun = PROJipt(strcmp('ATSiso',{PROJipt.labelstr})).entrystr;
atsafun = PROJipt(strcmp('ATSaniso',{PROJipt.labelstr})).entrystr;
accproffun = PROJipt(strcmp('AccProf',{PROJipt.labelstr})).entrystr;
constacc = PROJipt(strcmp('Constrain_Acc',{PROJipt.labelstr})).entrystr;
if iscell(constacc)
    constacc = PROJipt(strcmp('Constrain_Acc',{PROJipt.labelstr})).entrystr{PROJipt(strcmp('Constrain_Acc',{PROJipt.labelstr})).entryvalue};
end
initstrght = PROJipt(strcmp('Init_Straight',{PROJipt.labelstr})).entrystr;
if iscell(initstrght)
    initstrght = PROJipt(strcmp('Init_Straight',{PROJipt.labelstr})).entrystr{PROJipt(strcmp('Init_Straight',{PROJipt.labelstr})).entryvalue};
end
test1proj = PROJipt(strcmp('Test1Proj',{PROJipt.labelstr})).entrystr;
if iscell(test1proj)
    test1proj = PROJipt(strcmp('Test1Proj',{PROJipt.labelstr})).entrystr{PROJipt(strcmp('Test1Proj',{PROJipt.labelstr})).entryvalue};
end

%------------------------------------------
% Design Functions
%------------------------------------------
func = str2func(atsifun);
ATSIFUN = func(PROJipt);
func = str2func(atsafun);
ATSAFUN = func(PROJipt);
func = str2func(projreqfun);           
PROJREQFUN = func(PROJipt);
if visuals == 2 
    r = (0:0.01:1);
    figure(90); hold on; plot(r,PROJREQFUN(r,nproj),'k-','linewidth',2); xlabel('Relative Radial Value'); ylabel('Projections Required for Full Sampling');
    figure(91); hold on; plot(r,ATSIFUN(r),'k-','linewidth',2); xlabel('Relative Radial Value'); ylabel('Relative Angular Trajectory Spacing'); title('Relative Angular Trajectory Function');
end
               
%------------------------------------------
% LR1 Spinning Functions
%------------------------------------------
sphi = @(r,theta) ATSAFUN(theta)*(2*(pi*rad*ATSIFUN(r))^2)/PROJREQFUN(r,nproj);      
stheta = @(r,theta) ATSAFUN(theta)*(pi*rad*ATSIFUN(r))/PROJREQFUN(r,ndiscs);                  

%------------------------------------------
% DE Solution Timing
%------------------------------------------
DEST.initstrght = initstrght;
[RADEVFUN,p,tau1,tau2,plin] = DEst_Flower_v1(PROJipt,DEST,visuals);

%==========================================
% SOLVE
%==========================================
if strcmp(test1proj,'Yes')
    nproj = 1;
end
options = odeset('AbsTol',[1e-6,1e-5,1e-5]);
for n = 1:nproj  
    Status2('busy',num2str(n),2);
    Status('busy','Solving Differential Equations');
    if strcmp(initstrght,'Yes') 
        r1 = p;
        phi1 = phi0(n);
        theta1 = theta0(n);
    else
        [x,Y] = ode45('LR1_Fun',tau1,[p,phi0(n),theta0(n)],options,RADEVFUN,sphi,stheta);         
        r1 = real(Y(:,1))'  
        phi1 = real(Y(:,2))'; 
        theta1 = real(Y(:,3))';
        if r1(length(r1)) < 0
            errorflag = 1;
            error.string = 'Negative DE Solution Problem - Alter RadEv Func';
            arr = (1:20);
            error.inputno = arr(strcmp('RadEv',{PROJipt.labelstr}));
            return
        end
    end        
    [x,Y] = ode45('LR1_Fun',tau2,[p,phi0(n),theta0(n)],options,RADEVFUN,sphi,stheta);
    
    r = [0 flipdim(r1,2) real(Y(2:length(tau2),1))'];
    phi = [0 flipdim(phi1,2) real(Y(2:length(tau2),2))']; 
    theta = [0 flipdim(theta1,2) real(Y(2:length(tau2),3))'];
    
    %test = r(length(r))
    if round(max(r)*1000)/1000 < 1
        errorflag = 1;
        error.string = 'DE Not Solved to End of Trajectory';
        error.inputno = 0;
        return
    end

    %------------------------------------------
    % Calculate k-Space Array
    %------------------------------------------
    slvno = length(r);
    if n == 1 
        KSA = zeros(nproj,slvno,3);
        Tout = zeros(nproj,slvno);
    end
    KSA(n,:,1) = r.*cos(theta).*sin(phi);                              
    KSA(n,:,2) = r.*sin(theta).*sin(phi);
    KSA(n,:,3) = r.*cos(phi);
    
    %------------------------------------------
    % Calculate Real Timings
    %------------------------------------------
    %T = linspace(0,5,length(KSA));
    do = 1;
    if do == 1
        if strcmp(initstrght,'Yes')
            tautot = p+[-p flipdim(tau1,2) tau2(2:length(tau2))];
        else
            tautot = (plin)+[-(plin) flipdim(tau1,2) tau2(2:length(tau2))];      % (plin) for negative differential solution - from [1-40] thesis
        end    
        projlen0 = tautot(length(tautot));
        realT = (1/projlen0)*tro;
        T = tautot*realT;
    end

    %------------------------------------------
    % Calculate Speed and Acceleration
    %------------------------------------------    
    T0(:,1) = T; T0(:,2) = T; T0(:,3) = T;
    KSA2 = squeeze(KSA(n,:,:))*kmax;
    [vel] = CalcVel_v1(KSA2,T0);
    [acc] = CalcAcc_v1(vel,T0);
    magvel = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
    magacc = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
    
    %------------------------------------------
    % Plot Sampling Timing Characteristics
    %------------------------------------------  
    if visuals == 2 
        figure(200); hold on; plot(T,magacc,'b','linewidth',2); xlim([0 tro]); ylim([0 100000]); xlabel('Real Time (ms)'); ylabel('Magnitude of Acceleration (1/(m*ms^2)'); title('Magnitude of Acceleration Through k-Space');
        figure(201); hold on; plot(T,magacc,'b','linewidth',2); xlim([0 0.1]); ylim([0 100000]);  xlabel('Real Time (ms)'); ylabel('Magnitude of Acceleration (1/(m*ms^2)'); title('Magnitude of Acceleration Through k-Space');
        figure(202); hold on; plot(T,magvel,'b','linewidth',2); xlim([0 tro]); ylim([0 1000]); xlabel('Real Time (ms)'); ylabel('Magnitude of Velocity (1/(m*ms)'); title('Magnitude of Velocity');
        figure(203); hold on; plot(T,kstep./magvel,'b','linewidth',2); xlim([0 tro]); ylim([0 2*kstep/min(magvel(2:length(magvel)))]); xlabel('Real Time (ms)'); ylabel('Maximum Sampling Dwell'); title('Maximum Sampling Dwell');
    end

    if strcmp(constacc,'Yes')
        
        %------------------------------------------
        % Acceleration Profile
        %------------------------------------------        
        ind = length(magacc);             % constrain to acceleration value at end of projection         
        func = str2func(accproffun);
        AccProfFunc = func();
        AccProf = magacc(ind)*ones(1,length(T)).*AccProfFunc(T);
        
        %------------------------------------------
        % Constrain Acceleration
        %------------------------------------------
        Status('busy','Constrain Acceleration');
        [T] = ConstAcc_v1(magacc,AccProf,T);
        relprojlen = T(length(T))/tro;
        T = tro*T/T(length(T));
        T0(:,1) = T; T0(:,2) = T; T0(:,3) = T;
        [vel] = CalcVel_v1(KSA2,T0);
        [acc] = CalcAcc_v1(vel,T0);
        magacc = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
        magvel = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);      
        
        %------------------------------------------
        % Plot Sampling Timing Characteristics
        %------------------------------------------
        if visuals == 2 
            figure(200); hold on; plot(T,magacc,'r','linewidth',2); ylim([0 10000]); xlabel('Real Time (ms)'); ylabel('Magnitude of Acceleration (1/(m*ms^2)'); title('Magnitude of Acceleration Through k-Space');
            figure(201); hold on; plot(T,magacc,'r*-','linewidth',2); ylim([0 10000]); xlabel('Real Time (ms)'); ylabel('Magnitude of Acceleration (1/(m*ms^2)'); title('Magnitude of Acceleration Through k-Space');
            figure(202); hold on; plot(T,magvel,'r','linewidth',2); xlabel('Real Time (ms)'); ylabel('Magnitude of Velocity (1/(m*ms)'); title('Magnitude of Velocity Through k-Space');
            figure(203); hold on; plot(T,kstep./magvel,'r','linewidth',2); ylim([0 2*kstep/max(magvel)]); xlabel('Real Time (ms)'); ylabel('Maximum Sampling Dwell'); title('Maximum Sampling Dwell');
        end
        if visuals == 2 
            figure(350); hold on; plot(T,squeeze(KSA(n,:,1))*kmax,'b','linewidth',2); title('x k-space');
            figure(351); hold on; plot(T,squeeze(KSA(n,:,2))*kmax,'b','linewidth',2); title('y k-space');
            figure(352); hold on; plot(T,squeeze(KSA(n,:,3))*kmax,'b','linewidth',2); title('z k-space');
        end
        if visuals == 2 
            figure(360); hold on; plot(T,'b','linewidth',2); xlabel('Solution Segment'); ylabel('Segment Time'); title('Constrained Acceleration Solution Timing');
        end
    end

    %------------------------------------------
    % Plot SD Shape
    %------------------------------------------
    dr = zeros(1,slvno);
    for m = 2:slvno
        dr(m) = (r(m)-r(m-1))/(relprojlen*T(m)/realT-relprojlen*T(m-1)/realT);
    end
    Gam = zeros(1,slvno);
    Gam(2:slvno) = p^2./(dr(2:slvno).*r(2:slvno).^2);
    Gam(1) = Gam(2);
    itpRad = (0:0.01:1);
    itpGam = interp1(r,Gam,itpRad);
    if visuals == 2 
        figure(400); hold on; plot(itpRad,itpGam,'m','linewidth',2); xlim([0 1]); ylim([0 1.1*max(itpGam(10))]); xlabel('Relative k-Space Radius'); ylabel('Sampling Density'); title('Relative Radial k-Space Sampling Density');
    end

    %------------------------------------------
    % Plot Radial k-Space Sampling Times 
    %------------------------------------------
    if visuals == 2 
        figure(410); hold on; plot(T,r,'g','linewidth',2); xlabel('Real Time (ms)'); ylabel('Relative k-Space Radius'); title('Relative Radial k-Space Sampling Time');
    end

    %------------------------------------------
    % Plot 3D
    %------------------------------------------
    Status('busy','Plot Trajectories');
    clr = ['r' 'b' 'g' 'm' 'c'];
    clr = [clr clr clr clr clr clr clr]; clr = [clr clr clr clr];
    if visuals == 2 || visuals == 3
        RR = 1.0;
        ind = find(r*rad > RR,1,'first');
        figure(500); hold on; plot3(squeeze(KSA(n,1:ind,1))*rad,squeeze(KSA(n,1:ind,2))*rad,squeeze(KSA(n,1:ind,3))*rad,clr(n)); title('Centre Portion Looping-Radial Trajectory');
        hold on; axis equal; grid on; box on;
        axis([-RR RR -RR RR -RR RR]);
        set(gca,'xtick',[-1 -0.5 0 0.5 1]); set(gca,'ytick',[-1 -0.5 0 0.5 1]); set(gca,'ztick',[-1 -0.5 0 0.5 1]);
    end
    if visuals == 2 || visuals == 3
        RR = 2.5;
        ind = find(r*rad > RR,1,'first');
        figure(501); hold on; plot3(squeeze(KSA(n,1:ind,1))*rad,squeeze(KSA(n,1:ind,2))*rad,squeeze(KSA(n,1:ind,3))*rad,clr(n)); title('Centre Portion Looping-Radial Trajectory');
        hold on; axis equal; grid on; box on;
        axis([-RR RR -RR RR -RR RR]);
        set(gca,'xtick',[-2 -1 0 1 2]); set(gca,'ytick',[-2 -1 0 1 2]); set(gca,'ztick',[-2 -1 0 1 2]);
    end
    if visuals == 2 || visuals == 3
        RR = 5.0;
        ind = find(r*rad > RR,1,'first');
        figure(502); hold on; plot3(squeeze(KSA(n,1:ind,1))*rad,squeeze(KSA(n,1:ind,2))*rad,squeeze(KSA(n,1:ind,3))*rad,clr(n)); title('Centre Portion Looping-Radial Trajectory');
        hold on; axis equal; grid on; box on;
        axis([-RR RR -RR RR -RR RR]);
        set(gca,'xtick',[-5 -2.5 0 2.5 5]); set(gca,'ytick',[-5 -2.5 0 2.5 5]); set(gca,'ztick',[-5 -2.5 0 2.5 5]);
    end     
    if visuals == 2 || visuals == 3
        figure(503); plot3(squeeze(KSA(n,:,1))*rad,squeeze(KSA(n,:,2))*rad,squeeze(KSA(n,:,3))*rad,clr(n)); title('Looping-Radial Trajectory');
        hold on; axis equal; grid on; box on;
        set(gca,'cameraposition',[-1000 -2000 300]); 
        %set(gca,'xtick',[-20 0 20]); set(gca,'ytick',[-20 0 20]); set(gca,'ztick',[-20 0 20]);
        set(gca,'xtick',[-ceil(rad) -ceil(rad)/2 0 ceil(rad)/2 ceil(rad)]); 
        set(gca,'ytick',[-ceil(rad) -ceil(rad)/2 0 ceil(rad)/2 ceil(rad)]); 
        set(gca,'ztick',[-ceil(rad) -ceil(rad)/2 0 ceil(rad)/2 ceil(rad)]);
        set(gca,'fontsize',12);
        axis([-ceil(rad) ceil(rad) -ceil(rad) ceil(rad) -ceil(rad) ceil(rad)]);
    end
       
    Tout(n,:) = T/tro;
    if strcmp(constacc,'Yes')
        acc = magacc(length(magacc));
    else
        acc = max(magacc);
    end
    maxsmpdwell = kstep/max(magvel);
end

PROJdgn.relprojlen = relprojlen;     % acceleration constraint related projection length increase
PROJdgn.acc = acc;
PROJdgn.maxsmpdwell = maxsmpdwell;
PROJdgn.sdcR = itpRad;
PROJdgn.sdcTF = itpGam;

Status2('done','',2);

