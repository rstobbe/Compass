%=========================================================
% (v2e)
%       - use 'WrtParam_SiemensYarnBall_v1d'
%=========================================================

function [SCRPTipt,SYSWRT,err] = WrtSys_SiemensYarnBall_v2e(SCRPTipt,SYSWRTipt)

Status2('busy','Write Trajectories for Siemens',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SYSWRT.method = SYSWRTipt.Func; 
SYSWRT.dummies = str2double(SYSWRTipt.('Dummies')); 
% SYSWRT.wrtgradfunc = SYSWRTipt.('WrtGradfunc').Func;  
% SYSWRT.wrtparamfunc = SYSWRTipt.('WrtParamfunc').Func;  

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
% CallingLabel = SYSWRTipt.Struct.labelstr;
% GRDWRTipt = SYSWRTipt.('WrtGradfunc');
% if isfield(SYSWRTipt,([CallingLabel,'_Data']))
%     if isfield(SYSWRTipt.([CallingLabel,'_Data']),'WrtGradfunc_Data')
%         GRDWRTipt.('WrtGradfunc_Data') = SYSWRTipt.([CallingLabel,'_Data']).('WrtGradfunc_Data');
%     end
% end
% PRMWRTipt = SYSWRTipt.('WrtParamfunc');
% if isfield(SYSWRTipt,([CallingLabel,'_Data']))
%     if isfield(SYSWRTipt.([CallingLabel,'_Data']),'WrtParamfunc_Data')
%         PRMWRTipt.('WrtParamfunc_Data') = SYSWRTipt.([CallingLabel,'_Data']).('WrtParamfunc_Data');
%     end
% end

%------------------------------------------
% Get Info
%------------------------------------------
% func = str2func(SYSWRT.wrtgradfunc);           
% [SCRPTipt,GRDWRT,err] = func(SCRPTipt,GRDWRTipt);
% if err.flag
%     return
% end
% func = str2func(SYSWRT.wrtparamfunc);           
% [SCRPTipt,PRMWRT,err] = func(SCRPTipt,PRMWRTipt);
% if err.flag
%     return
% end

GRDWRT.method = 'WrtGrad_Siemens_v1a';
PRMWRT.method = 'WrtParam_SiemensYarnBall_v1d';

%------------------------------------------
% Return
%------------------------------------------
SYSWRT.GRDWRT = GRDWRT;
SYSWRT.PRMWRT = PRMWRT;

Status2('done','',2);
Status2('done','',3);
