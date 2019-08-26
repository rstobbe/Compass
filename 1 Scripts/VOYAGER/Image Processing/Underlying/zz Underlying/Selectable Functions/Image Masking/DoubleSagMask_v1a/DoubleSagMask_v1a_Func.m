%===========================================
% 
%===========================================

function [MASK,err] = DoubleSagMask_v1a_Func(MASK,INPUT)

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
displace = MASK.displace;
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
clear INPUT

%---------------------------------------------
% Cube
%---------------------------------------------
origsz = size(Im);
displace = round(displace/ReconPars.ImvoxIO);
bot = ceil(origsz(3)/2)+displace;
Cube = NaN*ones(origsz);
bot(bot>origsz(3)) = origsz(3);
bot(bot<1) = 1;
Cube(:,:,bot(2):bot(1)) = 1;

%---------------------------------------------
% Orientation
%---------------------------------------------
ImInfo = IMDISP.ImInfo;
Im = permute(Im,[3 1 2]);
Cube = permute(Cube,[3 1 2]);
Cube = flip(Cube,1);
Im = flip(Im,1);
ImInfo.pixdim = ImInfo.pixdim([3 2 1]);
IMDISP.ImInfo = ImInfo;

%---------------------------------------------
% Plot
%---------------------------------------------
INPUT.numberslices = 1;
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
sz = size(Im);
IMSTRCT.type = 'abs'; IMSTRCT.start = MSTRCT.start; IMSTRCT.step = MSTRCT.step; IMSTRCT.stop = MSTRCT.stop; 
IMSTRCT.rows = MSTRCT.ncolumns; IMSTRCT.lvl = [0 max(abs(Im(:)))]; IMSTRCT.SLab = 1; IMSTRCT.ahand = ahand; IMSTRCT.fhand = fhand; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [500 500];
[ihand1,ImSz] = ImageMontageRGB_v1b(Im,IMSTRCT);
IMSTRCT.ihand1 = ihand1;

%---------------------------------------------
% Display Mask Image
%---------------------------------------------
IMSTRCT.SLab = 1;
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
% Ajust Mask Location
%---------------------------------------------
global glbMASK
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
set(figno,'WindowKeyPressFcn',@DoubleSagMask_v1a_KeyPress);
waitfor(figno);
displace = glbMASK.displace;
clear glbMASK;

%---------------------------------------------
% Return Mask
%---------------------------------------------
bot = ceil(origsz(3)/2)+displace;
Cube = NaN*ones(origsz);
bot(bot>origsz(3)) = origsz(3);
bot(bot<1) = 1;
Cube(:,:,bot(2):bot(1)) = 1;
MASK.Mask = Cube;

%---------------------------------------------
% Update Panel
%---------------------------------------------
inds = strcmp('DispSup (mm)',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = num2str(displace(1)*ReconPars.ImvoxIO);
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

inds = strcmp('DispInf (mm)',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = num2str(displace(2)*ReconPars.ImvoxIO);
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

MASK.SCRPTipt = SCRPTipt;

Status2('done','',2);
Status2('done','',3);

