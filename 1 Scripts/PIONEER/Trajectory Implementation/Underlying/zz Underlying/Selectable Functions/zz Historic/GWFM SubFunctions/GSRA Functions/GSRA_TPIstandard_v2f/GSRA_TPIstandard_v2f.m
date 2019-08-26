%=====================================================
% (v2f)
%       - Update to accomodation 'search'
%=====================================================

function [SCRPTipt,GSRA,err] = GSRA_TPIstandard_v2f(SCRPTipt,GSRAipt)

Status2('busy','Get Step Response Accomodation Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GSRA.method = GSRAipt.Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = GSRAipt.Struct.labelstr;
if not(isfield(GSRAipt,[CallingLabel,'_Data']))
    if isfield(GSRAipt.('GSRA_File').Struct,'selectedfile')
        file = GSRAipt.('GSRA_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GSRA_File';
            ErrDisp(err);
            return
        else
            load(file);
            GSRAipt.([CallingLabel,'_Data']).('GSRA_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GSRA_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GSRA.SR = GSRAipt.([CallingLabel,'_Data']).('GSRA_File_Data').SR;

Status2('done','',2);
Status2('done','',3);

            
        

       