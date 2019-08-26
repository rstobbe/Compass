%=====================================================
%
%=====================================================

function [GKERN,err] = GrappaKernCube_v1a_Func(GKERN,INPUT)

Status2('busy','Create Grappa Kernel',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
        
%---------------------------------------------
% Return
%---------------------------------------------
Kern = ones(GKERN.wid,GKERN.wid,GKERN.wid);
cen = (GKERN.wid+1)/2;
Kern(cen,cen,cen) = 0;

GKERN.Kern = Kern;
GKERN.cen = cen;

Status2('done','',2);
Status2('done','',3);



