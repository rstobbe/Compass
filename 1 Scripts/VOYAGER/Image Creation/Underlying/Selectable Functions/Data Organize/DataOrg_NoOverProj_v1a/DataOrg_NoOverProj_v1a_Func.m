%=====================================================
% 
%=====================================================

function [DATORG,err] = DataOrg_NoOverProj_v1a_Func(DATORG,INPUT)

Status2('busy','Data Organization',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IC = INPUT.IC;
FIDmat = INPUT.FID.FIDmat;
RECON = INPUT.RECON;
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
if not(isfield(IC.IMP,'OverProj'))
    err.flag = 1;
    err.msg = 'Recreate ''Recon_File'' or use different DataOrgfunc';
    return
end
if strcmp(IC.IMP.OverProj,'Yes')
    err.flag = 1;
    err.msg = 'Use a different DataOrgfunc for ''OverProj''';
    return
end

%---------------------------------------------
% Reconstruction
%---------------------------------------------        
func = str2func([RECON.method,'_Func']);  
INPUT.IC = IC;
INPUT.Dat = FIDmat;
[RECON,err] = func(RECON,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------    
Panel(1,:) = {'',DATORG.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
DATORG.PanelOutput = [PanelOutput;RECON.PanelOutput];

DATORG.Im = RECON.Im;
RECON = rmfield(RECON,'Im');
DATORG.RECON = RECON;
clear INPUT;  


