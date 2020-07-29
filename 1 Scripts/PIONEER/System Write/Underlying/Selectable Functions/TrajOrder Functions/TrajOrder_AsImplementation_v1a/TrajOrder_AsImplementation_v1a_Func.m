%=====================================================
%
%=====================================================

function [TORD,err] = TrajOrder_AsImplementation_v1a_Func(TORD,INPUT)

Status2('busy','Write Trajectory Order',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
clear INPUT

%-------------------------------------------------
% Select/Order Trajectories
%-------------------------------------------------
if not(isfield(IMP,'PSMP'))
    IMP.PSMP = struct();
end
if isfield(IMP.PSMP,'projsampscnr')
    TORD.projsampscnr = IMP.PSMP.projsampscnr;
else
    TORD.projsampscnr = 1:IMP.PROJdgn.nproj;
end
TORD.ReOrder = 'No';
if isfield(IMP.PSMP,'azireconosampfact')
    TORD.SdcOverSamp = IMP.PSMP.azireconosampfact*IMP.PSMP.polreconosampfact;
else
    TORD.SdcOverSamp = 1;
end
    
%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',TORD.method,'Output'};
Panel(3,:) = {'Total Trajectories',['As Design (',num2str(length(TORD.projsampscnr)),')'],'Output'};
Panel(4,:) = {'Trajectory Order','Straight','Output'};
TORD.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);






