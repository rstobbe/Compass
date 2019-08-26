%=====================================================
% 
%=====================================================

function [GCOMP,err] = GComp_FromFile_v1c_Func(GCOMP,INPUT)

Status2('busy','Local Eddy-Current Compensation',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G0;
T = INPUT.qT;
Comp = GCOMP.Comp;
CTR = GCOMP.CTR;
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
% Find graddel
%---------------------------------------------
gvec = 'xyz';
gdelarray = [Comp.xgraddel Comp.ygraddel Comp.zgraddel];
[~,inds] = sort(gdelarray);
gorder = flipdim(gvec(inds),2);
if strcmp(gorder,'xyz')
    xgshift = 0;
    ygshift = Comp.xgraddel - Comp.ygraddel;
    zgshift = Comp.ygraddel - Comp.zgraddel;
    graddel = Comp.zgraddel;
elseif strcmp(gorder,'yxz')
    ygshift = 0;
    xgshift = Comp.ygraddel - Comp.xgraddel;
    zgshift = Comp.xgraddel - Comp.zgraddel;
    graddel = Comp.zgraddel;
elseif strcmp(gorder,'zxy')
    zgshift = 0;
    xgshift = Comp.zgraddel - Comp.xgraddel;
    ygshift = Comp.xgraddel - Comp.ygraddel;
    graddel = Comp.ygraddel;
elseif strcmp(gorder,'xzy')
    xgshift = 0;
    zgshift = Comp.xgraddel - Comp.zgraddel;
    ygshift = Comp.zgraddel - Comp.ygraddel;
    graddel = Comp.ygraddel;
elseif strcmp(gorder,'zyx')
    zgshift = 0;
    ygshift = Comp.zgraddel - Comp.ygraddel;
    xgshift = Comp.ygraddel - Comp.xgraddel;
    graddel = Comp.xgraddel;
elseif strcmp(gorder,'yzx')
    ygshift = 0;
    zgshift = Comp.ygraddel - Comp.zgraddel;
    xgshift = Comp.zgraddel - Comp.xgraddel;
    graddel = Comp.xgraddel;
end
    
%---------------------------------------------
% Common
%---------------------------------------------
ctrfunc = str2func([GCOMP.ctrfunc,'_Func']);
gstepdur = T(2);        % gstepdur must be constant along gradient

%----------------------------------------------
% Comp Transient Response Setup X
%----------------------------------------------
xtc = Comp.xtc;
xmag = Comp.xmag;
if not(isnan(xtc))
    INPUT.G = squeeze(G(:,:,1));
    INPUT.gstepdur = gstepdur;
    INPUT.tc = xtc;
    INPUT.mag = xmag;
    INPUT.startfromzero = 'Yes';
    [CTR,err] = ctrfunc(CTR,INPUT);
    if err.flag
        return
    end
    xGcomp = CTR.Geddyadd;
    xTcomp = CTR.Teddy;
else
    xGcomp = G(:,:,1);
    xTcomp = T;
end
xGcomp = xGcomp + Comp.xgradoffset;

%----------------------------------------------
% Comp Transient Response Setup Y
%----------------------------------------------
ytc = Comp.ytc;
ymag = Comp.ymag;
if not(isnan(ytc))
    INPUT.G = squeeze(G(:,:,2));
    INPUT.gstepdur = gstepdur;
    INPUT.tc = ytc;
    INPUT.mag = ymag;
    [CTR,err] = ctrfunc(CTR,INPUT);
    if err.flag
        return
    end
    yGcomp = CTR.Geddyadd;
    yTcomp = CTR.Teddy;
else
    yGcomp = G(:,:,2);
    yTcomp = T;
end
yGcomp = yGcomp + Comp.ygradoffset;

%----------------------------------------------
% Comp Transient Response Setup Z
%----------------------------------------------
ztc = Comp.ztc;
zmag = Comp.zmag;
if not(isnan(ztc))
    INPUT.G = squeeze(G(:,:,3));
    INPUT.gstepdur = gstepdur;
    INPUT.tc = ztc;
    INPUT.mag = zmag;
    [CTR,err] = ctrfunc(CTR,INPUT);
    if err.flag
        return
    end
    zGcomp = CTR.Geddyadd;
    zTcomp = CTR.Teddy;
else
    zGcomp = G(:,:,3);
    zTcomp = T;
end
zGcomp = zGcomp + Comp.zgradoffset;

%----------------------------------------------
% Finish
%----------------------------------------------
maxlen = max([length(xTcomp) length(yTcomp) length(zTcomp)]);
if maxlen == length(xTcomp)
    Tcomp = xTcomp;
elseif maxlen == length(yTcomp)
    Tcomp = yTcomp;
elseif maxlen == length(zTcomp)
    Tcomp = zTcomp;
end
Gcomp = zeros(length(G(:,1,1)),maxlen-1,3);
Gcomp(:,1:length(xTcomp)-1,1) = xGcomp(:,1:length(xTcomp)-1);
Gcomp(:,1:length(yTcomp)-1,2) = yGcomp(:,1:length(yTcomp)-1);
Gcomp(:,1:length(zTcomp)-1,3) = zGcomp(:,1:length(zTcomp)-1);

%---------------------------------------------
% Return
%---------------------------------------------
GCOMP.graddel = graddel;
GCOMP.gcoil = Comp.gcoil;
GCOMP.Tcomp = Tcomp;
GCOMP.Gcomp = Gcomp;
GCOMP.xgshift = xgshift;
GCOMP.ygshift = ygshift;
GCOMP.zgshift = zgshift;
GCOMP.gorder = gorder;

Status2('done','',3);
