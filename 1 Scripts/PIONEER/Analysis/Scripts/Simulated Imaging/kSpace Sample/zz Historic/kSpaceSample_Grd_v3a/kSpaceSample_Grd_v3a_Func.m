%===========================================
%
%===========================================

function [SAMP,err] = kSpaceSample_Grd_v3a_Func(INPUT,SAMP)

Status('busy','Sample k-Space');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
OB = INPUT.OB;
IMP = INPUT.IMP;
IFprms = INPUT.IFprms;
GRDR = INPUT.GRDR;
clear INPUT;

%----------------------------------------------------
% Build Object
%----------------------------------------------------
func = str2func([SAMP.ObjectFunc,'_Func']);  
INPUT = struct();
[OB,err] = func(OB,INPUT);
if err.flag
    return
end
clear INPUT;
Ob = OB.Ob;
ObFoV = OB.ObFoV;
obsz = OB.ObMatSz;

%----------------------------------------------------
% Plot Object
%----------------------------------------------------
plotob = 0;
if plotob == 1
    sz = size(Ob);
    minval = 0;
    maxval = 1;
    rows = floor(sqrt(sz(3))); 
    %IMSTRCT.type = 'abs'; IMSTRCT.start = 84; IMSTRCT.step = 1; IMSTRCT.stop = 84; 
    IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = rows; IMSTRCT.lvl = [minval maxval]; IMSTRCT.SLab = 1; IMSTRCT.figno = 2; 
    IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; 
    IMSTRCT.figsize = [1000 1000];
    AxialMontage_v2a(Ob,IMSTRCT);  
end

%---------------------------------------------
% ZeroFill Object
%---------------------------------------------
zf = IFprms.ZF;
zfOb = zeros(zf,zf,zf);
bot = zf/2-obsz/2+1;
top = zf/2+obsz/2;
zfOb(bot:top,bot:top,bot:top) = Ob;
zfOb = zfOb./IFprms.V;

%---------------------------------------------
% FT (fix...
%---------------------------------------------
zfkMat = zeros(zf+1,zf+1,zf+1);
zfkMat(1:zf,1:zf,1:zf) = fftshift(fftn(ifftshift(zfOb)));
%figure; (plot(abs(zfkMat(:,(zf+2)/2,(zf+2)/2))));

%---------------------------------------------
% Sample
%---------------------------------------------
func = str2func([SAMP.GridRevFunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.kDat = zfkMat;
INPUT.StatLev = 2;
GRDR.type = 'complex';
[GRDR,err] = func(GRDR,INPUT);
if err.flag
    return
end
clear INPUT;
SampDat = GRDR.SampDat;

%---------------------------------------------
% Panel
%---------------------------------------------
Panel(1,:) = {'ImpFile',SAMP.ImpFile,'Output'};
Panel(2,:) = {'ObFunc',SAMP.ObjectFunc,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SAMP.PanelOutput = PanelOutput;
SAMP.PanelOutput = [SAMP.PanelOutput;OB.PanelOutput];

%---------------------------------------------
% Return
%---------------------------------------------
SAMP.SampDat = SampDat;
SAMP.ObFoV = ObFoV;
SAMP.OB = OB;




