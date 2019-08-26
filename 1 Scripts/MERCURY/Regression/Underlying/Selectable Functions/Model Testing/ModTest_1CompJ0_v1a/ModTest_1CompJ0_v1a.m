%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,MODTST,err] = ModTest_1CompJ0_v1a(SCRPTipt,MODTSTipt)

Status2('busy','Define Model for Testing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
MODTST.method = MODTSTipt.Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = MODTSTipt.Struct.labelstr;
if not(isfield(MODTSTipt,[CallingLabel,'_Data']))
    if isfield(MODTSTipt.('ModelStartFile_Excel').Struct,'selectedfile')
        file = MODTSTipt.('ModelStartFile_Excel').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load ModelStartFile_Excel';
            ErrDisp(err);
            return
        else
            saveData.path = file;
            MODTSTipt.([CallingLabel,'_Data']).('ModelStartFile_Excel_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load ModelStartFile_Excel';
        ErrDisp(err);
        return
    end    
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
MODTST.ModelStartFile = MODTSTipt.([CallingLabel,'_Data']).('ModelStartFile_Excel_Data');

Status2('done','',2);
Status2('done','',3);