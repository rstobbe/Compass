%=========================================================
% 
%=========================================================

function FigKeyPress(src,event)

global MASK

dims = MASK.dims;
disp = MASK.disp;
sz = MASK.sz;

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
MASK.disp = disp;

%---------------------------------------------
% Cube
%---------------------------------------------
bot = ceil(sz/2)-floor(dims/2)+disp;
top = ceil(sz/2)+floor(dims/2)+disp;
Cube = NaN*ones(sz);
Cube(bot(1):top(1),bot(2):top(2),bot(3):top(3)) = 1;

%---------------------------------------------
% Inset
%---------------------------------------------
Cube = Cube(MASK.A+1:sz(1)-MASK.P,MASK.L+1:sz(2)-MASK.R,MASK.T+1:sz(3)-MASK.B);

%---------------------------------------------
% Orientation
%---------------------------------------------
if strcmp(MASK.orient,'Axial')
    Cube = Cube;
elseif strcmp(MASK.orient,'Coronal')
    Cube = permute(Cube,[3 2 1]);
elseif strcmp(MASK.orient,'Sagittal')    
    Cube = permute(Cube,[3 1 2]);
end

%---------------------------------------------
% Rotate
%---------------------------------------------
if strcmp(MASK.rotation,'90')
    Cube = permute(Cube,[2 1 3]);
elseif strcmp(MASK.rotation,'-90')
    Cube = flipdim(Cube,2);
end

%---------------------------------------------
% Display Mask Image
%---------------------------------------------
IMSTRCT = MASK.IMSTRCT;
IMSTRCT.type = 'real'; IMSTRCT.lvl = [0 2]; IMSTRCT.docolor = 1; 
[h2,ImSz] = ImageMontageRGB_v1a(Cube,IMSTRCT);

%---------------------------------------------
% Mask and Scale
%---------------------------------------------
IMSTRCT.type = 'real'; IMSTRCT.lvl = [0 1];
[Mask,~] = ImageMontageSetup_v1a(Cube/3,IMSTRCT);
Mask(isnan(Mask)) = 0;
set(h2,'alphadata',Mask);    

delete(MASK.h2);
MASK.h2 = h2;

