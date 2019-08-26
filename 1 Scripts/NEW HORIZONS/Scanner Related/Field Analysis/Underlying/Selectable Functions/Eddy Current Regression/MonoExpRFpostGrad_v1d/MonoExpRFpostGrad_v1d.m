%====================================================
% (v1a)
%    
%====================================================

function [SCRPTipt,MONO,err] = MonoExpRFpostGrad_v1d(SCRPTipt,MONOipt)

Status2('busy','Regression Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
MONO.method = MONOipt.Func;
MONO.datastart = str2double(MONOipt.('DataStart'));
MONO.datastop = str2double(MONOipt.('DataStop'));
MONO.selfield = MONOipt.('SelectField');
MONO.b0cal = str2double(MONOipt.('B0cal'));
MONO.gcal = str2double(MONOipt.('Gcal'));

temp = MONOipt.('Tc_Estimate');
if strcmp(temp(1),'#')
    MONO.consttc = 1;
    MONO.tcest = str2double(temp(2:end));  
else
    MONO.consttc = 0;
    MONO.tcest = str2double(temp);   
end

Status2('done','',2);
Status2('done','',3);

