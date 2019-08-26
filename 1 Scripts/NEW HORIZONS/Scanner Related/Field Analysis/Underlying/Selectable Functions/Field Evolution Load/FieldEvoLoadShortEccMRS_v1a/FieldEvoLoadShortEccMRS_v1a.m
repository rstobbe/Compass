%====================================================
% (v1a)
%           
%====================================================

function [SCRPTipt,FEVOL,err] = FieldEvoLoadShortEccMRS_v1a(SCRPTipt,FEVOLipt)

Status2('busy','Load Siemens Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = FEVOLipt.Struct.labelstr;
if isfield(FEVOLipt.('File_NoGrad1').Struct,'selectedfile')
    file = FEVOLipt.('File_NoGrad1').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad1';
        ErrDisp(err);
        return
    else
        FEVOLipt.([CallingLabel,'_Data']).('File_NoGrad1_Data').loc = file;
    end
else
    err.flag = 1;
    err.msg = '(Re) Load File_NoGrad1';
    ErrDisp(err);
    return
end
if isfield(FEVOLipt.('File_NoGrad2').Struct,'selectedfile')
    file = FEVOLipt.('File_NoGrad2').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Load File_NoGrad2';
        ErrDisp(err);
        return
    else
        FEVOLipt.([CallingLabel,'_Data']).('File_NoGrad2_Data').loc = file;
    end
else
    err.flag = 1;
    err.msg = '(Re) Load File_NoGrad2';
    ErrDisp(err);
    return
end
if isfield(FEVOLipt.('File_PosLoc1').Struct,'selectedfile')
    file = FEVOLipt.('File_PosLoc1').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc1';
        ErrDisp(err);
        return
    else
        FEVOLipt.([CallingLabel,'_Data']).('File_PosLoc1_Data').loc = file;
    end
else
    err.flag = 1;
    err.msg = '(Re) Load File_PosLoc1';
    ErrDisp(err);
    return
end
if isfield(FEVOLipt.('File_PosLoc2').Struct,'selectedfile')
    file = FEVOLipt.('File_PosLoc2').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Load File_PosLoc2';
        ErrDisp(err);
        return
    else
        FEVOLipt.([CallingLabel,'_Data']).('File_PosLoc2_Data').loc = file;
    end
else
    err.flag = 1;
    err.msg = '(Re) Load File_PosLoc2';
    ErrDisp(err);
    return
end
if isfield(FEVOLipt.('File_Grad1').Struct,'selectedfile')
    file = FEVOLipt.('File_Grad1').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Load File_Grad1';
        ErrDisp(err);
        return
    else
        FEVOLipt.([CallingLabel,'_Data']).('File_Grad1_Data').loc = file;
    end
else
    err.flag = 1;
    err.msg = '(Re) Load File_Grad1';
    ErrDisp(err);
    return
end
if isfield(FEVOLipt.('File_Grad2').Struct,'selectedfile')
    file = FEVOLipt.('File_Grad2').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Load File_Grad2';
        ErrDisp(err);
        return
    else
        FEVOLipt.([CallingLabel,'_Data']).('File_Grad2_Data').loc = file;
    end
else
    err.flag = 1;
    err.msg = '(Re) Load File_Grad2';
    ErrDisp(err);
    return
end      


%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FEVOL.method = FEVOLipt.Func;
FEVOL.File_NoGrad1 = FEVOLipt.([CallingLabel,'_Data']).('File_NoGrad1_Data').loc;
FEVOL.File_NoGrad2 = FEVOLipt.([CallingLabel,'_Data']).('File_NoGrad2_Data').loc;
FEVOL.File_PosLoc1 = FEVOLipt.([CallingLabel,'_Data']).('File_PosLoc1_Data').loc;
FEVOL.File_PosLoc2 = FEVOLipt.([CallingLabel,'_Data']).('File_PosLoc2_Data').loc;
FEVOL.File_Grad1 = FEVOLipt.([CallingLabel,'_Data']).('File_Grad1_Data').loc;
FEVOL.File_Grad2 = FEVOLipt.([CallingLabel,'_Data']).('File_Grad2_Data').loc;

Status2('done','',2);
Status2('done','',3);