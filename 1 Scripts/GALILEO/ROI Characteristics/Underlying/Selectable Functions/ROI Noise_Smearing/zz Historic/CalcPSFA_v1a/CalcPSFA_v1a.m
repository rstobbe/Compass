%=====================================================
% (v1a) 
%        
%=====================================================

function [SCRPTipt,PSFACALC,err] = CalcPSFA_v1a(SCRPTipt,PSFACALCipt)

Status2('busy','PSFA Calculate',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

PSFACALC = struct();
CallingLabel = PSFACALCipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
LoadAll = 0;
if not(isfield(PSFACALCipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
if LoadAll == 1 || not(isfield(PSFACALCipt.([CallingLabel,'_Data']),'Imp_File_Data'))
    if isfield(PSFACALCipt.('Imp_File').Struct,'selectedfile')
        file = PSFACALCipt.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Implementation Data',2);
            load(file);
            saveData.path = file;
            PSFACALCipt.([CallingLabel,'_Data']).('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PSFACALC.method = PSFACALCipt.Func;
PSFACALC.tfbuildfunc = PSFACALCipt.('TFBuildfunc').Func;
PSFACALC.susbuildfunc = PSFACALCipt.('SUSBuildfunc').Func; 
PSFACALC.IMP = PSFACALCipt.([CallingLabel,'_Data']).('Imp_File_Data').IMP;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
TFBipt = PSFACALCipt.('TFBuildfunc');
if isfield(PSFACALC,([CallingLabel,'_Data']))
    if isfield(PSFACALCipt.PSFACALCfunc_Data,('TFBuildfunc_Data'))
        TFBipt.TFBuildfunc_Data = PSFACALCipt.PSFACALCfunc_Data.TFBuildfunc_Data;
    end
end
SUSipt = PSFACALCipt.('SUSBuildfunc');
if isfield(PSFACALC,([CallingLabel,'_Data']))
    if isfield(PSFACALCipt.PSFACALCfunc_Data,('SUSBuildfunc_Data'))
        SUSipt.SUSBuildfunc_Data = PSFACALCipt.PSFACALCfunc_Data.SUSBuildfunc_Data;
    end
end

%------------------------------------------
% Function Info
%------------------------------------------
func = str2func(PSFACALC.tfbuildfunc);           
[SCRPTipt,TFB,err] = func(SCRPTipt,TFBipt);
if err.flag
    return
end
func = str2func(PSFACALC.susbuildfunc);           
[SCRPTipt,SUS,err] = func(SCRPTipt,SUSipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
PSFACALC.TFB = TFB;
PSFACALC.SUS = SUS;

Status2('done','',2);
Status2('done','',3);
