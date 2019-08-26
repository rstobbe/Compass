%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,MASK,err] = CubeMask_v1a(SCRPTipt,MASKipt)

Status2('busy','Image Masking',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
MASK.method = MASKipt.Func;
MASK.dims = MASKipt.('Dims');
MASK.disp = MASKipt.('Disp');
MASK.orient = MASKipt.('Orientation');
MASK.inset = MASKipt.('Inset');

Status2('done','',2);
Status2('done','',3);

