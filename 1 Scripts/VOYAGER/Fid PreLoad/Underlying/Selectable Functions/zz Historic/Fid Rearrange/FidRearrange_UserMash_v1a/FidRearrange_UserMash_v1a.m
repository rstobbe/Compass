%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,FIDR,err] = FidRearrange_UserMash_v1a(SCRPTipt,FIDRipt)

Status2('busy','Data Organization',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FIDR.method = FIDRipt.Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = FIDRipt.Struct.labelstr;
if not(isfield(FIDRipt,[CallingLabel,'_Data']))
    if isfield(FIDRipt.('UserMash_File').Struct,'selectedfile')
        file = FIDRipt.('UserMash_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load UserMash_File';
            ErrDisp(err);
            return
        else
            load(file);
            FIDRipt.([CallingLabel,'_Data']).('UserMash_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load UserMash_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FIDR.UserMashFile = FIDRipt.([CallingLabel,'_Data']).('UserMash_File_Data');


Status2('done','',2);
Status2('done','',3);









