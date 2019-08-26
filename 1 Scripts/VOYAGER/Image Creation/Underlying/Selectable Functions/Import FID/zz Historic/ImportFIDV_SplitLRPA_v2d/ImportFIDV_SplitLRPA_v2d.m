%=========================================================
% (v2d)
%       - drop RF spoil
%=========================================================

function [SCRPTipt,FID,err] = ImportFIDV_SplitLRPA_v2d(SCRPTipt,FIDipt)

Status2('busy','Load FID',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Add this in...
%---------------------------------------------
%global TOTALGBL
%val = get(findobj('tag','totalgbl'),'value');
%if isempty(val) || val == 0
%    err.flag = 1;
%    err.msg = 'No FID in Global Memory';
%    return  
%end
%FID = TOTALGBL{2,val};
%if not(isfield...
%   error();
%
%   - add a 'use Global' switch
%   - if yes... write the value into the field
%---------------------------------------------

FID = struct();
CallingLabel = FIDipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(FIDipt,[CallingLabel,'_Data']))
    if isfield(FIDipt.('FIDpath').Struct,'selectedfile')
        file = FIDipt.('FIDpath').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load FIDpath';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            FIDipt.([CallingLabel,'_Data']).('FIDpath_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load FIDpath';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FID.method = FIDipt.Func;
FID.path = FIDipt.([CallingLabel,'_Data']).('FIDpath_Data').path;

Status2('done','',2);
Status2('done','',3);




