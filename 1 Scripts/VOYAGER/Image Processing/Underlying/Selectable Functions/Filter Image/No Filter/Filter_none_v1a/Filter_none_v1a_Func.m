%=====================================================
%
%=====================================================

function [FILT,err] = Filter_none_v1a_Func(FILT,INPUT)

Status2('busy','Filter',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% No Filtering - do nothing
%---------------------------------------------
if isfield(INPUT,'Im')
    FILT.Im = INPUT.Im;
elseif isfield(INPUT,'IMG')
    FILT.Im = INPUT.IMG.Im;
end

if isfield(INPUT,'ReconPars')
    ReconPars = INPUT.ReconPars;
elseif isfield(INPUT,'IMG')
    ReconPars = INPUT.IMG.ReconPars;
end
    
ReconPars.Filter = 'None';
FILT.ReconPars = ReconPars;

%---------------------------------------------
% Panel Output
%---------------------------------------------
Panel(1,:) = {'FilterMethod','None','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FILT.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);



