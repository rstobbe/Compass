%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,TORD,err] = TrajOrder_SubSetAverage_v1a(SCRPTipt,TORDipt)

Status2('busy','Order Trajectories',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TORD.method = TORDipt.Func;
TORD.subsetsize = str2double(TORDipt.('SubSetSize'));
TORD.averages = str2double(TORDipt.('Averages'));

Status2('done','',2);
Status2('done','',3);









