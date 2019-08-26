%=========================================================
% 
%=========================================================

function BrainMask1_v1a_FigKeyPress(src,event)

global glbMASK

dims = glbMASK.dims;
disp = glbMASK.disp;
sz = glbMASK.sz;
ImSz = glbMASK.ImSz;
IMSTRCT = glbMASK.IMSTRCT;

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

%---------------------------------------------
% Cube
%---------------------------------------------
bot = ceil(sz/2)-floor(dims/2)+disp;
top = ceil(sz/2)+floor(dims/2)+disp;
if bot(1) < 0 || bot(2) < 0 || bot(3) < 0
    return
end
if top(1) > sz(1) || top(2) > sz(2) || top(3) > sz(3)
    return
end
Cube = NaN*ones(sz);
Cube(bot(1)+1:top(1),bot(2)+1:top(2),bot(3)+1:top(3)) = 1;
glbMASK.disp = disp;

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
    Cube = flip(Cube,1);
elseif strcmp(glbMASK.orient,'Sagittal')    
    Cube = permute(Cube,[3 1 2]);
    Cube = flip(Cube,1);
end

%---------------------------------------------
% Display Mask Image
%---------------------------------------------
delete(IMSTRCT.ihand2);
IMSTRCT.type = 'real'; IMSTRCT.lvl = [0 2]; IMSTRCT.docolor = 1; 
[ihand2,ImSz] = ImageMontageRGB_v1b(Cube,IMSTRCT);
IMSTRCT.ihand2 = ihand2;

%---------------------------------------------
% Mask and Scale
%---------------------------------------------
IMSTRCT.type = 'real'; IMSTRCT.lvl = [0 1];
[Mask,~] = ImageMontageSetup_v1a(Cube/5,IMSTRCT);
Mask(isnan(Mask)) = 0;
set(ihand2,'alphadata',Mask);    

%---------------------------------------------
% Return
%---------------------------------------------
glbMASK.IMSTRCT = IMSTRCT;
