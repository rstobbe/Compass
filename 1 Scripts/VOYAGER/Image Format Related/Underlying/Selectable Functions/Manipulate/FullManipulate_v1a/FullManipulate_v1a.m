%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,MANIP,err] = FullManipulate_v1a(SCRPTipt,MANIPipt)

Status2('busy','Manipulate Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
MANIP.method = MANIPipt.Func;
MANIP.permute = MANIPipt.('Permute');
MANIP.flipLR = MANIPipt.('FlipLR');
MANIP.flipTB = MANIPipt.('FlipTB');
MANIP.flipIO = MANIPipt.('FlipIO');

Status2('done','',2);
Status2('done','',3);

