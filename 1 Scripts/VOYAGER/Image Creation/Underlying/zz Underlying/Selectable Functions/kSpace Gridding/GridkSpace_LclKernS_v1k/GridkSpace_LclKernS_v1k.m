%=========================================================
% (v1k) 
%  - Will use multi-gpu code if available
%=========================================================

function [SCRPTipt,GRD,ReturnData,err] = GridkSpace_LclKernS_v1k(SCRPTipt,GRDipt)

Status2('busy','Get Info for k-Space Gridding',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

GRD = [];
ReturnData = [];
%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = GRDipt.Struct.labelstr;
if not(isfield(GRDipt,[CallingLabel,'_Data']))
    if isfield(GRDipt.('Kern_File').Struct,'selectedfile')
        file = GRDipt.('Kern_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Kern_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Kernel',2);
            load(file);
            saveData.path = file;
            GRDipt.([CallingLabel,'_Data']).('Kern_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Kern_File';
        ErrDisp(err);
        return
    end    
end

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GRD.method = GRDipt.Func;
GRD.KernFile = GRDipt.('Kern_File').EntryStr;

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ReturnData.('Kern_File_Data') = GRDipt.([CallingLabel,'_Data']).('Kern_File_Data');
GRD.KRNprms = GRDipt.([CallingLabel,'_Data']).Kern_File_Data.KRNprms;

Status2('done','',2);
Status2('done','',3);

