%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,ZF,err] = RemoveZeroFill_ToMatrix_v1a(SCRPTipt,ZFipt)

Status2('busy','Remove ZeroFill',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ZF.method = ZFipt.Func;
zfdims = ZFipt.('Matrix');

inds = strfind(zfdims,',');
ZF.zfdims(1) = str2double(zfdims(1:inds(1)-1));
ZF.zfdims(2) = str2double(zfdims(inds(1)+1:inds(2)-1));
ZF.zfdims(3) = str2double(zfdims(inds(2)+1:end));

Status2('done','',2);
Status2('done','',3);







