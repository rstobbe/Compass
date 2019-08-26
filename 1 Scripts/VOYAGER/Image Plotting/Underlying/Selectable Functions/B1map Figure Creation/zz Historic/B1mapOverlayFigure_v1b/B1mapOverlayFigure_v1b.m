%=========================================================
% (v1b)
%      - at 'type' selection
%=========================================================

function [SCRPTipt,SCRPTGBL,MOF,err] = B1mapOverlayFigure_v1b(SCRPTipt,SCRPTGBL,MOFipt)

Status2('busy','Montage Overlay Figure',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MOF.method = MOFipt.Func; 
MOF.scale = MOFipt.('Scale');
MOF.type = MOFipt.('Type');

Status2('done','',2);
Status2('done','',3);

