%=========================================================
% (v1b)
%     - really the first version
%=========================================================

function [SCRPTipt,AEXT,err] = ImageArrayExtract_v1b(SCRPTipt,AEXTipt)

Status2('busy','Images Array Extract',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
AEXT.method = AEXTipt.Func;
AEXT.dim4 = AEXTipt.('Dim4');
AEXT.dim5 = AEXTipt.('Dim5');
AEXT.dim6 = AEXTipt.('Dim6');

Status2('done','',2);
Status2('done','',3);

