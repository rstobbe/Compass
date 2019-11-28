%=====================================================
% (v1a) 
%       
%=====================================================
function [SCRPTipt,SCRPTGBL,GTDES,err] = PowerProfileTest_v1b(SCRPTipt,SCRPTGBL,GTDESipt)

Status2('busy','Gradient Test Design',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GTDES.method = GTDESipt.Func;
GTDES.numtests = str2double(GTDESipt.('NumTests'));
GTDES.readgrad = str2double(GTDESipt.('ReadGrad'));
GTDES.readdur0 = str2double(GTDESipt.('ReadDur'));
GTDES.pregdur0 = str2double(GTDESipt.('PreDur'));
GTDES.rewinddur0 = str2double(GTDESipt.('RewindDur'));
GTDES.gstepdur = str2double(GTDESipt.('GStepDur'));
GTDES.gsl = str2double(GTDESipt.('Gsl'));
GTDES.dir = GTDESipt.('Dir');


