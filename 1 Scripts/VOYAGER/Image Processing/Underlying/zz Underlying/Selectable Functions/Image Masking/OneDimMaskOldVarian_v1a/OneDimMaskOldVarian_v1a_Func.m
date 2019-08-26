%===========================================
% 
%===========================================

function [MASK,err] = OneDimMask_v1a_Func(MASK,INPUT)

Status2('busy','Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Im = INPUT.Im;
ReconPars = INPUT.ReconPars;
IMDISP = INPUT.IMDISP;
width = MASK.width;
displace = MASK.displace;
direction = MASK.direction;
orient = MASK.orient;
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
clear INPUT

%---------------------------------------------
% Cube
%---------------------------------------------
origsz = size(Im);
if strcmp(direction,'IO')
    width = round(width/ReconPars.ImvoxIO);
    displace = round(displace/ReconPars.ImvoxIO);
    bot = ceil(origsz(3)/2)-floor(width/2)+displace;
    top = ceil(origsz(3)/2)+floor(width/2)+displace;
    Cube = NaN*ones(origsz);
    Cube(:,:,bot:top) = 1;
elseif strcmp(direction,'LR')
    width = round(width/ReconPars.ImvoxLR);
    displace = round(displace/ReconPars.ImvoxLR);
    bot = ceil(origsz(2)/2)-floor(width/2)+displace;
    top = ceil(origsz(2)/2)+floor(width/2)+displace;
    Cube = NaN*ones(origsz);
    Cube(:,bot:top,:) = 1;    
elseif strcmp(direction,'TB')
    width = round(width/ReconPars.ImvoxTB);
    displace = round(displace/ReconPars.ImvoxTB);
    bot = ceil(origsz(1)/2)-floor(width/2)+displace;
    top = ceil(origsz(1)/2)+floor(width/2)+displace;
    Cube = NaN*ones(origsz);
    Cube(bot:top,:,:) = 1;        
end

%---------------------------------------------
% Orientation
%---------------------------------------------
ImInfo = IMDISP.ImInfo;
if strcmp(orient,'Axial')
    Im = Im;
    Cube = Cube;
elseif strcmp(orient,'Coronal')
    Im = permute(Im,[3 2 1]);
    Cube = permute(Cube,[3 2 1]);
    Im = flip(Im,1);
    Cube = flip(Cube,1);
    ImInfo.pixdim = ImInfo.pixdim([3 1 2]);
elseif strcmp(orient,'Sagittal')    
    Im = permute(Im,[3 1 2]);
    Cube = permute(Cube,[3 1 2]);
    Cube = flip(Cube,1);
    Im = flip(Im,1);
    ImInfo.pixdim = ImInfo.pixdim([3 2 1]);
end
IMDISP.ImInfo = ImInfo;

%---------------------------------------------
% Plot
%---------------------------------------------
INPUT.numberslices = 1;
INPUT.usencolumns = 1;
INPUT.Image = cat(4,Cube,Im);
INPUT.MSTRCT.ImInfo = IMDISP.ImInfo;
[MCHRS,err] = DefaultMontageChars_v1a(INPUT);
if err.flag
    return
end
MSTRCT = MCHRS.MSTRCT;

%---------------------------------------------
% Figure Handles;
%---------------------------------------------
figno = 12345;
fhand = figure(figno);
ahand = axes('Parent',fhand);

%---------------------------------------------
% Display Abs Image
%---------------------------------------------
IMSTRCT.type = 'abs'; IMSTRCT.start = MSTRCT.start; IMSTRCT.step = MSTRCT.step; IMSTRCT.stop = MSTRCT.stop; 
IMSTRCT.rows = MSTRCT.ncolumns; IMSTRCT.lvl = [0 max(abs(Im(:)))]; IMSTRCT.SLab = 1; IMSTRCT.ahand = ahand; IMSTRCT.fhand = fhand; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 500];
%--
[ihand1,ImSz] = ImageMontageRGB_v1b(flip(Im,1),IMSTRCT);        % for old Varian recon
%--
IMSTRCT.ihand1 = ihand1;

%---------------------------------------------
% Display Mask Image
%---------------------------------------------
IMSTRCT.SLab = 1;
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
% Ajust Mask Location
%---------------------------------------------
global glbMASK
glbMASK.direction = direction;
glbMASK.width = width;
glbMASK.displace = displace;
glbMASK.sz = origsz;
glbMASK.L = 0;
glbMASK.R = 0;
glbMASK.T = 0;
glbMASK.B = 0;
glbMASK.I = 0;
glbMASK.O = 0;
glbMASK.orient = orient;
glbMASK.IMSTRCT = IMSTRCT;
glbMASK.ImSz = ImSz;
set(figno,'Renderer','OpenGL');
set(figno,'WindowKeyPressFcn',@OneDimMaskOldVarianFigKeyPress);
waitfor(figno);
displace = glbMASK.displace;
clear glbMASK;

%---------------------------------------------
% Return Mask
%---------------------------------------------
if strcmp(direction,'IO')
    bot = ceil(origsz(3)/2)-floor(width/2)+displace;
    top = ceil(origsz(3)/2)+floor(width/2)+displace;
    Cube = NaN*ones(origsz);
    Cube(:,:,bot:top) = 1;
elseif strcmp(direction,'LR')
    bot = ceil(origsz(2)/2)-floor(width/2)+displace;
    top = ceil(origsz(2)/2)+floor(width/2)+displace;
    Cube = NaN*ones(origsz);
    Cube(:,bot:top,:) = 1;    
elseif strcmp(direction,'TB')
    bot = ceil(origsz(1)/2)-floor(width/2)+displace;
    top = ceil(origsz(1)/2)+floor(width/2)+displace;
    Cube = NaN*ones(origsz);
    Cube(bot:top,:,:) = 1;        
end
MASK.Mask = Cube;

%---------------------------------------------
% Update Panel
%---------------------------------------------
inds = strcmp('Displace (mm)',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
if strcmp(direction,'IO')
    SCRPTipt(indnum).entrystr = num2str(displace*ReconPars.ImvoxIO);
elseif strcmp(direction,'LR')
    SCRPTipt(indnum).entrystr = num2str(displace*ReconPars.ImvoxLR);
elseif strcmp(direction,'TB')
    SCRPTipt(indnum).entrystr = num2str(displace*ReconPars.ImvoxTB); 
end
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);
MASK.SCRPTipt = SCRPTipt;

Status2('done','',2);
Status2('done','',3);

