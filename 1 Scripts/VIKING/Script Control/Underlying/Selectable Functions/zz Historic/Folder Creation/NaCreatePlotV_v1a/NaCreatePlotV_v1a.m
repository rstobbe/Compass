%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,NACPV,err] = NaCreatePlotV_v1a(SCRPTipt,NACPVipt)

Status2('busy','NaCreatePlotVarian',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Panel Input
%---------------------------------------------
NACPV.method = NACPVipt.Func;

%---------------------------------------------
% Tests
%---------------------------------------------
PanelLabel = 'CreateScript';
CallingLabel = NACPVipt.Struct.labelstr;
if not(isfield(NACPVipt,[CallingLabel,'_Data']))
    if isfield(NACPVipt.(PanelLabel).Struct,'selectedfile')
        file = NACPVipt.(PanelLabel).Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = ['(Re) Load ',PanelLabel];
            ErrDisp(err);
            return
        else
            error   %fix/check
            NACPVipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']).path = file;
        end
    else
        err.flag = 1;
        err.msg = ['(Re) Load ',PanelLabel];
        ErrDisp(err);
        return
    end
end
NACPV.Create = NACPVipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']);

PanelLabel = 'PlotScript';
CallingLabel = NACPVipt.Struct.labelstr;
if not(isfield(NACPVipt,[CallingLabel,'_Data']))
    if isfield(NACPVipt.(PanelLabel).Struct,'selectedfile')
        file = NACPVipt.(PanelLabel).Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = ['(Re) Load ',PanelLabel];
            ErrDisp(err);
            return
        else
            error   %fix/check
            NACPVipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']).path = file;
        end
    else
        err.flag = 1;
        err.msg = ['(Re) Load ',PanelLabel];
        ErrDisp(err);
        return
    end
end
NACPV.Plot = NACPVipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']);


Status2('done','',2);
Status2('done','',3);







