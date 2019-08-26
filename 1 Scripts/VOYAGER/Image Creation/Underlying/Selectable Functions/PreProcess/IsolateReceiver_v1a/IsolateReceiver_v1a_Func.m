%=====================================================
%
%=====================================================

function [PREP,err] = IsolateReceiver_v1a_Func(PREP,INPUT)

Status2('busy','Isolate Receiver',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Isolate Receiver
%---------------------------------------------
PREP.FIDmat = INPUT.FIDmat(:,:,:,:,PREP.rcvrnum);

Status2('done','',2);
Status2('done','',3);






