%====================================================
% (v2e) 
%       - update to disregard initial points
%====================================================

function [SCRPTipt,POSBG,err] = PosBG_v2e(SCRPTipt,POSBGipt)

Status2('busy','Get Info for Postition and Background Field Calculation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = POSBGipt.Struct.labelstr;
if not(isfield(POSBGipt,[CallingLabel,'_Data']))
    if isfield(POSBGipt.('File_NoGrad1').Struct,'selectedfile')
        file = POSBGipt.('File_NoGrad1').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_NoGrad1';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_NoGrad1_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad1';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_NoGrad2').Struct,'selectedfile')
        file = POSBGipt.('File_NoGrad2').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_NoGrad2';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_NoGrad2_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad2';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLoc1').Struct,'selectedfile')
        file = POSBGipt.('File_PosLoc1').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLoc1';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLoc1_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc1';
        ErrDisp(err);
        return
    end
    if isfield(POSBGipt.('File_PosLoc2').Struct,'selectedfile')
        file = POSBGipt.('File_PosLoc2').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File_PosLoc2';
            ErrDisp(err);
            return
        else
            POSBGipt.([CallingLabel,'_Data']).('File_PosLoc2_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc2';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
POSBG.FilePosLoc1 = POSBGipt.([CallingLabel,'_Data']).File_PosLoc1_Data.path;
POSBG.FilePosLoc2 = POSBGipt.([CallingLabel,'_Data']).File_PosLoc2_Data.path;
POSBG.FileNoGrad1 = POSBGipt.([CallingLabel,'_Data']).File_NoGrad1_Data.path;
POSBG.FileNoGrad2 = POSBGipt.([CallingLabel,'_Data']).File_NoGrad2_Data.path;
POSBG.plstart = str2double(POSBGipt.PLstart);
POSBG.plstop = str2double(POSBGipt.PLstop);
POSBG.bgstart = str2double(POSBGipt.BGstart);
POSBG.bgstop = str2double(POSBGipt.BGstop);
POSBG.smthwin = str2double(POSBGipt.SmoothWinBG);

Status2('done','',2);
Status2('done','',3);


