%=====================================================
% 
%=====================================================

function [GCOMP,err] = GComp_DelOnly_v1a_Func(GCOMP,INPUT)

Status2('busy','Local Eddy-Current Compensation',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G0;
T = INPUT.qT;
Comp = GCOMP.Comp;
clear INPUT

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
elseif strcmp(gorder,'zxy')
    zgshift = 0;
    xgshift = Comp.zgraddel - Comp.xgraddel;
    ygshift = Comp.xgraddel - Comp.ygraddel;
    graddel = Comp.ygraddel;
end
    
%---------------------------------------------
% Return
%---------------------------------------------
GCOMP.graddel = graddel;
GCOMP.gcoil = Comp.gcoil;
GCOMP.Tcomp = T;
GCOMP.Gcomp = G;
GCOMP.xgshift = xgshift;
GCOMP.ygshift = ygshift;
GCOMP.zgshift = zgshift;
GCOMP.gorder = gorder;

Status2('done','',3);
