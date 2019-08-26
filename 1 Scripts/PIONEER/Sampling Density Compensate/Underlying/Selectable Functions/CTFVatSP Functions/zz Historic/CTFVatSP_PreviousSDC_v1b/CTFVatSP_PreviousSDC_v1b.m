%====================================================
% (v1b)
%       - update for RWSUI_BA
%====================================================

function [SCRPTipt,CTFout,err] = CTFVatSP_PreviousSDC_v1b(SCRPTipt,CTF,err)

Status('busy','Return Previous Convolved Output Transfer Function at Samp');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CTFout = struct();
CallingLabel = CTF.Struct.labelstr;

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(CTF,[CallingLabel,'_Data']))
    if isfield(CTF.('SDC_File').Struct,'selectedfile')
        file = CTF.('SDC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SDC_File';
            ErrDisp(err);
            return
        else
            CTF.([CallingLabel,'_Data']).('SDC_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SDC_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CTFout.SDC_File = CTF.([CallingLabel,'_Data']).('SDC_File_Data').path;

%----------------------------------------
% Return
%----------------------------------------
CTFout.DOV = CTF.([CallingLabel,'_Data']).('SDC_File_Data').SDCS.CTF.DOV;
