%=====================================================
% (v2e)
%       - Gradient Step Response Specified as Matrix
%=====================================================

function [SCRPTipt,GSRI,err] = GSRI_TPIstandard_v2e(SCRPTipt,GSRIipt)

Status2('busy','Get Step Response Inclusion Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GSRI.method = GSRIipt.Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = GSRIipt.Struct.labelstr;
if not(isfield(GSRIipt,[CallingLabel,'_Data']))
    if isfield(GSRIipt.('GSRI_File').Struct,'selectedfile')
        file = GSRIipt.('GSRI_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GSRI_File';
            ErrDisp(err);
            return
        else
            load(file);
            GSRIipt.([CallingLabel,'_Data']).('GSRI_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GSRI_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GSRI.SR = GSRIipt.([CallingLabel,'_Data']).('GSRI_File_Data').SR;

Status2('done','',2);
Status2('done','',3);

            
   