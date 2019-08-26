%===========================================
% (v1d)
%      - Zero to Max
%===========================================

function [SCRPTipt,KSMP,err] = kSampGrdCUDAwOffRes2D_v1d(SCRPTipt,KSMPipt)

Status2('busy','Get Sampling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

KSMP = struct();
CallingLabel = KSMPipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(KSMPipt.([CallingLabel,'_Data']),'InvFilt_File_Data'))
    if isfield(KSMPipt.('InvFilt_File').Struct,'selectedfile')
        file = KSMPipt.('InvFilt_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load InvFilt_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Inversion Filter Data',2);
            load(file);
            saveData.path = file;
            KSMPipt.([CallingLabel,'_Data']).('InvFilt_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load InvFilt_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(KSMPipt.([CallingLabel,'_Data']),'Kern_File_Data'))
    if isfield(KSMPipt.('Kern_File').Struct,'selectedfile')
        file = KSMPipt.('Kern_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Kern_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Convolution Kernel Data',2);
            load(file);
            saveData.path = file;
            KSMPipt.([CallingLabel,'_Data']).('Kern_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Kern_File';
        ErrDisp(err);
        return
    end
end


%---------------------------------------------
% Load Panel Input
%---------------------------------------------
KSMP.method = KSMPipt.Func;
KSMP.IFprms = KSMPipt.([CallingLabel,'_Data']).('InvFilt_File_Data').IFprms;
KSMP.KRNprms = KSMPipt.([CallingLabel,'_Data']).('Kern_File_Data').KRNprms;

Status2('done','',2);
Status2('done','',3);

