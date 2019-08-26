%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,PREP,err] = IsolateReceiver_v1a(SCRPTipt,PREPipt)

Status2('busy','Isolate a Receiver',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PREP.method = PREPipt.Func;
PREP.rcvrnum = str2double(PREPipt.('RcvrNumber'));

Status2('done','',2);
Status2('done','',3);









