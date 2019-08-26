%=========================================================
% 
%=========================================================

function [TST,err] = SSStateT1WgtAnlz_v1a_Func(TST,INPUT)

Status2('busy','T1 Weighting Analysis',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T1 = INPUT.NMR.T1;
clear INPUT;

%---------------------------------------------
% Arrays
%---------------------------------------------
TR = TST.TR;
flip = TST.Flip;

%---------------------------------------------
% Solve
%---------------------------------------------
for n = 1:length(T1)
    top = 1 - exp(-TR/T1(n));
    bot = 1 - cos((pi*flip/180).')*exp(-TR/T1(n));
    Mz(n) = top./bot;
end

TST.Mz = Mz;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',TST.method,'Output'};
Panel(3,:) = {'Mz',TST.Mz,'Output'};
TST.Panel = Panel;

Status2('done','',2);
Status2('done','',3);


