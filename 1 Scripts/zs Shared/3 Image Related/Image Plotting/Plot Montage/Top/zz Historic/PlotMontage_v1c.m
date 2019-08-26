%=========================================================
% 
%=========================================================

function [FIGDATA,err] = PlotMontage_v1c(INPUT)

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
Image = INPUT.Image;
clear INPUT

%----------------------------------------------
% Test input
%----------------------------------------------
sz = size(Image);
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
if not(isfield(MSTRCT,'colour'))
    MSTRCT.colour = 'No';
end
if not(isfield(MSTRCT,'type'))
    MSTRCT.type = 'abs';
end
if not(isfield(MSTRCT,'dispwid'))
    MSTRCT.dispwid = [0 max(abs(Image(:)))];
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
    MSTRCT.ncolumns = find(abs(ratio-(15/9)) == min(abs(ratio-(15/9))),1,'last');    
end

%---------------------------------------------
% Test
%---------------------------------------------
ncolumns = MSTRCT.ncolumns;
test = (MSTRCT.start:MSTRCT.step:MSTRCT.stop);
if length(test) < MSTRCT.ncolumns
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
    %fighand = str2double(MSTRCT.figno);
    fighand = figure(MSTRCT.figno);
end 

%---------------------------------------------
% Determine colour
%---------------------------------------------
if strcmp(MSTRCT.colour,'Yes')
    clr = 1;
else
    clr = 0;
end

%---------------------------------------------
% Plot Image
%--------------------------------------------- 
IMSTRCT.type = MSTRCT.type; IMSTRCT.start = MSTRCT.start; IMSTRCT.step = MSTRCT.step; IMSTRCT.stop = MSTRCT.stop; 
IMSTRCT.rows = ncolumns; IMSTRCT.lvl = [MSTRCT.dispwid(1) MSTRCT.dispwid(2)]; IMSTRCT.SLab = slclbl; IMSTRCT.figno = fighand; 
IMSTRCT.docolor = clr; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = figsize;
[handles,ImSz,Img] = ImageMontage_v2a(Image,IMSTRCT);

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
FIGDATA.handles = handles;

