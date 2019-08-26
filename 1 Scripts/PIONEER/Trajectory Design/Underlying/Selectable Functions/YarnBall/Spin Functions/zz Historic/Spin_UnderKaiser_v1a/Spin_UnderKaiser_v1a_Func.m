%====================================================
% 
%====================================================

function [SPIN,err] = Spin_UnderKaiser_v1a_Func(SPIN,INPUT)

Status2('busy','Define Spinning Functions',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;

%---------------------------------------------
% Calculate Spin Functions
%---------------------------------------------
SPIN.spincalcnprojfunc = @(r) Profile(r,SPIN,PROJdgn);
SPIN.spincalcndiscsfunc = @(r) sqrt(Profile(r,SPIN,PROJdgn)/2);
SPIN.spiralaccom = (PROJdgn.rad+SPIN.SpiralOverShoot)/PROJdgn.rad;

%---------------------------------------------
% Test Array
%--------------------------------------------- 
SPIN.r = (0:0.001:1);
SPIN.spincalcnprojarr = SPIN.spincalcnprojfunc(SPIN.r);
SPIN.spincalcndiscsarr = SPIN.spincalcndiscsfunc(SPIN.r);
SPIN.usamparr = PROJdgn.nproj./SPIN.spincalcnprojarr;

%--------------------------------------------- 
% Visuals
%--------------------------------------------- 
if strcmp(SPIN.Vis,'Yes') 
    figure(2010); hold on; 
    plot(SPIN.r,SPIN.usamparr,'r-','linewidth',2); 
    ylim([0 1.05]);
    xlabel('Relative Radial Value'); ylabel('Relative Spin Speed');
    button = questdlg('Continue?');
    if strcmp(button,'No') 
        err.flag = 4;
        err.msg = '';
        return
    end
end

%--------------------------------------------- 
% Calculate Effect Undersampling Factor
%--------------------------------------------- 
SPIN.GblSamp = sum(SPIN.usamparr.*(SPIN.r.^2))/sum(SPIN.r.^2); 

%--------------------------------------------- 
% Name
%--------------------------------------------- 
SPIN.type = 'UnderKaiser';
SPIN.number = num2str(100*SPIN.GblSamp,'%3.0f');
SPIN.name = ['K',SPIN.number];

%--------------------------------------------- 
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Method',SPIN.method,'Output'};
Panel(2,:) = {'EffUsamp',SPIN.GblSamp,'Output'};
Panel(3,:) = {'EndUsamp',SPIN.sampend,'Output'};

SPIN.Panel = Panel;
Status2('done','',2);
Status2('done','',3);

%====================================================
% Spin Function
%====================================================
function Profile = Profile(r,SPIN,PROJdgn)

Kaiser = @(r) besseli(0,SPIN.sampbeta * sqrt(1 - r.^2)); 
Kaiser = @(r) Kaiser(r)/Kaiser(0);

Profile = zeros(size(r));
for n = 1:length(r)
    if r(n) < SPIN.sampshift
        Profile(n) = PROJdgn.nproj;
    else
        Profile(n) = PROJdgn.nproj./((1-SPIN.sampend).*Kaiser(r(n)-SPIN.sampshift) + SPIN.sampend);
    end
end



