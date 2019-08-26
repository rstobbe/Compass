%====================================================
% (v1c)
%       - update for RWSUI_GBL
%====================================================

function [SCRPTipt,PSMPout,err] = ProjSamp_Cones_v1c(SCRPTipt,PSMP)

Status('busy','Define Projection Sampling');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
PSMPout = struct();
PSMPout.PCDfunc = PSMP.('ProjConeDistfunc').Func;
PSMPout.PADfunc = PSMP.('ProjAngleDistfunc').Func;

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
CallingPanelOutput = PSMP.Struct.labelstr;
PCD = PSMP.('ProjConeDistfunc');
if isfield(PSMPout,([CallingPanelOutput,'_Data']))
    if isfield(PSMPout.([CallingPanelOutput,'_Data']),('ProjConeDistfunc_Data'))
        PCD.ProjConeDistfunc_Data = PSMP.([CallingPanelOutput,'_Data']).ProjConeDistfunc_Data;
    end
end
PAD = PSMP.('ProjAngleDistfunc');
if isfield(PSMPout,([CallingPanelOutput,'_Data']))
    if isfield(PSMPout.([CallingPanelOutput,'_Data']),('ProjAngleDistfunc_Data'))
        PAD.ProjAngleDistfunc_Data = PSMP.([CallingPanelOutput,'_Data']).ProjAngleDistfunc_Data;
    end
end
PROJdgn = PSMP.PROJdgn;

%----------------------------------------------------
% Projection-Cone Distribution
%----------------------------------------------------  
func = str2func(PSMPout.PCDfunc);
PCD.PROJdgn = PROJdgn;
[SCRPTipt,PCD,err] = func(SCRPTipt,PCD);
if err.flag
    return
end

%----------------------------------------------------
% Test
%---------------------------------------------------- 
if PCD.osamp_phi < 1 || PCD.osamp_theta < 1
    osamp_phi = PCD.osamp_phi
    osamp_theta = PCD.osamp_theta
    err.flag = 1;
    err.msg = 'increase #projs';
    return
end

%----------------------------------------------------
% Projection-Angle Distribution
%---------------------------------------------------- 
PCDipt = PCD;
if strcmp(PSMP.testing,'Yes')
    PCDipt.ncones = PSMP.tnproj*2;
    PCDipt.nprojcone = ones(1,PSMP.tnproj*2);                                 
    PCDipt.phi = flipdim((0:(pi/(2*PSMP.tnproj-1)):pi/2),2);
    PCDipt.conephi = [PCDipt.phi PCDipt.phi];
    PCD.testncones = PCDipt.ncones;
    PCD.testnprojcone = PCDipt.nprojcone;
    PCD.testconephi = PCDipt.conephi;
else
    PCDipt = PCD;
end
    
%----------------------------------------------------
% Projection-Angle Distribution
%----------------------------------------------------  
func = str2func(PSMPout.PADfunc);   
[SCRPTipt,PAD,err] = func(SCRPTipt,PAD,PCDipt);
if err.flag
    return
end

%----------------------------------------------------
% Return
%----------------------------------------------------  
PSMPout.IV = PAD.IV;
PSMPout.projosamp = PCD.projosamp;
PSMPout.nproj = PCD.nproj;
PSMPout.PCD = PCD;
PSMPout.PAD = PAD;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'projosamp',PSMPout.projosamp,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
PSMPout.PanelOutput = PanelOutput;




