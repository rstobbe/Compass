%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,PREPRC,err] = PreProc_mpflash3d_v1a(SCRPTipt,PREPRCipt)

Status2('busy','Pre-Process mpflash3d',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = PREPRCipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
PREPRC.method = PREPRCipt.Func;
PREPRC.imdccorfunc = PREPRCipt.('imDCcorfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IMDCipt = PREPRCipt.('imDCcorfunc');
if isfield(PREPRCipt,([CallingLabel,'_Data']))
    if isfield(PREPRCipt.([CallingLabel,'_Data']),'imDCcorfunc_Data')
        IMDCipt.('imDCcorfunc_Data') = PREPRCipt.([CallingLabel,'_Data']).('imDCcorfunc_Data');
    end
end

%------------------------------------------
% Get Image Creation Info
%------------------------------------------
func = str2func(PREPRC.imdccorfunc);           
[SCRPTipt,IMDC,err] = func(SCRPTipt,IMDCipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
PREPRC.IMDC = IMDC;

Status2('done','',2);
Status2('done','',3);



