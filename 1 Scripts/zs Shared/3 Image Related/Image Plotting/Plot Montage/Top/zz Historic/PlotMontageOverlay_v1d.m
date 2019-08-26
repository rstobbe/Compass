%=========================================================
% (v1d)
%       - Default addition
%=========================================================

function [Img,err] = PlotMontageOverlay_v1d(INPUT)

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
if isfield(INPUT,'MSTRCT')
    MSTRCT = INPUT.MSTRCT;
else
    MSTRCT = struct();
end
Im1 = squeeze(INPUT.Image(:,:,:,1));
Im2 = squeeze(INPUT.Image(:,:,:,2));
clear INPUT

%----------------------------------------------
% Test input
%----------------------------------------------
sz = size(Im1);
if not(isfield(MSTRCT,'imsize'))
    MSTRCT.imsize = [];
end
if not(isfield(MSTRCT,'slclbl'))
    MSTRCT.slclbl = 'Yes';
end
if not(isfield(MSTRCT,'ncolumns'))
    MSTRCT.ncolumns = [];
end
if not(isfield(MSTRCT,'start'))
    MSTRCT.start = 1;
end
if not(isfield(MSTRCT,'stop'))
    MSTRCT.stop = sz(3);
end
if not(isfield(MSTRCT,'step'))
    MSTRCT.step = 1;
end
if not(isfield(MSTRCT,'figno'))
    MSTRCT.figno = 'Continue';
end
if not(isfield(MSTRCT,'type1'))
    MSTRCT.type1 = 'abs';
end
if not(isfield(MSTRCT,'type2'))
    MSTRCT.type2 = 'abs';
end
if not(isfield(MSTRCT,'dispwid1'))
    MSTRCT.dispwid1 = [0 max(abs(Im1(:)))];
end
if not(isfield(MSTRCT,'dispwid2'))
    MSTRCT.dispwid2 = [0 max(abs(Im2(:)))];
end
if not(isfield(MSTRCT,'intensity'))
    MSTRCT.intensity = 'Flat50';
end
if not(isfield(MSTRCT,'ImInfo'))
    MSTRCT.ImInfo = '';
end

%---------------------------------------------
% Figsize
%---------------------------------------------
if isempty(MSTRCT.imsize)
    figsize = [];
else
    inds = strfind(MSTRCT.imsize,',');
    hsz = str2double(MSTRCT.imsize(1:inds(1)-1));
    vsz = str2double(MSTRCT.imsize(inds(1)+1:length(MSTRCT.imsize)));
    figsize = [hsz vsz];
end

%---------------------------------------------
% Columns
%---------------------------------------------
if isempty(MSTRCT.ncolumns)
    num = length(MSTRCT.start:MSTRCT.step:MSTRCT.stop);
    for ncolumns = 1:20
        rows = ceil(num/ncolumns);
        horz = ncolumns*sz(2);
        vert = rows*sz(1);
        ratio(ncolumns) = horz/vert;
    end
    MSTRCT.ncolumns = find(ratio<(15/9),1,'last');    
end

%---------------------------------------------
% Test
%---------------------------------------------
ncolumns = MSTRCT.ncolumns;
test = (MSTRCT.start:MSTRCT.step:MSTRCT.stop);
if length(test) < MSTRCT.ncolumns;
    ncolumns = length(test);
end
      
%---------------------------------------------
% Determine Slice Label
%---------------------------------------------
if strcmp(MSTRCT.slclbl,'Yes')
    slclbl = 1;
else
    slclbl = 0;
end

%---------------------------------------------
% Determine Figure
%---------------------------------------------
if strcmp(MSTRCT.figno,'Continue')
    fighand = figure;
else
    fighand = str2double(MSTRCT.figno);
end 

%---------------------------------------------
% General
%---------------------------------------------
IMSTRCT.start = MSTRCT.start; IMSTRCT.step = MSTRCT.step; IMSTRCT.stop = MSTRCT.stop; 
IMSTRCT.rows = ncolumns; IMSTRCT.SLab = slclbl; IMSTRCT.figno = fighand; 
IMSTRCT.ColorMap = 'ColorMap5'; IMSTRCT.figsize = figsize;

%---------------------------------------------
% Display ColorBar
%---------------------------------------------
IMSTRCT.type = MSTRCT.type2; IMSTRCT.lvl = [MSTRCT.dispwid2(1) MSTRCT.dispwid2(2)]; IMSTRCT.docolor = 1; 
[h3,ImSz,Img] = ImageMontage_v2a(Im2,IMSTRCT);    
set(h3.ihand,'alphadata',zeros(ImSz));
IMSTRCT.ahand = h3.ahand;
IMSTRCT.fhand = h3.fhand;

%---------------------------------------------
% Display Base Image
%---------------------------------------------
IMSTRCT.type = MSTRCT.type1; IMSTRCT.lvl = [MSTRCT.dispwid1(1) MSTRCT.dispwid1(2)]; IMSTRCT.docolor = 0;
[h1,ImSz] = ImageMontageRGB_v1b(Im1,IMSTRCT);

%---------------------------------------------
% Display Map Image
%---------------------------------------------
IMSTRCT.type = MSTRCT.type2; IMSTRCT.lvl = [MSTRCT.dispwid2(1) MSTRCT.dispwid2(2)]; IMSTRCT.docolor = 1;
[h2,ImSz] = ImageMontageRGB_v1b(Im2,IMSTRCT);

%---------------------------------------------
% Mask and Scale
%---------------------------------------------
if strcmp(MSTRCT.intensity,'Scaled')
    IMSTRCT.type = MSTRCT.type2;
    [iMask,~] = ImageMontageSetup_v1b(Im1/max(abs(Im1(:))),IMSTRCT);
    Mask = iMask;
elseif strcmp(MSTRCT.intensity,'Flat100')
    Mask = ones(ImSz);
elseif strcmp(MSTRCT.intensity,'Flat75')
    Mask = 0.75*ones(ImSz);    
elseif strcmp(MSTRCT.intensity,'Flat50')
    Mask = 0.5*ones(ImSz);
elseif strcmp(MSTRCT.intensity,'Flat25')
    Mask = 0.25*ones(ImSz);
elseif strcmp(MSTRCT.intensity,'Flat10')
    Mask = 0.20*ones(ImSz);
else
    error()
end 
IMSTRCT.type = MSTRCT.type2; 
[fMask,~] = ImageMontageSetup_v1b(Im2,IMSTRCT);
Mask(isnan(fMask)) = 0;
set(h2,'alphadata',Mask);              

%---------------------------------------------
% Stretch if Needed
%--------------------------------------------- 
if not(isempty(MSTRCT.ImInfo))
    DataAspectRatio = MSTRCT.ImInfo.pixdim(1:2);
    DataAspectRatio = DataAspectRatio/max(DataAspectRatio);
    handles.ahand.DataAspectRatio = [DataAspectRatio 1];
    truesize(handles.fhand,ImSz.*DataAspectRatio);
end

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',3);
