%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,SCRPTGBL,IMLD,err] = ImCurrentDispLoad_v1a(SCRPTipt,SCRPTGBL,IMLDipt)

Status2('busy','Load Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%--------------------------------------------
% Return
%--------------------------------------------
IMLD.tab = SCRPTGBL.RWSUI.tab;
currentax = gca;
IMLD.axnum = str2double(currentax.Tag);

Status2('done','',2);
Status2('done','',3);
