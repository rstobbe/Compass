%=====================================================
% (v2e)
%       - exact same as GSRA_TPIfirst_v2e
%=====================================================

function [SCRPTipt,GSRA,err] = GSRA_TPIfirstNsepsegs_v2e(SCRPTipt,GSRAipt)

Status2('busy','Get Step Response Accomodation Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GSRA.method = GSRAipt.Func;
GSRA.accomNsegs = str2double(GSRAipt.('AccomNsegs'));

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = GSRAipt.Struct.labelstr;
if not(isfield(GSRAipt,[CallingLabel,'_Data']))
    if isfield(GSRAipt.('GSRAiseg_File').Struct,'selectedfile')
        file = GSRAipt.('GSRAiseg_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GSRAiseg_File';
            ErrDisp(err);
            return
        else
            load(file);
            GSRAipt.([CallingLabel,'_Data']).('GSRAiseg_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GSRAiseg_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(GSRAipt,[CallingLabel,'_Data']))
    if isfield(GSRAipt.('GSRAtwseg_File').Struct,'selectedfile')
        file = GSRAipt.('GSRAtwseg_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GSRAtwseg_File';
            ErrDisp(err);
            return
        else
            load(file);
            GSRAipt.([CallingLabel,'_Data']).('GSRAtwseg_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GSRAtwseg_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GSRA.SRiseg = GSRAipt.([CallingLabel,'_Data']).('GSRAiseg_File_Data').SR;
GSRA.SRtwseg = GSRAipt.([CallingLabel,'_Data']).('GSRAtwseg_File_Data').SR;

Status2('done','',2);
Status2('done','',3);

            
        

       