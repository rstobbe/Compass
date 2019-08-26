%==================================================
% Generate desired K-space location at each
% point the gradients change direction
%==================================================

function [T,KSA] = TPI2_GenProj_Movies(p,IV,elip,sd,projlen,slvno,visuals)

sdfunc = str2func(sd);
[G] = sdfunc(p);

set(0,'RecursionLimit',500);
options = odeset('RelTol',1e-4);

phi0 = [1*pi/6 2*pi/6 2*pi/6 2*pi/6 3*pi/6 3*pi/6 3*pi/6 3*pi/6 4*pi/6 4*pi/6 4*pi/6 5*pi/6];
theta0 = [0 1*pi/3 3*pi/3 5*pi/3 1*pi/4 3*pi/4 5*pi/4 7*pi/4 1*pi/3 3*pi/3 5*pi/3 0];
nproj = length(phi0);

slvint = (projlen-p)/(slvno-2);
tau = (0:slvint:(projlen-p));

if p == 1
    KSA = zeros(nproj,slvno,3);
    T = (0:1/(slvno-1):1);
else
    KSA = zeros(nproj,slvno,3);
    T = [0 p+tau]; 
end

for n = 1:nproj
    if p == 1
        r = (0:1/(slvno-1):1);
    else
        if phi0(n) == 0
            [x,Y] = ode23('CPA_Sol',tau,[p,theta0(n)],options,G,phi0(n));
            r = [0 real(Y(:,1))'];
            theta = zeros(1,slvno);
        else
            [x,Y] = ode23('CPA_Sol',tau,[p,theta0(n)],options,G,phi0(n));
            r = [0 real(Y(:,1))'];
            theta = [0 real(Y(:,2))'];
        end
    end
    %theta = zeros(1,slvno);
    KSA(n,:,1) = r.*cos(theta).*sin(phi0(n));                              % design location of each point in k-space
    KSA(n,:,2) = r.*sin(theta).*sin(phi0(n));
    KSA(n,:,3) = r.*cos(phi0(n))*elip;
           
    Status('busy',strcat('Building Projection:_',num2str(n)));
end

show = 1;
if show == 1
    Num = 50;
    MOVLEN = 50;
    time = (0:T(length(T))/(Num-1):T(length(T)));
    figure(10);
    plot3(0,0,0,'ok','markersize',5,'linewidth',5);
    m = 1;
    for n = 1:12
        xP = interp1(T,KSA(n,:,1),time);
        yP = interp1(T,KSA(n,:,2),time);
        zP = interp1(T,KSA(n,:,3),time);
        xP(Num+1:MOVLEN) = ones(1,MOVLEN-Num)*xP(Num);
        yP(Num+1:MOVLEN) = ones(1,MOVLEN-Num)*yP(Num);
        zP(Num+1:MOVLEN) = ones(1,MOVLEN-Num)*zP(Num);      
        for t = 2:MOVLEN
            h1 = figure(10); hold on;
            plot3(0,0,0,'ok','markersize',5,'linewidth',5);
            plot3(squeeze(xP(1:t)),squeeze(yP(1:t)),squeeze(zP(1:t)),'g','linewidth',1);
            axis equal; grid on; set(h1,'Renderer','ZBuffer');
            set(gca,'cameraposition',[-1000 -1500 350]); 
            set(gca,'xtick',[-1 0 1]); set(gca,'ytick',[-1 0 1]); set(gca,'ztick',[-1 0 1]);
            set(gca,'fontsize',12);
            axis([-1 1 -1 1 -1 1]);
            F(t) = getframe(h1);
            [X,~] = frame2im(F(t));
            X1(:,:,:,m) = rgb2ind(X,[gray(128);jet(128)]);
            m = m+1;
            %clf(h1);
        end   
    end
    size(X1)
    imwrite(X1,[gray(128);jet(128)],'EV.gif','gif','LoopCount',inf,'DelayTime',0.075);     
end
show = 0;
if show == 1
    Num = 12;
    MOVLEN = 100;
    time = (0:T(length(T))/(Num-1):T(length(T)));
    r0 = (0.001:1/(Num-1):1.001);
    r0(Num+1:MOVLEN) = ones(1,MOVLEN-Num);
    SD0 = (1./r0).^2;
    r0 = [r0;-r0];
    SD0 = [SD0;SD0];
    r1 = interp1(T,r,time);
    SD1 = (1./r1).^2;
    SD1(4:MOVLEN) = 25;
    r1 = [r1;-r1];
    SD1 = [SD1;SD1];
    m = 1;
    show = 1;
    if show == 1
        for n = 1:2     
            for t = 2:MOVLEN
                h1 = figure(11); hold on; plot(r0(n,1:t),SD0(n,1:t),'b','linewidth',4);
                h1 = figure(11); hold on; plot(r1(n,1:t),SD1(n,1:t),'r','linewidth',4);
                set(gca,'fontsize',14);
                axis([-1 1 0 50]);
                F(t) = getframe(h1);
                [X,~] = frame2im(F(t));
                X1(:,:,:,m) = rgb2ind(X,[gray(128);jet(128)]);
                m = m+1;
            end   
        end
        size(X1)
        imwrite(X1,[gray(128);jet(128)],'SD.gif','gif','LoopCount',inf,'DelayTime',0.075);     
    end
end
show = 0;
if show == 1
    Num = 50;
    MOVLEN = 50;
    time = (0:T(length(T))/(Num-1):T(length(T)));
    Sig = 0.6*exp(-time*5/2.9) + 0.4*exp(-time*5/29);
    Sig = [Sig;Sig];
    r0 = (0:1/(Num-1):1);
    r0 = [r0;-r0];
    r1 = interp1(T,r,time);
    r1 = [r1;-r1];
    m = 1;
    show = 1;
    if show == 1
        for n = 1:2     
            for t = 2:MOVLEN
                h1 = figure(11); hold on; plot(r0(n,1:t),Sig(n,1:t),'b','linewidth',4);
                h1 = figure(11); hold on; plot(r1(n,1:t),Sig(n,1:t),'r','linewidth',4);
                set(gca,'fontsize',14);
                axis([-1 1 0 1]);
                F(t) = getframe(h1);
                [X,~] = frame2im(F(t));
                X1(:,:,:,m) = rgb2ind(X,[gray(128);jet(128)]);
                m = m+1;
            end   
        end
        size(X1)
        imwrite(X1,[gray(128);jet(128)],'TF.gif','gif','LoopCount',inf,'DelayTime',0.075);     
    end
end


