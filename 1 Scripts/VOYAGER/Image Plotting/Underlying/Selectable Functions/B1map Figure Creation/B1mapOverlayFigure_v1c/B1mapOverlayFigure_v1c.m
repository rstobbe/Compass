%=========================================================
% (v1c)
%       - use underlying
%=========================================================

function [SCRPTipt,SCRPTGBL,MOF,err] = B1mapOverlayFigure_v1c(SCRPTipt,SCRPTGBL,MOFipt)

Status2('busy','B1 Map Overlay Figure',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MOF.method = MOFipt.Func; 
MOF.scale = MOFipt.('Scale');
MOF.type = MOFipt.('Type');
MOF.histogram = MOFipt.('Histogram');

Status2('done','',2);
Status2('done','',3);

