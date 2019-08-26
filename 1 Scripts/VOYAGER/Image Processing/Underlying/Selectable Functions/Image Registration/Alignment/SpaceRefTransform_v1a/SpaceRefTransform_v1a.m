%=========================================================
% (v1b)
%    - update 'SpaceRef'
%=========================================================

function [SCRPTipt,ALGN,err] = AlignMultiImagesToAverage_v1b(SCRPTipt,ALGNipt)

Status2('busy','Align Multiple Images To Average',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
ALGN.method = ALGNipt.Func;
ALGN.pass1alignim = str2double(ALGNipt.('Pass1AlignIm'));
ALGN.average = ALGNipt.('Average');

Status2('done','',2);
Status2('done','',3);

