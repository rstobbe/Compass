%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,REG,err] = Regression_B1Def_v1a(SCRPTipt,REGipt)

Status2('busy','Regression with Defined B1',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
REG.method = REGipt.Func;
REG.ModTestfunc = REGipt.('ModTestfunc').Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = REGipt.Struct.labelstr;
if not(isfield(REGipt,[CallingLabel,'_Data']))
    if isfield(REGipt.('B1DefFile_Excel').Struct,'selectedfile')
        file = REGipt.('B1DefFile_Excel').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load B1DefFile_Excel';
            ErrDisp(err);
            return
        else
            saveData.path = file;
            REGipt.([CallingLabel,'_Data']).('B1DefFile_Excel_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load B1DefFile_Excel';
        ErrDisp(err);
        return
    end    
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = REGipt.Struct.labelstr;
MODTSTipt = REGipt.('ModTestfunc');
if isfield(REGipt,([CallingLabel,'_Data']))
    if isfield(REGipt.([CallingLabel,'_Data']),'ModTestfunc_Data')
        MODTSTipt.('ModTestfunc_Data') = REGipt.([CallingLabel,'_Data']).('ModTestfunc_Data');
    end
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(REG.ModTestfunc);           
[SCRPTipt,MODTST,err] = func(SCRPTipt,MODTSTipt);
if err.flag
    return
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
REG.B1DefFile = REGipt.([CallingLabel,'_Data']).('B1DefFile_Excel_Data');
REG.MODTST = MODTST;

Status2('done','',2);
Status2('done','',3);
