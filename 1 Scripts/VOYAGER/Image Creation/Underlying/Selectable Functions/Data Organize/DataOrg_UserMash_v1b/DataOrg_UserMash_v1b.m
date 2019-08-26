%=====================================================
% (v1b)
%      - update to use new Recon (for memory limitations)
%=====================================================

function [SCRPTipt,DATORG,err] = DataOrg_UserMash_v1b(SCRPTipt,DATORGipt)

Status2('busy','Data Organization',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
DATORG.method = DATORGipt.Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = DATORGipt.Struct.labelstr;
if not(isfield(DATORGipt,[CallingLabel,'_Data']))
    if isfield(DATORGipt.('UserMash_File').Struct,'selectedfile')
        file = DATORGipt.('UserMash_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load UserMash_File';
            ErrDisp(err);
            return
        else
            load(file);
            DATORGipt.([CallingLabel,'_Data']).('UserMash_File_Data') = saveData;
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
DATORG.UserMashFile = DATORGipt.([CallingLabel,'_Data']).('UserMash_File_Data');


Status2('done','',2);
Status2('done','',3);









