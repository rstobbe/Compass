%=====================================================
% (v1h)
%       - Use Vector GradQuant
%=====================================================

function [SCRPTipt,BLDEXP,err] = BuildExp_ExcelFile_v1a(SCRPTipt,BLDEXPipt)

Status2('busy','Get SysResp Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
BLDEXP.method = BLDEXPipt.Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = BLDEXPipt.Struct.labelstr;
if not(isfield(BLDEXPipt,[CallingLabel,'_Data']))
    if isfield(BLDEXPipt.('ExpFile_Excel').Struct,'selectedfile')
        file = BLDEXPipt.('ExpFile_Excel').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load ExpFile_Excel';
            ErrDisp(err);
            return
        else
            Status2('busy','Load ExpFile_Excel',2);
            load(file);
            saveData.path = file;
            BLDEXPipt.([CallingLabel,'_Data']).('ExpFile_Excel_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load ExpFile_Excel';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
BLDEXP.ExpExcelFile = BLDEXPipt.([CallingLabel,'_Data']).('ExpFile_Excel_Data');

Status2('done','',2);
Status2('done','',3);