%==================================
% 
%==================================

function [ATR,err] = AddDecayingExpTransResp_v1a_Func(ATR,INPUT)

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

gradstart = 0.5;
drop(1) = 0.05;

[nproj,gradlen] = size(G);
%---------------------------------------------
% Exponential Decays
%---------------------------------------------
eddydur = 12*max(tc(:));
t = (0:gstepdur:eddydur);
eddylen = length(t);
N = length(tc);
eddy0 = zeros(N,eddylen,gradlen);
start = round(gradstart/gstepdur);
for n = 1:N
    if tc(n) == 0
        if mag(n) ~= 0
            error();
        end   
        tc(n) = 1;
    end
    for m = start:gradlen
        eddy0(n,:,m) = 0.01*mag(n)*exp((-(m-start)*gstepdur)/drop(n))*exp(-t/tc(n));
    end
end
eddy = squeeze(sum(eddy0,1));

figure(1234);
test = (0:gstepdur:(gradlen-1)*gstepdur);
plot(test,eddy(1,:));

%---------------------------------------------
% Add Transient Responses
%---------------------------------------------
Geddy = zeros(nproj,gradlen+eddylen);
Teddy = (0:gstepdur:(gradlen+eddylen-1)*gstepdur);
if strcmp(ATR.startfromzero,'Yes')
    Geddy(:,1:eddylen) = G(:,1)*eddy(:,n);
else
    Geddy(:,1:eddylen) = 0*eddy(:,n);
end
for n = 2:gradlen
    Geddy(:,n:n+eddylen-1) = Geddy(:,n:n+eddylen-1) + (G(:,n)-G(:,n-1))*squeeze(eddy(:,n)).';
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
