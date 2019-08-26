%=====================================================
% (v1a)
%       
%=====================================================

function [SCRPTipt,SPIRIT,err] = ImCon3DSpirit_v1a(SCRPTipt,SPIRITipt)

Status2('busy','Spirit Image Construction',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = SPIRITipt.Struct.labelstr;
if not(isfield(SPIRITipt,[CallingLabel,'_Data']))
    if isfield(SPIRITipt.('Imp_File').Struct,'selectedfile')
        file = SPIRITipt.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SPIRITipt.([CallingLabel,'_Data']).('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
    if isfield(SPIRITipt.('SDC_File').Struct,'selectedfile')
        file = SPIRITipt.('SDC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SDC_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SPIRITipt.([CallingLabel,'_Data']).('SDC_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SDC_File';
        ErrDisp(err);
        return
    end
    if isfield(SPIRITipt.('Kern_File').Struct,'selectedfile')
        file = SPIRITipt.('Kern_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Kern_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SPIRITipt.([CallingLabel,'_Data']).('Kern_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Kern_File';
        ErrDisp(err);
        return
    end       
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIRIT.method = SPIRITipt.Func;
SPIRIT.kernfunc = SPIRITipt.('GrappaKernfunc').Func;
SPIRIT.caldatfunc = SPIRITipt.('GrappaCalDatfunc').Func;
SPIRIT.wcalcfunc = SPIRITipt.('GrappaWCalcfunc').Func;
SPIRIT.acalcfunc = SPIRITipt.('GrappaACalcfunc').Func;
SPIRIT.convfunc = SPIRITipt.('GrappaConvfunc').Func;
SPIRIT.gridfunc = SPIRITipt.('Gridfunc').Func;
SPIRIT.gridrevfunc = SPIRITipt.('GridRevfunc').Func;
SPIRIT.IMP = SPIRITipt.([CallingLabel,'_Data']).('Imp_File_Data').IMP;
SPIRIT.SDCS = SPIRITipt.([CallingLabel,'_Data']).('SDC_File_Data').SDCS;
SPIRIT.KRNprms = SPIRITipt.([CallingLabel,'_Data']).('Kern_File_Data').KRNprms;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = SPIRITipt.Struct.labelstr;
GKERNipt = SPIRITipt.('GrappaKernfunc');
if isfield(SPIRITipt,([CallingLabel,'_Data']))
    if isfield(SPIRITipt.([CallingLabel,'_Data']),'GrappaKernfunc_Data')
        GKERNipt.('GrappaKernfunc_Data') = SPIRITipt.([CallingLabel,'_Data']).('GrappaKernfunc_Data');
    end
end
GCDATipt = SPIRITipt.('GrappaCalDatfunc');
if isfield(SPIRITipt,([CallingLabel,'_Data']))
    if isfield(SPIRITipt.([CallingLabel,'_Data']),'GrappaCalDatfunc_Data')
        GCDATipt.('GrappaCalDatfunc_Data') = SPIRITipt.([CallingLabel,'_Data']).('GrappaCalDatfunc_Data');
    end
end
GWCALCipt = SPIRITipt.('GrappaWCalcfunc');
if isfield(SPIRITipt,([CallingLabel,'_Data']))
    if isfield(SPIRITipt.([CallingLabel,'_Data']),'GrappaWCalcfunc_Data')
        GWCALCipt.('GrappaWCalcfunc_Data') = SPIRITipt.([CallingLabel,'_Data']).('GrappaWCalcfunc_Data');
    end
end
GACALCipt = SPIRITipt.('GrappaACalcfunc');
if isfield(SPIRITipt,([CallingLabel,'_Data']))
    if isfield(SPIRITipt.([CallingLabel,'_Data']),'GrappaACalcfunc_Data')
        GACALCipt.('GrappaACalcfunc_Data') = SPIRITipt.([CallingLabel,'_Data']).('GrappaACalcfunc_Data');
    end
end
GCONVipt = SPIRITipt.('GrappaConvfunc');
if isfield(SPIRITipt,([CallingLabel,'_Data']))
    if isfield(SPIRITipt.([CallingLabel,'_Data']),'GrappaConvfunc_Data')
        GCONVipt.('GrappaConvfunc_Data') = SPIRITipt.([CallingLabel,'_Data']).('GrappaConvfunc_Data');
    end
end
GRDipt = SPIRITipt.('Gridfunc');
if isfield(SPIRITipt,([CallingLabel,'_Data']))
    if isfield(SPIRITipt.([CallingLabel,'_Data']),'Gridfunc_Data')
        GRDipt.('Gridfunc_Data') = SPIRITipt.([CallingLabel,'_Data']).('Gridfunc_Data');
    end
end
GRDRipt = SPIRITipt.('GridRevfunc');
if isfield(SPIRITipt,([CallingLabel,'_Data']))
    if isfield(SPIRITipt.([CallingLabel,'_Data']),'GridRevfunc_Data')
        GRDRipt.('GridRevfunc_Data') = SPIRITipt.([CallingLabel,'_Data']).('GridRevfunc_Data');
    end
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(SPIRIT.kernfunc);           
[SCRPTipt,GKERN,err] = func(SCRPTipt,GKERNipt);
if err.flag
    return
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(SPIRIT.caldatfunc);           
[SCRPTipt,GCDAT,err] = func(SCRPTipt,GCDATipt);
if err.flag
    return
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(SPIRIT.wcalcfunc);           
[SCRPTipt,GWCALC,err] = func(SCRPTipt,GWCALCipt);
if err.flag
    return
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(SPIRIT.acalcfunc);           
[SCRPTipt,GACALC,err] = func(SCRPTipt,GACALCipt);
if err.flag
    return
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(SPIRIT.convfunc);           
[SCRPTipt,GCONV,err] = func(SCRPTipt,GCONVipt);
if err.flag
    return
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(SPIRIT.gridfunc);           
[SCRPTipt,GRD,err] = func(SCRPTipt,GRDipt);
if err.flag
    return
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(SPIRIT.gridrevfunc);           
[SCRPTipt,GRDR,err] = func(SCRPTipt,GRDRipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
SPIRIT.GKERN = GKERN;
SPIRIT.GCDAT = GCDAT;
SPIRIT.GWCALC = GWCALC;
SPIRIT.GACALC = GACALC;
SPIRIT.GCONV = GCONV;
SPIRIT.GRD = GRD;
SPIRIT.GRDR = GRDR;

Status2('done','',2);
Status2('done','',3);

