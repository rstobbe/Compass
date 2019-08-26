%=====================================================
% (v1a)
%       
%=====================================================

function [SCRPTipt,GRAPPA,err] = GrappaRecon_v1a(SCRPTipt,GRAPPAipt)

Status2('busy','Grappa Reconstruction',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GRAPPA.method = GRAPPAipt.Func;
GRAPPA.kernfunc = GRAPPAipt.('GrappaKernfunc').Func;
GRAPPA.caldatfunc = GRAPPAipt.('GrappaCalDatExtfunc').Func;
GRAPPA.wcalcfunc = GRAPPAipt.('GrappaWCalcfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = GRAPPAipt.Struct.labelstr;
GKERNipt = GRAPPAipt.('GrappaKernfunc');
if isfield(GRAPPAipt,([CallingLabel,'_Data']))
    if isfield(GRAPPAipt.([CallingLabel,'_Data']),'GrappaKernfunc_Data')
        GKERNipt.('GrappaKernfunc_Data') = GRAPPAipt.([CallingLabel,'_Data']).('GrappaKernfunc_Data');
    end
end
GCDATipt = GRAPPAipt.('GrappaCalDatExtfunc');
if isfield(GRAPPAipt,([CallingLabel,'_Data']))
    if isfield(GRAPPAipt.([CallingLabel,'_Data']),'GrappaCalDatExtfunc_Data')
        GCDATipt.('GrappaCalDatExtfunc_Data') = GRAPPAipt.([CallingLabel,'_Data']).('GrappaCalDatExtfunc_Data');
    end
end
GWCALCipt = GRAPPAipt.('GrappaWCalcfunc');
if isfield(GRAPPAipt,([CallingLabel,'_Data']))
    if isfield(GRAPPAipt.([CallingLabel,'_Data']),'GrappaWCalcfunc_Data')
        GWCALCipt.('GrappaWCalcfunc_Data') = GRAPPAipt.([CallingLabel,'_Data']).('GrappaWCalcfunc_Data');
    end
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(GRAPPA.kernfunc);           
[SCRPTipt,GKERN,err] = func(SCRPTipt,GKERNipt);
if err.flag
    return
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(GRAPPA.caldatfunc);           
[SCRPTipt,GCDAT,err] = func(SCRPTipt,GCDATipt);
if err.flag
    return
end

%------------------------------------------
% 
%------------------------------------------
func = str2func(GRAPPA.wcalcfunc);           
[SCRPTipt,GWCALC,err] = func(SCRPTipt,GWCALCipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
GRAPPA.GKERN = GKERN;
GRAPPA.GCDAT = GCDAT;
GRAPPA.GWCALC = GWCALC;

Status2('done','',2);
Status2('done','',3);
