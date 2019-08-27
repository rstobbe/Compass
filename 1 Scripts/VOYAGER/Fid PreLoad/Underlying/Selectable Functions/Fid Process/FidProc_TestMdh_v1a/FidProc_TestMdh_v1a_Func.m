%=====================================================
% 
%=====================================================

function [FIDP,err] = FidProc_TestMdh_v1a_Func(FIDP,INPUT)

Status2('busy','Fid Test Siemens MDH',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DATA = INPUT.FID.DATA;
twix = DATA.TwixObj;
clear INPUT

%---------------------------------------------
% 
%---------------------------------------------
DataInfo = twix.image;
hdr = twix.hdr
Dicom = twix.hdr.Dicom
Config = twix.hdr.Config
Spice = twix.hdr.Spice
MeasYaps = twix.hdr.MeasYaps
Meas = twix.hdr.Meas                       % if needed all MrProt parameters in an array
Phoenix = twix.hdr.Phoenix;                 % seems to have the most info neatly organized
MrProt = Phoenix;

%---------------------------------------------
% Rearrange
%---------------------------------------------        
%FIDmat = twix.image{''};                   % bad - squeezes the data
FIDmat = twix.image(); 

%---------------------------------------------  
% Return
%---------------------------------------------    
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',FIDP.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FIDP.PanelOutput = PanelOutput;

FIDP.FIDmat = FIDmat;
clear INPUT;  

Status2('done','',2);
Status2('done','',3);

