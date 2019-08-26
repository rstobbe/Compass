%====================================================
% (v2e) 
%       - Start PosBG_v2e
%====================================================

function [SCRPTipt,POSBG,err] = PosBGcross_v2e(SCRPTipt,POSBGipt)

Status2('busy','Get Info for Postition and Background Field Calculation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = POSBGipt.Struct.labelstr;
if not(isfield(POSBGipt,[CallingLabel,'_Data']))
    if isfield(POSBGipt.('File_NoGrad1A').Struct,'selectedfile')
        file = POSBGipt.('File_NoGrad1A').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_NoGrad1A';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_NoGrad1A_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad1A';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_NoGrad2A').Struct,'selectedfile')
        file = POSBGipt.('File_NoGrad2A').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_NoGrad2A';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_NoGrad2A_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad2A';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLoc1A').Struct,'selectedfile')
        file = POSBGipt.('File_PosLoc1A').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLoc1A';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLoc1A_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc1A';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLoc2A').Struct,'selectedfile')
        file = POSBGipt.('File_PosLoc2A').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLoc2A';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLoc2A_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc2A';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_NoGrad1B').Struct,'selectedfile')
        file = POSBGipt.('File_NoGrad1B').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_NoGrad1B';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_NoGrad1B_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad1B';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_NoGrad2B').Struct,'selectedfile')
        file = POSBGipt.('File_NoGrad2B').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_NoGrad2B';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_NoGrad2B_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad2B';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLoc1B').Struct,'selectedfile')
        file = POSBGipt.('File_PosLoc1B').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLoc1B';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLoc1B_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc1B';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLoc2B').Struct,'selectedfile')
        file = POSBGipt.('File_PosLoc2B').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLoc2B';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLoc2B_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc2B';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLocA1').Struct,'selectedfile')
        file = POSBGipt.('File_PosLocA1').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLocA1';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLocA1_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLocA1';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLocA2').Struct,'selectedfile')
        file = POSBGipt.('File_PosLocA2').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLocA2';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLocA2_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLocA2';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLocB1').Struct,'selectedfile')
        file = POSBGipt.('File_PosLocB1').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLocB1';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLocB1_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLocB1';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLocB2').Struct,'selectedfile')
        file = POSBGipt.('File_PosLocB2').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLocB2';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLocB2_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLocB2';
        ErrDisp(err);
        return
    end     
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
POSBG.FileNoGrad1A = POSBGipt.([CallingLabel,'_Data']).File_NoGrad1A_Data.path;
POSBG.FilePosLoc1A = POSBGipt.([CallingLabel,'_Data']).File_PosLoc1A_Data.path;
POSBG.FileNoGradA1 = POSBG.FileNoGrad1A;
POSBG.FilePosLocA1 = POSBGipt.([CallingLabel,'_Data']).File_PosLocA1_Data.path;

POSBG.FileNoGrad2A = POSBGipt.([CallingLabel,'_Data']).File_NoGrad2A_Data.path;
POSBG.FilePosLoc2A = POSBGipt.([CallingLabel,'_Data']).File_PosLoc2A_Data.path;
POSBG.FileNoGradA2 = POSBG.FileNoGrad2A;
POSBG.FilePosLocA2 = POSBGipt.([CallingLabel,'_Data']).File_PosLocA2_Data.path;

POSBG.FileNoGrad1B = POSBGipt.([CallingLabel,'_Data']).File_NoGrad1B_Data.path;
POSBG.FilePosLoc1B = POSBGipt.([CallingLabel,'_Data']).File_PosLoc1B_Data.path;
POSBG.FileNoGradB1 = POSBG.FileNoGrad1B;
POSBG.FilePosLocB1 = POSBGipt.([CallingLabel,'_Data']).File_PosLocB1_Data.path;

POSBG.FileNoGrad2B = POSBGipt.([CallingLabel,'_Data']).File_NoGrad2B_Data.path;
POSBG.FilePosLoc2B = POSBGipt.([CallingLabel,'_Data']).File_PosLoc2B_Data.path;
POSBG.FileNoGradB2 = POSBG.FileNoGrad2B;
POSBG.FilePosLocB2 = POSBGipt.([CallingLabel,'_Data']).File_PosLocB2_Data.path;

POSBG.plstart = str2double(POSBGipt.PLstart);
POSBG.plstop = str2double(POSBGipt.PLstop);
POSBG.bgstart = str2double(POSBGipt.BGstart);
POSBG.bgstop = str2double(POSBGipt.BGstop);
POSBG.smthwin = str2double(POSBGipt.SmoothWinBG);

Status2('done','',2);
Status2('done','',3);


