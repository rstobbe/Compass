%====================================================
% 
%====================================================

function [TF,err] = TF_Uniform_v1a_Func(TF,INPUT)

Status2('busy','Return Uniform Transfer Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
if isfield(IMP,'impPROJdgn');
    PROJdgn = IMP.impPROJdgn;
else
    PROJdgn = IMP.PROJdgn;
end
    
%---------------------------------------------
% Common Variables
%---------------------------------------------
weighting = TF.weighting;
output = TF.output;

%---------------------------------------------
% Create Transfer Function
%---------------------------------------------
if strcmp(output,'Array') && strcmp(weighting,'TPI')
    p = PROJdgn.p;
    TF.r = (0:0.0001:1);
    TF.tf = (1/p)*ones(size(TF.r)); 
elseif strcmp(output,'Array') && strcmp(weighting,'OneAtEnd')
    TF.r = (0:0.0001:1);
    TF.tf = ones(size(TF.r)); 
elseif strcmp(output,'Function') && strcmp(weighting,'TPI')
    p = PROJdgn.p;
    TF.tf = @(r) (1/p); 
elseif strcmp(output,'Function') && strcmp(weighting,'OneAtEnd')
    TF.tf = @(r) 1;
end
    
%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'TF_Shape','Uniform','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TF.PanelOutput = PanelOutput;



