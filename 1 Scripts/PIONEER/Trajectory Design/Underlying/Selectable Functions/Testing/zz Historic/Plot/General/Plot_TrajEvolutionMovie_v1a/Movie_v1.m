%----------------------------------------------------
% Trajectory Movie
%----------------------------------------------------
r = (0:0.5:1);
KSA = zeros(length(r),3);
m = 1;
show = 0;
if show == 1
    for n = 1:nproj
        phi0 = IV(1,:);
        theta0 = IV(2,:);
        KSA(:,1) = r*cos(theta0(n))*sin(phi0(n));                              % design location of each point in k-space
        KSA(:,2) = r*sin(theta0(n))*sin(phi0(n));
        KSA(:,3) = r*cos(phi0(n))*elip;

        for t = 2:length(r)
            h1 = figure(10); plot3(squeeze(KSA(1:t,1)),squeeze(KSA(1:t,2)),squeeze(KSA(1:t,3)),'b');
            hold on; axis equal; grid on; set(h1,'Renderer','ZBuffer');
            set(gca,'cameraposition',[-1000 -2000 300]); 
            set(gca,'xtick',[-1 0 1]); set(gca,'ytick',[-1 0 1]); set(gca,'ztick',[-1 0 1]);
            set(gca,'fontsize',12);
            axis([-1 1 -1 1 -1 1]);
            F(t) = getframe(h1);
            [X,~] = frame2im(F(t));
            X1(:,:,:,m) = rgb2ind(X,[gray(128);jet(128)]);
            m = m+1;
        end   
    end
    size(X1)
    imwrite(X1,[gray(128);jet(128)],'SP.gif','gif','LoopCount',inf,'DelayTime',0.075);     
end
    