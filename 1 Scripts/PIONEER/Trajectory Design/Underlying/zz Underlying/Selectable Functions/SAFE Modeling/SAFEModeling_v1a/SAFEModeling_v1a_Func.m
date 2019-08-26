%==================================
% 
%==================================

function [ATR,err] = SAFEModeling_v1a_Func(ATR,INPUT)

Status2('busy','SAFE Modeling',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G;
gstepdur = INPUT.gstepdur;
%tc = INPUT.tc;
%mag = INPUT.mag;
clear INPUT;

%---------------------------------------------
% Models
%---------------------------------------------
tc =  [0.15,0.15,0.15;
       5.00,5.00,5.00];
mag = [0.50,0.50,0.50;
       0.50,0.50,0.50];  
%---------------------------------------------
% Limit Solve Duration
%---------------------------------------------
graddur = length(G)*gstepdur;

%---------------------------------------------
% Exponential Decays
%---------------------------------------------
eddydur = 12*max(tc(:));
if eddydur > graddur*1.01
    eddydur = graddur;
end
t = (0:gstepdur:eddydur);
eddylen = length(t);
N = length(tc);
eddy0 = zeros(N,eddylen);
    for n = 1:N
        if tc(n) == 0
            if mag(n) ~= 0
                error();
            end   
            tc(n) = 1;
        end
        eddy0(n,:) = 0.01*mag(n)*exp(-t/tc(n));
    end
eddy = squeeze(sum(eddy0,1));

%---------------------------------------------
% Add Transient Responses
%---------------------------------------------
[nproj,gradlen] = size(G);
Geddy = zeros(nproj,gradlen+eddylen);
Teddy = (0:gstepdur:(gradlen+eddylen-1)*gstepdur);
if strcmp(ATR.startfromzero,'Yes')
    Geddy(:,1:eddylen) = G(:,1)*eddy;
else
    Geddy(:,1:eddylen) = 0*eddy;
end
for n = 2:gradlen
    Geddy(:,n:n+eddylen-1) = Geddy(:,n:n+eddylen-1) + (G(:,n)-G(:,n-1))*eddy;
end
%Geddyadd = [G,zeros(nproj,eddylen)] + Geddy;          % negative is an eddy current

%---------------------------------------------
% Return 
%---------------------------------------------


Status2('done','',2);
Status2('done','',3);
