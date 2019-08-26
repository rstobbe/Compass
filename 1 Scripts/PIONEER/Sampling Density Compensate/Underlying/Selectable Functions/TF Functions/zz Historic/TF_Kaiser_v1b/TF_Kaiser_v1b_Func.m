%====================================================
% 
%====================================================

function [TF,err] = TF_Kaiser_v1b_Func(TF,INPUT)

Status2('busy','Return Kaiser Transfer Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;

%---------------------------------------------
% Common Variables
%---------------------------------------------
beta = TF.beta;
p = PROJdgn.p;

%---------------------------------------------
% Create Transfer Function
%---------------------------------------------
TF.r = (0:0.0001:1);
TF.tf = (1/p)*besseli(0,beta * sqrt(1 - TF.r.^2))/besseli(0,beta * sqrt(1 - p^2)); 

%---------------------------------------------
% Panel Output
%---------------------------------------------
PanelOutput = struct();
TF.PanelOutput = PanelOutput;