%=====================================================
% (v1a) 
%       
%=====================================================

function [SCRPTipt,B0COMP,err] = B0Comp_MeasResp_v1a(SCRPTipt,B0COMPipt)

Status2('busy','Get B0 Comp Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
B0COMP.method = B0COMPipt.Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = B0COMPipt.Struct.labelstr;
if not(isfield(B0COMPipt,[CallingLabel,'_Data']))
    if isfield(B0COMPipt.('B0Resp_File').Struct,'selectedfile')
        file = B0COMPipt.('B0Resp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load B0Resp_File';
            ErrDisp(err);
            return
        else
            load(file);
            B0COMPipt.([CallingLabel,'_Data']).('B0Resp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load B0Resp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
B0COMP.B0Resp = B0COMPipt.([CallingLabel,'_Data']).('B0Resp_File_Data');

Status2('done','',2);
Status2('done','',3);


    
    