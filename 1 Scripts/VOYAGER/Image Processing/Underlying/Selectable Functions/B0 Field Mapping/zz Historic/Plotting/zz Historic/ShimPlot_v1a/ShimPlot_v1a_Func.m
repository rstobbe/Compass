%=========================================================
% 
%=========================================================

function [PLOT,err] = ShimPlot_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Shimming',2);
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
if strcmp(dispwid,'None')
    return
elseif strcmp(dispwid,'Full')
    dispwid = round(max(abs(fMap(:))));
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


if strcmp(disptype,'DualDispScaledB0wMask')
    
    %---------------------------------------------
    % Display ColorBar
    %---------------------------------------------
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [-dispwid dispwid]; IMSTRCT.SLab = 0; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 700];
    [h3,ImSz] = ImageMontage_v1a(fMap,IMSTRCT);    
    set(h3,'alphadata',zeros(ImSz));
    
    %---------------------------------------------
    % Display Abs Image
    %---------------------------------------------
    IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [0 max(abs(Im(:)))]; IMSTRCT.SLab = 0; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 700];
    [h1,ImSz] = ImageMontageRGB_v1a(Im,IMSTRCT);

    %---------------------------------------------
    % Display fMap Image
    %---------------------------------------------
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [-dispwid dispwid]; IMSTRCT.SLab = 0; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 700];
    [h2,ImSz] = ImageMontageRGB_v1a(fMap,IMSTRCT);

    %---------------------------------------------
    % Mask Setup
    %---------------------------------------------
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3);  
    [iMask,~] = ImageMontageSetup_v1a(Im/max(abs(Im(:))),IMSTRCT);
    Mask = iMask;
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3);  
    [fMask,~] = ImageMontageSetup_v1a(fMap,IMSTRCT);
    Mask(isnan(fMask)) = 0;
    set(h2,'alphadata',Mask);
       
elseif strcmp(disptype,'DualDispB0wMask')

    %---------------------------------------------
    % Display ColorBar
    %---------------------------------------------
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [-dispwid dispwid]; IMSTRCT.SLab = 1; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 700];
    [h3,ImSz] = ImageMontage_v1a(fMap,IMSTRCT);    
    set(h3,'alphadata',zeros(ImSz));
    
    %---------------------------------------------
    % Display Abs Image
    %---------------------------------------------
    IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [0 max(abs(Im(:)))]; IMSTRCT.SLab = 1; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 700];
    [h1,ImSz] = ImageMontageRGB_v1a(Im,IMSTRCT);

    %---------------------------------------------
    % Display fMap Image
    %---------------------------------------------
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [-dispwid dispwid]; IMSTRCT.SLab = 1; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 700];
    [h2,ImSz] = ImageMontageRGB_v1a(fMap,IMSTRCT);

    %---------------------------------------------
    % Mask Setup
    %---------------------------------------------
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3);  
    [Mask0,~] = ImageMontageSetup_v1a(Im/max(abs(Im(:))),IMSTRCT);
    Mask = ones(ImSz);
    Mask(isnan(Mask0)) = 0;
    set(h2,'alphadata',Mask);

elseif strcmp(disptype,'DualDispB0wMask')
    
    %---------------------------------------------
    % Display Abs Image
    %---------------------------------------------
    IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [0 max(abs(Im(:)))]; IMSTRCT.SLab = 1; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 700];
    ImageMontageRGB_v1a(Im,IMSTRCT);

    %---------------------------------------------
    % Display fMap Image
    %---------------------------------------------
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [-dispwid dispwid]; IMSTRCT.SLab = 1; IMSTRCT.figno = figno; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 700];
    [h2,ImSz] = ImageMontageRGB_v1a(fMap,IMSTRCT);

    %---------------------------------------------
    % Mask Setup
    %---------------------------------------------
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3);  
    [Mask0,~] = ImageMontageSetup_v1a(Im/max(abs(Im(:))),IMSTRCT);
    Mask = ones(ImSz);
    Mask(isnan(Mask0)) = 0;
    set(h2,'alphadata',Mask);
        
end    
    
    
Status2('done','',2);
Status2('done','',3);
