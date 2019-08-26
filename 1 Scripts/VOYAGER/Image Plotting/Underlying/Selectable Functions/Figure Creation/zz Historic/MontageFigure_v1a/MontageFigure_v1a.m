%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,MONT,err] = MontageFigure_v1a(SCRPTipt,SCRPTGBL,MONTipt)

Status2('busy','Montage Figure',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MONT.method = MONTipt.Func; 
MONT.imscalefunc = MONTipt.('ImScalefunc').Func;  
MONT.plotfunc = MONTipt.('Plotfunc').Func;  

CallingLabel = MONTipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IMSCLipt = MONTipt.('ImScalefunc');
if isfield(MONTipt,([CallingLabel,'_Data']))
    if isfield(MONTipt.([CallingLabel,'_Data']),'ImScalefunc_Data')
        IMSCLipt.('ImScalefunc_Data') = MONTipt.([CallingLabel,'_Data']).('ImScalefunc_Data');
    end
end
PLOTipt = MONTipt.('Plotfunc');
if isfield(MONTipt,([CallingLabel,'_Data']))
    if isfield(MONTipt.([CallingLabel,'_Data']),'Plotfunc_Data')
        PLOTipt.('Plotfunc_Data') = MONTipt.([CallingLabel,'_Data']).('Plotfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(MONT.imscalefunc);           
[SCRPTipt,IMSCL,err] = func(SCRPTipt,IMSCLipt);
if err.flag
    return
end
func = str2func(MONT.plotfunc);           
[SCRPTipt,PLOT,err] = func(SCRPTipt,PLOTipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
MONT.IMSCL = IMSCL;
MONT.PLOT = PLOT;


Status2('done','',2);
Status2('done','',3);
