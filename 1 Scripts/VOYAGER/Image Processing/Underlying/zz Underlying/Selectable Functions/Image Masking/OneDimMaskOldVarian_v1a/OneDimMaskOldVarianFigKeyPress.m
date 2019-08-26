%=========================================================
% 
%=========================================================

function OneDimMaskOldVarianFigKeyPress(src,event)

global glbMASK

width = glbMASK.width;
displace = glbMASK.displace;
sz = glbMASK.sz;
direction = glbMASK.direction;
IMSTRCT = glbMASK.IMSTRCT;

%---------------------------------------------
% test
%---------------------------------------------
if strcmp(event.Key,'m')
    if strcmp(direction,'IO')
        displace = displace+1;
    else
        displace = displace-1;
    end
elseif strcmp(event.Key,'i')
    if strcmp(direction,'IO')
        displace = displace-1;
    else
        displace = displace+1;
    end
else
    return
end
glbMASK.displace = displace;

%---------------------------------------------
% Cube
%---------------------------------------------
if strcmp(direction,'IO')
    bot = ceil(sz(3)/2)-floor(width/2)+displace;
    top = ceil(sz(3)/2)+floor(width/2)+displace;
    Cube = NaN*ones(sz);
    Cube(:,:,bot:top) = 1;
elseif strcmp(direction,'LR')
    bot = ceil(sz(2)/2)-floor(width/2)+displace;
    top = ceil(sz(2)/2)+floor(width/2)+displace;
    Cube = NaN*ones(sz);
    Cube(:,bot:top,:) = 1;    
elseif strcmp(direction,'TB')
    bot = ceil(sz(1)/2)-floor(width/2)+displace;
    top = ceil(sz(1)/2)+floor(width/2)+displace;
    Cube = NaN*ones(sz);
    Cube(bot:top,:,:) = 1;        
end

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
[ihand2,ImSz] = ImageMontageRGB_v1b(flip(Cube,1),IMSTRCT);
IMSTRCT.ihand2 = ihand2;

%---------------------------------------------
% Mask and Scale
%---------------------------------------------
IMSTRCT.type = 'real'; IMSTRCT.lvl = [0 1];
[Mask,~] = ImageMontageSetup_v1a(flip(Cube/5,1),IMSTRCT);
Mask(isnan(Mask)) = 0;
set(ihand2,'alphadata',Mask);     

%---------------------------------------------
% Return
%---------------------------------------------
glbMASK.IMSTRCT = IMSTRCT;
