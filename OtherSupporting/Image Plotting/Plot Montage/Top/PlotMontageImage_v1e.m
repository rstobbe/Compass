%=========================================================
% (v1e)
%       - Use Fig/Axis Handles.
%=========================================================

function [FIGDATA,err] = PlotMontageImage_v1e(INPUT)

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
if not(isfield(MSTRCT,'fhand'))
    MSTRCT.fhand = figure;
end
if not(isfield(MSTRCT,'ahand'))
    MSTRCT.ahand = axes('parent',MSTRCT.fhand);
    MSTRCT.ahand.Position = [0,0,1,1];
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
if not(isfield(MSTRCT,'ncolumns'))
    MSTRCT.ncolumns = [];
end
if not(isfield(MSTRCT,'lblvals'))
    MSTRCT.lblvals = [];
end
if not(isfield(MSTRCT,'scale'))
    MSTRCT.scale = 'auto';
end
if not(isfield(MSTRCT,'useimagecolour'))
    MSTRCT.useimagecolour = 'No';
end
if not(isfield(MSTRCT,'colourmap'))
    MSTRCT.colourmap = 'ColorMap6';
end

%---------------------------------------------
% Columns
%---------------------------------------------
if isempty(MSTRCT.ncolumns)
    Ratio0 = 5/3;
    sz = size(Image);
    num = length(MSTRCT.start:MSTRCT.step:MSTRCT.stop);
    for ncolumns = 1:20
        rows = ceil(num/ncolumns);
        horz = ncolumns*sz(2);
        vert = rows*sz(1);
        ratio(ncolumns) = horz/vert;
    end
    MSTRCT.ncolumns = find(ratio <= Ratio0,1,'last');    
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
% Determine colour
%---------------------------------------------
if strcmp(MSTRCT.colour,'Yes')
    clr = 1;
    MSTRCT.ahand.Units = 'pixels';
    MSTRCT.ahand.Position = [2,2,300,300];
    defAxesPos = [0.01 0.11 1.0 0.95];
    set(0,'DefaultAxesPosition',defAxesPos);
else
    clr = 0;
    MSTRCT.ahand.Position = [0,0,1,1];
end

%---------------------------------------------
% Plot Image
%--------------------------------------------- 
IMSTRCT.type = MSTRCT.type; IMSTRCT.start = MSTRCT.start; IMSTRCT.step = MSTRCT.step; IMSTRCT.stop = MSTRCT.stop; 
IMSTRCT.rows = ncolumns; 
IMSTRCT.SLab = slclbl; IMSTRCT.lblvals = MSTRCT.lblvals; IMSTRCT.fhand = MSTRCT.fhand; IMSTRCT.ahand = MSTRCT.ahand; 
IMSTRCT.docolor = clr; IMSTRCT.ColorMap = MSTRCT.colourmap; IMSTRCT.figsize = MSTRCT.imsize;
if strcmp(MSTRCT.useimagecolour,'No')
    IMSTRCT.lvl = [MSTRCT.dispwid(1) MSTRCT.dispwid(2)]; 
    [handles,ImSz,Img] = ImageMontage_v2b(Image,IMSTRCT);
else
    [handles,ImSz,Img] = ColouredImageMontage_v2b(Image,IMSTRCT);
end
    
% - fix up
% if ImSz(1) < 200
%     ImSz(1) = 200;
% end
% if ImSz(2) < 200
%     ImSz(2) = 200;
% end

%---------------------------------------------
% Stretch if Needed
%--------------------------------------------- 
DataAspectRatio = MSTRCT.ImInfo.pixdim(1:2);
DataAspectRatio = DataAspectRatio/max(DataAspectRatio);
DataAspectRatio = round(DataAspectRatio*200)/200;             % get rid of potential tiny differences in Siemens images 
handles.ahand.DataAspectRatio = [DataAspectRatio 1];
figdims = DataAspectRatio.*ImSz;
if strcmp(MSTRCT.scale,'auto')
    scale1 = ceil(1000/figdims(1));
    scale2 = ceil(600/figdims(2));
    scale = min([scale1 scale2]);
else
    scale = str2double(MSTRCT.scale);
end   
figdims = figdims*scale;
if clr
    figdims(2) =  figdims(2)*1.3;
    truesizeRWS(handles.fhand,figdims);
else
    truesize(handles.fhand,figdims);
end

defAxesPos = [0.13 0.13 0.75 0.70];
set(0,'DefaultAxesPosition',defAxesPos);

%---------------------------------------------
% Return
%--------------------------------------------- 
FIGDATA.handles = handles;
FIGDATA.Img = Img;

