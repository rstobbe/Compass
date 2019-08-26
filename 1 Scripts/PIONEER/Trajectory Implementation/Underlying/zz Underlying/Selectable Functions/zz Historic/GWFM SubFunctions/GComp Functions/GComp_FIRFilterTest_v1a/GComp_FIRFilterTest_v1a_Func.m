%=====================================================
% 
%=====================================================

function [GCOMP,err] = GComp_FIRFilterTest_v1a_Func(GCOMP,INPUT)

Status2('busy','No Transient Compensation',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G0;
T = INPUT.T;
clear INPUT

%---------------------------------------------
% Zero Fill End
%---------------------------------------------
ZFadd = 20;
sz = size(G);
G = cat(2,G,zeros(sz(1),ZFadd,3));

%---------------------------------------------
% Find Initial Error Vector
%---------------------------------------------
filt = dsp.FIRFilter;
reset(filt);
filt.Numerator = fir1(10,0.1);
[nProj,~,~] = size(G);
Gfilt = zeros(size(G));
for n = 1:nProj
    for d = 1:3
        reset(filt);
        Gfilt(n,:,d) = step(filt,squeeze(G(n,:,d)).');
    end
end
gd = grpdelay(filt,1);
Gfiltshift = cat(2,Gfilt(:,gd+1:end,:),zeros(nProj,gd,3));

errvec = G - Gfiltshift;
testerr = sum(abs(errvec(:)))

%---------------------------------------------
% Compensate
%---------------------------------------------
Iterations = 1;
Gnew = G;
for i = 1:Iterations
    Gnew = Gnew + errvec;
    
    Gfilt = zeros(size(Gnew));
    for n = 1:nProj
        for d = 1:3
            reset(filt);
            Gfilt(n,:,d) = step(filt,squeeze(Gnew(n,:,d)).');
        end
    end
    gd = grpdelay(filt,1);
    Gfiltshift = cat(2,Gfilt(:,gd+1:end,:),zeros(nProj,gd,3));
    
    errvec = G - Gfiltshift;
    testerr = sum(abs(errvec(:)))
end
       
figure(10001); hold on;
plot(G(1,:,3),'k');
plot(Gnew(1,:,3),'r');
plot(Gfiltshift(1,:,3),'b');
plot(Gfilt(1,:,3),'c');

%---------------------------------------------
% Return
%---------------------------------------------
Extend = 4;
GCOMP.G = Gnew(:,1:end-ZFadd+Extend,:);
GCOMP.G(:,end,:) = zeros(sz(1),1,3);
GCOMP.T = [T T(end)+(T(2):T(2):T(2)*Extend)];

Status2('done','',3);
