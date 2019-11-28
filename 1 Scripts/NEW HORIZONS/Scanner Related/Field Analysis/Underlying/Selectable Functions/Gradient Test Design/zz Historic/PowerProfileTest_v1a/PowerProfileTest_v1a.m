%=====================================================
% (v1a) 
%       
%=====================================================
function [SCRPTipt,SCRPTGBL,GTDES,err] = PowerProfileTest_v1a(SCRPTipt,SCRPTGBL,GTDESipt)

Status2('busy','Gradient Test Design',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GTDES.method = GTDESipt.Func;
GTDES.numpctests = str2double(GTDESipt.('NumPCtests'));
GTDES.pcgrad = str2double(GTDESipt.('PCGrad'));
GTDES.gatmaxdur0 = str2double(GTDESipt.('GatMaxDur'));
GTDES.gsl = str2double(GTDESipt.('Gsl'));
GTDES.dir = GTDESipt.('Dir');
GTDES.gstepdur = str2double(GTDESipt.('GStepDur'));
GTDES.totgraddur0 = str2double(GTDESipt.('TotGradDur'));
GTDES.pregdur0 = str2double(GTDESipt.('PreGDur'));
