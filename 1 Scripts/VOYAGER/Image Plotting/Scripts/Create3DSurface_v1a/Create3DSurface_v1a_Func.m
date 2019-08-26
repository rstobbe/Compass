%=========================================================
% 
%=========================================================

function [PLOT,err] = Create3DSurface_v1a_Func(PLOT,INPUT)

Status('busy','Plot 3D Surface');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT;
Image = IMG.Im;

%---------------------------------------------
% Get Variables
%---------------------------------------------
Image = abs(Image);
Image = Image/(max(Image(:)));
Image = permute(Image,[3 1 2]);

%---------------------------------------------
% Surface
%---------------------------------------------
figure(100);
[x,y,z,D] = subvolume(Image,[nan,nan,40,nan,nan,nan]);
p1 = patch(isosurface(x,y,z,D,0.5),...
     'FaceColor',[0.5 0.1 0],'EdgeColor','none','ambientstrength',0.2);
isonormals(x,y,z,D,p1);
p2 = patch(isocaps(x,y,z,D,0.5),...                      % show cut-away portion (as generated from subvolume
     'FaceColor','interp','EdgeColor','none','ambientstrength',0.2);          
axis([30 110 30 120 30 90]); 
daspect([1,1,1])
colormap(gray(100))

camlight('right');
lighting gouraud
axis off;
view([45 15]);
campos

%---------------------------------------------
% Movie
%---------------------------------------------
%for n = 1:360
%    rotate(p1,[0 0 1],1);
%    rotate(p2,[0 0 1],1);
%    h = camlight(h,-n,45);
%    drawnow;
%
%    F = getframe(100);
%    [Xt,~] = frame2im(F);
%    [X,map] = rgb2ind(Xt,jet(256));
%    if n == 1
%        imwrite(X,gray(256),'Movie.gif','gif','LoopCount',inf,'DelayTime',0);  
%    else
%        imwrite(X,gray(256),'Movie.gif','gif','WriteMode','append','DelayTime',0);  
%    end
%end

Status('done','');
Status2('done','',2);
Status2('done','',3);
