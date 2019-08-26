%====================================================
% (v2e) 
%       - Start PosBG_v2e
%====================================================

function [SCRPTipt,POSBG,err] = PosBGdouble_v2e(SCRPTipt,POSBGipt)

Status2('busy','Get Info for Postition and Background Field Calculation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = POSBGipt.Struct.labelstr;
if not(isfield(POSBGipt,[CallingLabel,'_Data']))
    if isfield(POSBGipt.('File_NoGrad1a').Struct,'selectedfile')
        file = POSBGipt.('File_NoGrad1a').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_NoGrad1a';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_NoGrad1a_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad1a';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_NoGrad2a').Struct,'selectedfile')
        file = POSBGipt.('File_NoGrad2a').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_NoGrad2a';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_NoGrad2a_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad2a';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLoc1a').Struct,'selectedfile')
        file = POSBGipt.('File_PosLoc1a').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLoc1a';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLoc1a_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc1a';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLoc2a').Struct,'selectedfile')
        file = POSBGipt.('File_PosLoc2a').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLoc2a';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLoc2a_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc2a';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_NoGrad1b').Struct,'selectedfile')
        file = POSBGipt.('File_NoGrad1b').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_NoGrad1b';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_NoGrad1b_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad1b';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_NoGrad2b').Struct,'selectedfile')
        file = POSBGipt.('File_NoGrad2b').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_NoGrad2b';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_NoGrad2b_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad2b';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLoc1b').Struct,'selectedfile')
        file = POSBGipt.('File_PosLoc1b').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLoc1b';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLoc1b_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc1b';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLoc2b').Struct,'selectedfile')
        file = POSBGipt.('File_PosLoc2b').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLoc2b';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLoc2b_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc2b';
        ErrDisp(err);
        return
    end    
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
POSBG.FilePosLoc1a = POSBGipt.([CallingLabel,'_Data']).File_PosLoc1a_Data.path;
POSBG.FilePosLoc2a = POSBGipt.([CallingLabel,'_Data']).File_PosLoc2a_Data.path;
POSBG.FileNoGrad1a = POSBGipt.([CallingLabel,'_Data']).File_NoGrad1a_Data.path;
POSBG.FileNoGrad2a = POSBGipt.([CallingLabel,'_Data']).File_NoGrad2a_Data.path;
POSBG.FilePosLoc1b = POSBGipt.([CallingLabel,'_Data']).File_PosLoc1b_Data.path;
POSBG.FilePosLoc2b = POSBGipt.([CallingLabel,'_Data']).File_PosLoc2b_Data.path;
POSBG.FileNoGrad1b = POSBGipt.([CallingLabel,'_Data']).File_NoGrad1b_Data.path;
POSBG.FileNoGrad2b = POSBGipt.([CallingLabel,'_Data']).File_NoGrad2b_Data.path;
POSBG.plstart = str2double(POSBGipt.PLstart);
POSBG.plstop = str2double(POSBGipt.PLstop);
POSBG.bgstart = str2double(POSBGipt.BGstart);
POSBG.bgstop = str2double(POSBGipt.BGstop);
POSBG.smthwin = str2double(POSBGipt.SmoothWinBG);

Status2('done','',2);
Status2('done','',3);


