%====================================================
% (v1c)
%       - update for function splitting
%====================================================

function [SCRPTipt,CTFV,err] = CTFVatSP_PreviousSDC_v1c(SCRPTipt,CTFVipt)

Status2('busy','Return Previous Convolved Output Transfer Function at Samp',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = CTFVipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(CTFVipt,[CallingLabel,'_Data']))
    if isfield(CTFVipt.('SDC_File').Struct,'selectedfile')
        file = CTFVipt.('SDC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SDC_File';
            ErrDisp(err);
            return
        else
            CTFVipt.([CallingLabel,'_Data']).('SDC_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SDC_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return
%---------------------------------------------
SDCS = CTFVipt.([CallingLabel,'_Data']).('SDC_File_Data').SDCS;
CTFV = CTFVipt.([CallingLabel,'_Data']).('SDC_File_Data').SDCS.CTFV;
CTFV.SDC_File = CTFVipt.([CallingLabel,'_Data']).('SDC_File_Data').path;

if isfield(SDCS,'DOV')
    CTFV.DOV = SDCS.DOV;
end
    
Status2('done','',2);
Status2('done','',3);
