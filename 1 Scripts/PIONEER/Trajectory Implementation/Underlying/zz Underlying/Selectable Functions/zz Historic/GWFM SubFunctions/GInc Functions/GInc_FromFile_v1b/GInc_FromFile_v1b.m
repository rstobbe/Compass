%=====================================================
% (v1b)
%       - Include Delay in 'Inc' File
%=====================================================

function [SCRPTipt,GINC,err] = GInc_FromFile_v1b(SCRPTipt,GINCipt)

Status2('busy','Get ECC Infro',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GINC.method = GINCipt.Func;
GINC.atrfunc = GINCipt.('ATRfunc').Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = GINCipt.Struct.labelstr;
if not(isfield(GINCipt,[CallingLabel,'_Data']))
    if isfield(GINCipt.('Comp_File').Struct,'selectedfile')
        file = GINCipt.('Comp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Comp_File';
            ErrDisp(err);
            return
        else
            load(file);
            GINCipt.([CallingLabel,'_Data']).('Comp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Comp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = GINCipt.Struct.labelstr;
ATRipt = GINCipt.('ATRfunc');
if isfield(GINCipt,([CallingFunction,'_Data']))
    if isfield(GINCipt.GIncfunc_Data,('ATRfunc_Data'))
        ATRipt.ATRfunc_Data = GINCipt.GIncfunc_Data.ATRfunc_Data;
    end
end

%------------------------------------------
% ATR Function Info
%------------------------------------------
func = str2func(GINC.atrfunc);           
[SCRPTipt,ATR,err] = func(SCRPTipt,ATRipt);
if err.flag
    return
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GINC.Inc = GINCipt.([CallingLabel,'_Data']).('Inc_File_Data').COMP;
GINC.ATR = ATR;

Status2('done','',2);
Status2('done','',3);