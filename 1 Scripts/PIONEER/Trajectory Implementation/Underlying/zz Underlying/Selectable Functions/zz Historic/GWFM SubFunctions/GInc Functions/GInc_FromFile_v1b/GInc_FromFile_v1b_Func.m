%=====================================================
% 
%=====================================================

function [GINC,err] = GInc_FromFile_v1b_Func(GINC,INPUT)

Status2('busy','Local Eddy-Current Include',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G0;
T = INPUT.qT;
Inc = GINC.Inc;
ATR = GINC.ATR;
clear INPUT

%---------------------------------------------
% G must have 3 dimensions
%---------------------------------------------
if ndims(G) < 3
    [N,M] = size(G);
    G0 = zeros(1,N,M);
    G0(1,:,:) = G;
    G = G0;
end

%---------------------------------------------
% Common
%---------------------------------------------
atrfunc = str2func([GINC.atrfunc,'_Func']);
gstepdur = T(2);        % gstepdur must be constant along gradient

%----------------------------------------------
% Add Transient Response Setup X
%----------------------------------------------
xtc = Inc.xtc;
xmag = Inc.xmag;
if not(isnan(xtc))
    INPUT.G = squeeze(G(:,:,1));
    INPUT.gstepdur = gstepdur;
    INPUT.tc = xtc;
    INPUT.mag = xmag;
    [ATR,err] = atrfunc(ATR,INPUT);
    if err.flag
        return
    end
    xGinc = ATR.Geddyadd;
    xTinc = ATR.Teddy;
else
    xGinc = G(:,:,1);
    xTinc = T;
end

%----------------------------------------------
% Add Transient Response Setup Y
%----------------------------------------------
ytc = Inc.ytc;
ymag = Inc.ymag;
if not(isnan(ytc))
    INPUT.G = squeeze(G(:,:,2));
    INPUT.gstepdur = gstepdur;
    INPUT.tc = ytc;
    INPUT.mag = ymag;
    [ATR,err] = atrfunc(ATR,INPUT);
    if err.flag
        return
    end
    yGinc = ATR.Geddyadd;
    yTinc = ATR.Teddy;
else
    yGinc = G(:,:,2);
    yTinc = T;
end

%----------------------------------------------
% Add Transient Response Setup Z
%----------------------------------------------
ztc = Inc.ztc;
zmag = Inc.zmag;
if not(isnan(ztc))
    INPUT.G = squeeze(G(:,:,3));
    INPUT.gstepdur = gstepdur;
    INPUT.tc = ztc;
    INPUT.mag = zmag;
    [ATR,err] = atrfunc(ATR,INPUT);
    if err.flag
        return
    end
    zGinc = ATR.Geddyadd;
    zTinc = ATR.Teddy;
else
    zGinc = G(:,:,3);
    zTinc = T;
end

maxlen = max([length(xTinc) length(yTinc) length(zTinc)]);
if maxlen == length(xTinc)
    Tinc = xTinc;
elseif maxlen == length(yTinc)
    Tinc = yTinc;
elseif maxlen == length(zTinc)
    Tinc = zTinc;
end
Ginc = zeros(length(G(:,1,1)),maxlen-1,3);
Ginc(:,1:length(xTinc),1) = xGinc;
Ginc(:,1:length(yTinc),2) = yGinc;
Ginc(:,1:length(zTinc),3) = zGinc;

%---------------------------------------------
% Return
%---------------------------------------------
GINC.gcoil = Inc.gcoil;
GINC.Tinc = Tinc;
GINC.Ginc = Ginc;

Status2('done','',3);
