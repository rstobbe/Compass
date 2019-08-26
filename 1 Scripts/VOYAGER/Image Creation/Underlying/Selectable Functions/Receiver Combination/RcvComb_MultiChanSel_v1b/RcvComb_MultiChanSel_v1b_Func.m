%=====================================================
%
%=====================================================

function [RCOMB,err] = RcvComb_MultiChanSel_v1b_Func(RCOMB,INPUT)

Status2('busy','Combine Receivers',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return
%---------------------------------------------
Im = INPUT.Im;
RCOMB.Im = squeeze(Im(:,:,:,:,RCOMB.channel));

Status2('done','',2);
Status2('done','',3);



