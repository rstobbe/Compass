%====================================================
% 
%====================================================

function [TF,err] = TF_Kaiser_v1c_Func(TF,INPUT)

Status2('busy','Return Kaiser Transfer Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
if not(isfield(IMP,'impPROJdgn'))
    PROJdgn = IMP.PROJdgn;
else
    PROJdgn = IMP.impPROJdgn;
end

%---------------------------------------------
% Common Variables
%---------------------------------------------
beta = TF.beta;
weighting = TF.weighting;
output = TF.output;

%---------------------------------------------
% Create Transfer Function
%---------------------------------------------
if strcmp(output,'Array') && strcmp(weighting,'TPI')
    p = PROJdgn.p;
    TF.r = (0:0.0001:1);
    TF.tf = (1/p)*besseli(0,beta * sqrt(1 - TF.r.^2))/besseli(0,beta * sqrt(1 - p^2)); 
elseif strcmp(output,'Array') && strcmp(weighting,'OneAtCen')
    TF.r = (0:0.0001:1);
    tf = besseli(0,beta * sqrt(1 - TF.r.^2)); 
    TF.tf = tf/tf(1);
elseif strcmp(output,'Array') && strcmp(weighting,'OneAtEnd')
    TF.r = (0:0.0001:1);
    tf = besseli(0,beta * sqrt(1 - TF.r.^2)); 
    TF.tf = tf/tf(length(tf));
elseif strcmp(output,'Function') && strcmp(weighting,'TPI')
    p = PROJdgn.p;
    TF.tf = @(r) (1/p)*besseli(0,beta * sqrt(1 - r^2))/besseli(0,beta * sqrt(1 - p^2)); 
elseif strcmp(output,'Function') && strcmp(weighting,'OneAtCen')
    tf = @(r) besseli(0,beta * sqrt(1 - r^2)); 
    TF.tf = @(r) tf(r)/tf(1);
elseif strcmp(output,'Function') && strcmp(weighting,'OneAtEnd')
    tf = @(r) besseli(0,beta * sqrt(1 - r^2)); 
    TF.tf = @(r) tf(r)/tf(length(tf));
end  

TF.tf = 1./TF.tf;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'TF_Shape','Kaiser','Output'};
Panel(2,:) = {'TF_beta',TF.beta,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TF.PanelOutput = PanelOutput;


