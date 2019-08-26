%====================================================
% 
%====================================================

function [GAMFUNC,err] = Gamma_CaKaiser_v1a_Func(GAMFUNC,INPUT)

Status2('busy','Define Gamma Design Function',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
p1 = INPUT.p1;
p2 = INPUT.p2;
beta = GAMFUNC.beta;

%---------------------------------------------
% Define Function
%---------------------------------------------
GAMFUNC.GamFunc = @(r,p) KaiserCaccFunc(r,p,beta,p2);
GAMFUNC.p2 = p2;

figure(12341234);
r = 0:0.01:1;
for n = 1:length(r)
    G(n) = GAMFUNC.GamFunc(r(n),p1);
end
plot(r,G);
ylim([0 110]); xlim([0 1]);

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Filter',GAMFUNC.method,'Output'};
Panel(2,:) = {'beta',beta,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GAMFUNC.PanelOutput = PanelOutput;
GAMFUNC.Panel = Panel;


%=================================================================
% KaiserCacc Function
%=================================================================
function [val] = KaiserCaccFunc(r,p1,beta,p2)

% if r <= p1
%     val = 1/p1^2;
%     %val = 1./r.^2;
% elseif r < p2
%     val = 1./r.^2;
% else
    val = (1/p2^2)*besseli(0,beta * sqrt(1 - r.^2))/besseli(0,beta * sqrt(1 - p2.^2));
% end

