%=========================================================
% 
%=========================================================

function CubeMaskFigKeyPress(src,event)

global glbMASK

dims = glbMASK.dims;
disp = glbMASK.disp;
sz = glbMASK.sz;

%---------------------------------------------
% test
%---------------------------------------------
if strcmp(event.Key,'i');
    disp(1) = disp(1)-1;
elseif strcmp(event.Key,'m');
    disp(1) = disp(1)+1;
elseif strcmp(event.Key,'j');
    disp(2) = disp(2)-1;
elseif strcmp(event.Key,'k');
    disp(2) = disp(2)+1;
elseif strcmp(event.Key,'u');
    disp(3) = disp(3)-1;
elseif strcmp(event.Key,'o');
    disp(3) = disp(3)+1;
else
    return
end
glbMASK.disp = disp;

%---------------------------------------------
% Cube
%---------------------------------------------
bot = ceil(sz/2)-floor(dims/2)+disp;
top = ceil(sz/2)+floor(dims/2)+disp;
Cube = NaN*ones(sz);
%Cube(bot(1):top(1),bot(2):top(2),bot(3):top(3)) = 1;
Cube(bot(1)+1:top(1),bot(2)+1:top(2),bot(3)+1:top(3)) = 1;

%---------------------------------------------
% Inset
%---------------------------------------------
Cube = Cube(glbMASK.T+1:sz(1)-glbMASK.B,glbMASK.L+1:sz(2)-glbMASK.R,glbMASK.I+1:sz(3)-glbMASK.O);

%---------------------------------------------
% Orientation
%---------------------------------------------
if strcmp(glbMASK.orient,'Axial')
    Cube = Cube;
elseif strcmp(glbMASK.orient,'Coronal')
    Cube = permute(Cube,[3 2 1]);
elseif strcmp(glbMASK.orient,'Sagittal')    
    Cube = permute(Cube,[3 1 2]);
end

%---------------------------------------------
% Display Mask Image
%---------------------------------------------
IMSTRCT = glbMASK.IMSTRCT;
IMSTRCT.type = 'real'; IMSTRCT.lvl = [0 2]; IMSTRCT.docolor = 1; 
[h2,ImSz] = ImageMontageRGB_v1b(Cube,IMSTRCT);

%---------------------------------------------
% Mask and Scale
%---------------------------------------------
IMSTRCT.type = 'real'; IMSTRCT.lvl = [0 1];
[Mask,~] = ImageMontageSetup_v1a(Cube/3,IMSTRCT);
Mask(isnan(Mask)) = 0;
set(h2,'alphadata',Mask);    

delete(glbMASK.h2);
glbMASK.h2 = h2;

