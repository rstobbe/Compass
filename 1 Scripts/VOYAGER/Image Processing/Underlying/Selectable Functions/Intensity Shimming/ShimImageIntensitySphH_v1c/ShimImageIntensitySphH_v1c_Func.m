%===========================================
% 
%===========================================

function [ISHIM,err] = ShimImageIntensitySphH_v1c_Func(ISHIM,INPUT)

Status2('busy','Intensity Shim',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
FIT = ISHIM.FIT;
MASK = ISHIM.MASK;
clear INPUT;

%---------------------------------------------
% Mask
%---------------------------------------------
func = str2func([ISHIM.maskfunc,'_Func']);  
INPUT.Im = IMG.Im;                 
INPUT.ReconPars = IMG.ReconPars;
INPUT.IMDISP = IMG.IMDISP;
INPUT.figno = 100;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[MASK,err] = func(MASK,INPUT);
if isfield(MASK,'SCRPTipt')
    ISHIM.SCRPTipt = MASK.SCRPTipt;
end
if err.flag
    return
end
Mask = MASK.Mask;
clear MASK

%---------------------------------------------
% Scale and Mask
%---------------------------------------------
Im0 = abs(IMG.Im);
Im = Im0;
Im = Im/max(Im(:));
NaNProf = zeros(size(Im));
NaNProf(Im < ISHIM.relminval) = 1;
NaNProf(Im > ISHIM.relmaxval) = 1;
NaNProf = logical(NaNProf);
Im(NaNProf) = NaN;
if not(isempty(Mask))
    Im = Im.*Mask;
end
clear Mask;

%---------------------------------------------
% Display
%---------------------------------------------
sz = size(Im);
mxd = sz(3);
fhand = figure(1000);
ahand = axes('Parent',fhand);
ahand.Position = [0,0,1,1];
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = round(mxd/20); IMSTRCT.stop = mxd; 
IMSTRCT.rows = 5; IMSTRCT.lvl = [ISHIM.relminval-0.01 ISHIM.relmaxval+0.01]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap6'; IMSTRCT.figsize = []; IMSTRCT.lblvals = []; IMSTRCT.ahand = ahand; IMSTRCT.fhand = fhand;
ImageMontage_v2b(Im,IMSTRCT);

cont = questdlg('Continue');
if not(strcmp(cont,'Yes'))
    err.flag = 4;
    return
end

%---------------------------------------------
% Fit Spherical Harmonics
%---------------------------------------------
INPUT.Im = Im;
INPUT.TolX = 0.01;
INPUT.TolFun = 0.01;
func = str2func([ISHIM.fitfunc,'_Func']);
[FIT,err] = func(FIT,INPUT);
if err.flag
    return
end
clear INPUT    

%---------------------------------------------
% Prof
%--------------------------------------------- 
V = FIT.V
Prof = FIT.Prof;
ProfTest = Prof;
ProfTest(NaNProf) = NaN;
ProfTest(ProfTest < ISHIM.relminval) = ISHIM.relminval;
ProfTest(ProfTest > ISHIM.relmaxval) = ISHIM.relmaxval;
Prof(Prof < ISHIM.relminval) = ISHIM.relminval;
Prof(Prof > ISHIM.relmaxval) = ISHIM.relmaxval;

%---------------------------------------------
% Display
%---------------------------------------------
fhand = figure(1001);
ahand = axes('Parent',fhand);
ahand.Position = [0,0,1,1];
IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = round(mxd/20); IMSTRCT.stop = mxd; 
IMSTRCT.rows = 5; IMSTRCT.lvl = [ISHIM.relminval-0.01 ISHIM.relmaxval+0.01]; IMSTRCT.SLab = 0; IMSTRCT.figno = 2001; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap6'; IMSTRCT.figsize = []; IMSTRCT.lblvals = []; IMSTRCT.ahand = ahand; IMSTRCT.fhand = fhand;
ImageMontage_v2b(ProfTest,IMSTRCT);

fhand = figure(1002);
ahand = axes('Parent',fhand);
ahand.Position = [0,0,1,1];
IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = round(mxd/20); IMSTRCT.stop = mxd; 
IMSTRCT.rows = 5; IMSTRCT.lvl = [ISHIM.relminval-0.01 ISHIM.relmaxval+0.01]; IMSTRCT.SLab = 0; IMSTRCT.figno = 2002; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap6'; IMSTRCT.figsize = []; IMSTRCT.lblvals = []; IMSTRCT.ahand = ahand; IMSTRCT.fhand = fhand;
ImageMontage_v2b(Prof,IMSTRCT);

%---------------------------------------------
% Correct
%---------------------------------------------
Im2 = (IMG.Im)./Prof;
Im2 = Im2/max(abs(Im2(:)));

%---------------------------------------------
% Display
%---------------------------------------------
fhand = figure(1003);
ahand = axes('Parent',fhand);
ahand.Position = [0,0,1,1];
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = round(mxd/20); IMSTRCT.stop = mxd; 
IMSTRCT.rows = 5; IMSTRCT.lvl = [ISHIM.relminval-0.01 ISHIM.relmaxval+0.01]; IMSTRCT.SLab = 0; IMSTRCT.figno = 2003; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = []; IMSTRCT.lblvals = []; IMSTRCT.ahand = ahand; IMSTRCT.fhand = fhand;
ImageMontage_v2b(Im2,IMSTRCT);

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',ISHIM.method,'Output'};
ISHIM.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%--------------------------------------------- 
IMG.Im = Im2;
IMG.name = [IMG.name,'_iShim'];
ISHIM.IMG = IMG;
ISHIM.FigureName = 'Intensity Shim';

Status2('done','',2);
Status2('done','',3);

