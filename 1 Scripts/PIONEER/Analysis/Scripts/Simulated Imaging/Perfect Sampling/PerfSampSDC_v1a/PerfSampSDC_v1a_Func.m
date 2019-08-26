%=========================================================
% 
%=========================================================

function [SDCS,err] = PerfSampSDC_v1a_Func(INPUT)

Status('busy','Create Perfect Sampling Array SDC');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SDCS = INPUT.SDCS;
TF = INPUT.TF;
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
PROJdgn = IMP.impPROJdgn;
clear INPUT;

%---------------------------------------------
% Get Common Variables
%---------------------------------------------
kstep = PROJdgn.kstep;
kmax = PROJdgn.kmax;
D = 2*kmax/kstep;

%----------------------------------------------
% Get TF
%----------------------------------------------
func = str2func([SDCS.TFfunc,'_Func']);  
INPUT.IMP = IMP;
[TF,err] = func(TF,INPUT);
if err.flag
    return
end
clear INPUT;
tffunc = TF.tf;

%----------------------------------------------
% Build Perfect Sampling
%----------------------------------------------
bot = -ceil(D/2);
top = ceil(D/2);
Ksz = top - bot+1;
Karr0 = zeros(Ksz^3,3);
SDC = zeros(Ksz^3,1);
kLoctest = zeros(Ksz,Ksz,Ksz);
SDCtest = zeros(Ksz,Ksz,Ksz);
n = 0;
for x = bot:top+1
    for y = bot:top+1
        for z = bot:top+1
            r = sqrt(x^2 + y^2 + z^2)/(D/2);
            if r <= 1 
                n = n+1; 
                Karr0(n,:) = [x y z];  
                SDC(n) = tffunc(r);
                kLoctest(x+top+1,y+top+1,z+top+1) = r;
                SDCtest(x+top+1,y+top+1,z+top+1) = tffunc(r);
            elseif r > 1 && r <= 1.0001                             % accomodate quantization 
                n = n+1; 
                Karr0(n,:) = [x y z];   
                r = 1;
                SDC(n) = tffunc(r);
                kLoctest(x+top+1,y+top+1,z+top+1) = r;
                SDCtest(x+top+1,y+top+1,z+top+1) = tffunc(r);                
            end
        end
    end
    Status2('busy',['x: ',num2str(x)],2);
end

Karr0 = Karr0(1:n,:);
kSampArr = Karr0*kstep;
SDC = SDC(1:n);

%----------------------------------------------
% Scale
%----------------------------------------------
%maxSDC = max(SDC);
%SDC = SDC/maxSDC;
%SDCtest = SDCtest/maxSDC;

%----------------------------------------------
% Test
%----------------------------------------------
C = top+1;
r = sqrt(kSampArr(:,1).^2 + kSampArr(:,2).^2 + kSampArr(:,3).^2);
figure(1);
plot(r,SDC,'*');
figure(2);
plot(squeeze(kLoctest(C,C,:)),squeeze(SDCtest(C,C,:)),'*');
figure(3);
plot(squeeze(kLoctest(C,C,:)));
figure(4);
plot(squeeze(SDCtest(C,C,:)));

%----------------------------------------------
% Return
%----------------------------------------------
SDCS.SDC = SDC;






