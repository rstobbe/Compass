%===========================================
% 
%===========================================

function [MASK,err] = CubeMask_v1b_Func(MASK,INPUT)

Status2('busy','Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Im = INPUT.Im;
ReconPars = INPUT.ReconPars;
figno = INPUT.figno;
Sdims = MASK.dims;
Sdisp = MASK.disp;
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
orient = MASK.orient;
inset = MASK.inset;
clear INPUT

%----------------------------------------------
% Test
%----------------------------------------------
if isempty(ReconPars)
    ReconPars.ImvoxLR = 1;
    ReconPars.ImvoxTB = 1;
    ReconPars.ImvoxIO = 1; 
end

%---------------------------------------------
% Cube
%---------------------------------------------
inds = strfind(Sdims,',');
dims(1) = round(str2double(Sdims(1:inds(1)-1))/ReconPars.ImvoxLR);
dims(2) = round(str2double(Sdims(inds(1)+1:inds(2)-1))/ReconPars.ImvoxTB);
dims(3) = round(str2double(Sdims(inds(2)+1:end))/ReconPars.ImvoxIO); 
inds = strfind(Sdisp,',');
disp(1) = round(str2double(Sdisp(1:inds(1)-1))/ReconPars.ImvoxLR);
disp(2) = round(str2double(Sdisp(inds(1)+1:inds(2)-1))/ReconPars.ImvoxTB);
disp(3) = round(str2double(Sdisp(inds(2)+1:end))/ReconPars.ImvoxIO);  
origsz = size(Im);
bot = ceil(origsz/2)-floor(dims/2)+disp;
top = ceil(origsz/2)+floor(dims/2)+disp;
Cube = NaN*ones(origsz);
%Cube(bot(1):top(1),bot(2):top(2),bot(3):top(3)) = 1;
Cube(bot(1)+1:top(1),bot(2)+1:top(2),bot(3)+1:top(3)) = 1;

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
Cube = Cube(T+1:x-B,L+1:y-R,I+1:z-O);

%---------------------------------------------
% Orientation
%---------------------------------------------
if strcmp(orient,'Axial')
    Im = Im;
    Cube = Cube;
elseif strcmp(orient,'Coronal')
    Im = permute(Im,[3 2 1]);
    Cube = permute(Cube,[3 2 1]);
elseif strcmp(orient,'Sagittal')    
    Im = permute(Im,[3 1 2]);
    Cube = permute(Cube,[3 1 2]);
end

%---------------------------------------------
% Figure Handles;
%---------------------------------------------
fhand = figure(figno);
ahand = axes('Parent',fhand);

%---------------------------------------------
% Display Abs Image
%---------------------------------------------
sz = size(Im);
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [0 max(abs(Im(:)))]; IMSTRCT.SLab = 0; IMSTRCT.ahand = ahand; IMSTRCT.fhand = fhand; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
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
glbMASK.dims = dims;
glbMASK.disp = disp;
glbMASK.sz = origsz;
glbMASK.L = L;
glbMASK.R = R;
glbMASK.T = T;
glbMASK.B = B;
glbMASK.I = I;
glbMASK.O = O;
glbMASK.orient = orient;
glbMASK.IMSTRCT = IMSTRCT;
glbMASK.ImSz = ImSz;
set(figno,'Renderer','OpenGL');
set(figno,'WindowKeyPressFcn',@CubeMask_v1b_FigKeyPress);
waitfor(figno);
disp = glbMASK.disp;
clear glbMASK;

%---------------------------------------------
% Return Mask
%---------------------------------------------
bot = ceil(origsz/2)-floor(dims/2)+disp;
top = ceil(origsz/2)+floor(dims/2)+disp;
Cube = NaN*ones(origsz);
Cube(bot(1)+1:top(1),bot(2)+1:top(2),bot(3)+1:top(3)) = 1;
MASK.Mask = Cube;

%---------------------------------------------
% Update Panel
%---------------------------------------------
inds = strcmp('Disp (TB,LR,IO)',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = [num2str(disp(1)*ReconPars.ImvoxLR),',',num2str(disp(2)*ReconPars.ImvoxTB),',',num2str(disp(3)*ReconPars.ImvoxIO)];
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);
MASK.SCRPTipt = SCRPTipt;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'',MASK.method,'Output'};
% Panel(2,:) = {'Direction',direction,'Output'};
% Panel(3,:) = {'Width (mm)',MASK.width,'Output'};
% Panel(4,:) = {'Displace (mm)',MASK.displace,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
MASK.PanelOutput = PanelOutput;


Status2('done','',2);
Status2('done','',3);

