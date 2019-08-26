%==================================
% 
%==================================

function [CTR,err] = CompExpTransResp_v1a_Func(CTR,INPUT)

Status2('busy','Compensate For Transient Response',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G;
gstepdur = INPUT.gstepdur;
tc = INPUT.tc;
mag = INPUT.mag;
startfromzero = INPUT.startfromzero;
clear INPUT;
   
%---------------------------------------------
% Exponential Decays
%---------------------------------------------
eddydur = 12*max(tc(:));
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
% Comp Transient Response1
%---------------------------------------------
[nproj,gradlen] = size(G);
Teddy = (0:gstepdur:(gradlen+eddylen-1)*gstepdur);
Geddyadd = G;

for p = 1:5
    Geddy = zeros(nproj,gradlen+eddylen);
    if strcmp(startfromzero,'Yes')
        Geddy(:,1:eddylen) = Geddyadd(:,1)*eddy;
    else
        Geddy(:,1:eddylen) = 0*eddy;
    end
    for n = 2:gradlen
        Geddy(:,n:n+eddylen-1) = Geddy(:,n:n+eddylen-1) + (Geddyadd(:,n)-Geddyadd(:,n-1))*eddy;
    end
    Geddyadd = [G,zeros(nproj,eddylen)] - Geddy;   
    Status2('busy',['Iteration: ',num2str(p)],3);
end

%---------------------------------------------
% Return 
%---------------------------------------------
CTR.Teddy = Teddy;
CTR.Geddyadd = Geddyadd;
CTR.Geddy = Geddy;
CTR.eddy0 = eddy0;
CTR.eddy = eddy;
CTR.t = t;

Status2('done','',3);
