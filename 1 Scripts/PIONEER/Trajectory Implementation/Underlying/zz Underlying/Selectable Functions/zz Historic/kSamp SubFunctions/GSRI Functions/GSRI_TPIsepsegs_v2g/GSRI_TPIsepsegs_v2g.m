%=====================================================
% (v2g)
%       - mean gradient array and visualization moved into file
%=====================================================

function [SCRPTipt,GSRI,err] = GSRI_TPIsepsegs_v2g(SCRPTipt,GSRIipt)

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
    if isfield(GSRIipt.('GSRIiseg_File').Struct,'selectedfile')
        file = GSRIipt.('GSRIiseg_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GSRIiseg_File';
            ErrDisp(err);
            return
        else
            load(file);
            GSRIipt.([CallingLabel,'_Data']).('GSRIiseg_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GSRIiseg_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(GSRIipt,[CallingLabel,'_Data']))
    if isfield(GSRIipt.('GSRItwseg_File').Struct,'selectedfile')
        file = GSRIipt.('GSRItwseg_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GSRItwseg_File';
            ErrDisp(err);
            return
        else
            load(file);
            GSRIipt.([CallingLabel,'_Data']).('GSRItwseg_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GSRItwseg_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GSRI.SRiseg = GSRIipt.([CallingLabel,'_Data']).('GSRIiseg_File_Data').SR;
GSRI.SRtwseg = GSRIipt.([CallingLabel,'_Data']).('GSRItwseg_File_Data').SR;

Status2('done','',2);
Status2('done','',3);

            
   