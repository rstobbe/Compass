%=====================================================
% (v1d) 
%       - Add Figure save and panel output
%=====================================================
function [SCRPTipt,SCRPTGBL,GTDES,err] = BPGradCompositeTest_v1d(SCRPTipt,SCRPTGBL,GTDESipt)

Status2('busy','Gradient Test Design',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GTDES.method = GTDESipt.Func;
GTDES.numbgtests = str2double(GTDESipt.('NumBGtests'));
GTDES.numpltests = str2double(GTDESipt.('NumPLtests'));
GTDES.numwfmtests = str2double(GTDESipt.('NumWFMtests'));
GTDES.plgrad = str2double(GTDESipt.('PLGrad'));
GTDES.totgraddur0 = str2double(GTDESipt.('TotGradDur'));
GTDES.pregdur0 = str2double(GTDESipt.('PreGDur'));
GTDES.gatmaxdur0 = str2double(GTDESipt.('GatMaxDur'));
GTDES.intergdur0 = str2double(GTDESipt.('InterGDur'));
GTDES.gstepdur = str2double(GTDESipt.('GStepDur'));
GTDES.gsl = str2double(GTDESipt.('Gsl'));
GTDES.gstart = str2double(GTDESipt.('Gstart'));
GTDES.gstep = str2double(GTDESipt.('Gstep'));
GTDES.gstop = str2double(GTDESipt.('Gstop'));
GTDES.dir = GTDESipt.('Dir');

