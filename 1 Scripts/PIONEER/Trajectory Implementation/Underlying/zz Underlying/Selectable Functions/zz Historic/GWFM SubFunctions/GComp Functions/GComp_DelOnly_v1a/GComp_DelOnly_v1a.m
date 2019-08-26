%=====================================================
% (v1a)
%     
%=====================================================

function [SCRPTipt,GComp,err] = GComp_DelOnly_v1a(SCRPTipt,GCompipt)

Status2('busy','Get GComp Infro',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GComp.method = GCompipt.Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = GCompipt.Struct.labelstr;
if not(isfield(GCompipt,[CallingLabel,'_Data']))
    if isfield(GCompipt.('Comp_File').Struct,'selectedfile')
        file = GCompipt.('Comp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Comp_File';
            ErrDisp(err);
            return
        else
            load(file);
            GCompipt.([CallingLabel,'_Data']).('Comp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Comp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GComp.Comp = GCompipt.([CallingLabel,'_Data']).('Comp_File_Data').COMP;

Status2('done','',2);
Status2('done','',3);