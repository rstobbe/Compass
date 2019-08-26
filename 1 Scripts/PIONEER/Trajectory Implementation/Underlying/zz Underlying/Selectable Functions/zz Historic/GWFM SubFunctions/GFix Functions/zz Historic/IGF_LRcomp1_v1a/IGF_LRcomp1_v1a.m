%=====================================================
% (v1a)
%       - 
%=====================================================

function [SCRPTipt,IGF,err] = IGF_LRcomp1_v1a(SCRPTipt,IGFipt)

Status2('busy','Get IGF Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IGF.method = IGFipt.Func;
IGF.Gaccmx = str2double(IGFipt.('GAccMx'));
IGF.Gvelmx = str2double(IGFipt.('GVelMx'));
IGF.Gcompstpmx = str2double(IGFipt.('GCompStpMx'));

Status2('done','',2);
Status2('done','',3);