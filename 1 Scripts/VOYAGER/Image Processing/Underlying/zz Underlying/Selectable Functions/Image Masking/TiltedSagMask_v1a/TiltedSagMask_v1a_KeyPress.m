%=========================================================
% 
%=========================================================

function TiltedSagMask_v1a_KeyPress(src,event)

global glbMASK

displace = glbMASK.displace;
origsz = glbMASK.sz;
IMSTRCT = glbMASK.IMSTRCT;

%---------------------------------------------
% test
%---------------------------------------------
if strcmp(event.Key,'uparrow');
    displace = displace+1;
elseif strcmp(event.Key,'downarrow');
    displace = displace-1;
elseif strcmp(event.Key,'home');
    displace(2) = displace(2)+1;
elseif strcmp(event.Key,'pageup');
    displace(1) = displace(1)+1;    
elseif strcmp(event.Key,'end');
    displace(2) = displace(2)-1;
elseif strcmp(event.Key,'pagedown');
    displace(1) = displace(1)-1;  
else
    return
end
glbMASK.displace = displace;

%---------------------------------------------
% Cube
%---------------------------------------------
bot = ceil(origsz(3)/2)+displace;
bot = round(linspace(bot(2),bot(1),origsz(1)));
Cube = NaN*ones(origsz);
bot(bot>origsz(3)) = origsz(3);
bot(bot<1) = 1;
for n = 1:origsz(1)
    Cube(n,:,bot(n):end) = 1;
end

%---------------------------------------------
% Orientation
%---------------------------------------------  
Cube = permute(Cube,[3 1 2]);
Cube = flip(Cube,1);

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
