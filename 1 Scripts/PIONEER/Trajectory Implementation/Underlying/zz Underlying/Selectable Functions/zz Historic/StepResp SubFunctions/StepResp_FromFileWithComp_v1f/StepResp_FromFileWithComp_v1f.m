%=====================================================
% (v1f)
%       - Start 'SysResp_FromFileWithComp_v1f'
%=====================================================

function [SCRPTipt,SYSRESP,err] = StepResp_FromFileWithComp_v1f(SCRPTipt,SYSRESPipt)

Status2('busy','Get StepResp Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
SYSRESP.method = SYSRESPipt.Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = SYSRESPipt.Struct.labelstr;
if not(isfield(SYSRESPipt,[CallingLabel,'_Data']))
    if isfield(SYSRESPipt.('StepResp_File').Struct,'selectedfile')
        file = SYSRESPipt.('StepResp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load StepResp_File';
            ErrDisp(err);
            return
        else
            load(file);
            SYSRESPipt.([CallingLabel,'_Data']).('StepResp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load StepResp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SYSRESP.SR = SYSRESPipt.([CallingLabel,'_Data']).('StepResp_File_Data').SR;

Status2('done','',2);
Status2('done','',3);