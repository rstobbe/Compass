%==================================
% 
%==================================

function [ATR,err] = AddExpTransResp_v1a_Func(ATR,INPUT)

Status2('busy','Add Eddy Currents',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G;
gstepdur = INPUT.gstepdur;
tc = INPUT.tc;
mag = INPUT.mag;
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
Geddyadd = [G,zeros(nproj,eddylen)] + Geddy;          % negative is an eddy current

%---------------------------------------------
% Return 
%---------------------------------------------
ATR.Teddy = Teddy;
ATR.Geddyadd = Geddyadd;
ATR.Geddy = Geddy;
ATR.eddy0 = eddy0;
ATR.eddy = eddy;
ATR.t = t;

Status2('done','',2);
Status2('done','',3);
