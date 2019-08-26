%=====================================================
%
%=====================================================

function [PSTP,err] = PostProc_gemsme3dR2s_v1a_Func(PSTP,INPUT)

Status2('busy','Post Processing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Flip
%---------------------------------------------
Im = INPUT.Im;
Im = single(Im);
PSTP.Im = flipdim(Im,3);

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
PSTP.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);






