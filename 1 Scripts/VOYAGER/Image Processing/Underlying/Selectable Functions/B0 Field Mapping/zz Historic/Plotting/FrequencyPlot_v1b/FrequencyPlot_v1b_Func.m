%=========================================================
% 
%=========================================================

function [PLOT,err] = FrequencyPlot_v1b_Func(PLOT,INPUT)

Status2('busy','Frequency Plot',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Im = INPUT.Im;
fMap = INPUT.fMap;
orient = INPUT.orient;
inset = INPUT.inset;
dispwid = INPUT.dispwid;
disptype = INPUT.disptype;
figno = INPUT.figno;
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
if strcmp(dispwid,'None') || strcmp(dispwid,'Off')
    PLOT.dispwid = dispwid;
    return
elseif strcmp(dispwid,'Full')
    dispwid = round(max(abs(fMap(:))));
elseif strcmp(dispwid,'Full99')
    test = sort(abs(fMap(:)),'descend');
    ind = find(not(isnan(test)),1,'first');
    total = length(fMap(:))-ind;
    ind2 = ind+round(total*0.01);
    dispwid = round(abs(test(ind2)));
else
    dispwid = str2double(dispwid);
end

%---------------------------------------------
% Inset
%---------------------------------------------
inds = strfind(inset,',');
L = str2double(inset(1:inds(1)-1));
R = str2double(inset(inds(1)+1:inds(2)-1));
T = str2double(inset(inds(2)+1:inds(3)-1)); 
B = str2double(inset(inds(3)+1:inds(4)-1));
I = str2double(inset(inds(4)+1:inds(5)-1)); 
O = str2double(inset(inds(5)+1:length(inset))); 
[x,y,z] = size(Im);
Im = Im(T+1:x-B,L+1:y-R,I+1:z-O);
fMap = fMap(T+1:x-B,L+1:y-R,I+1:z-O);

%---------------------------------------------
% Orientation
%---------------------------------------------
if strcmp(orient,'Axial')
    Im = Im;
    fMap = fMap;
elseif strcmp(orient,'Coronal')
    Im = permute(Im,[3 2 1]);
    fMap = permute(fMap,[3 2 1]);
elseif strcmp(orient,'Sagittal')    
    Im = permute(Im,[3 1 2]);
    fMap = permute(fMap,[3 1 2]);
end
sz = size(fMap);

%---------------------------------------------
% Figsize
%---------------------------------------------
if sz(3) < 50
    figsize = [500 700];
else
    figsize = [650 700];
end

%---------------------------------------------
% Imply Rotation in Neg Sense
%---------------------------------------------
fMap = -fMap;

if strcmp(disptype,'DualDispwMask')
    
    %---------------------------------------------
    % Display ColorBar
    %---------------------------------------------
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [-dispwid dispwid]; IMSTRCT.SLab = 0; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap5'; IMSTRCT.figsize = figsize;
    [h3,ImSz] = ImageMontage_v1a(fMap,IMSTRCT);    
    set(h3,'alphadata',zeros(ImSz));
    
    %---------------------------------------------
    % Display Abs Image
    %---------------------------------------------
    IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [0 max(abs(Im(:)))]; IMSTRCT.SLab = 0; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap5'; IMSTRCT.figsize = figsize;
    [h1,ImSz] = ImageMontageRGB_v1a(Im,IMSTRCT);

    %---------------------------------------------
    % Display fMap Image
    %---------------------------------------------
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [-dispwid dispwid]; IMSTRCT.SLab = 0; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap5'; IMSTRCT.figsize = figsize;
    [h2,ImSz] = ImageMontageRGB_v1a(fMap,IMSTRCT);

    %---------------------------------------------
    % Mask and Scale
    %---------------------------------------------
    if strcmp(PLOT.intensity,'Scaled')
        IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3);  
        [iMask,~] = ImageMontageSetup_v1a(Im/max(abs(Im(:))),IMSTRCT);
        Mask = iMask;
    else
        Mask = ones(ImSz);
    end 
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3);  
    [fMask,~] = ImageMontageSetup_v1a(fMap,IMSTRCT);
    Mask(isnan(fMask)) = 0;
    set(h2,'alphadata',Mask);               
end    

%---------------------------------------------
% Return
%---------------------------------------------
PLOT.dispwid = dispwid;
  
Status2('done','',2);
Status2('done','',3);
