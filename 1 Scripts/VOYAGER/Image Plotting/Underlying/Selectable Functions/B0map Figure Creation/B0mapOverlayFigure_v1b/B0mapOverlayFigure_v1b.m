%=========================================================
% (v1b)
%       - use underlying
%=========================================================

function [SCRPTipt,SCRPTGBL,MOF,err] = B0mapOverlayFigure_v1b(SCRPTipt,SCRPTGBL,MOFipt)

Status2('busy','B0 Map Overlay Figure',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MOF.method = MOFipt.Func; 
MOF.scale = MOFipt.('Scale');
MOF.histogram = MOFipt.('Histogram');

Status2('done','',2);
Status2('done','',3);

