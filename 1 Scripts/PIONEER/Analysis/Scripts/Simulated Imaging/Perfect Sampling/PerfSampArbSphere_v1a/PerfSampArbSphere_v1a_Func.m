%=========================================================
% 
%=========================================================

function [IMP,err] = PerfSampArbSphere_v1a_Func(INPUT)

Status('busy','Create Perfect Sampling Array');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
clear INPUT;

%---------------------------------------------
% Get Common Variables
%---------------------------------------------
fov = IMP.fov;
kstep = 1000./fov;
D = IMP.diam;

%----------------------------------------------
% Build Perfect Sampling
%----------------------------------------------
bot = -ceil(D/2);
top = ceil(D/2);
Ksz = top - bot+1;
Karr0 = zeros(Ksz^3,3);
kLoctest = zeros(Ksz,Ksz,Ksz);
n = 0;
for x = bot:top+1
    for y = bot:top+1
        for z = bot:top+1
            r = sqrt(x^2 + y^2 + z^2)/(D/2);
            if r <= 1 
                n = n+1; 
                Karr0(n,:) = [x y z];  
                kLoctest(x+top+1,y+top+1,z+top+1) = r;
            elseif r > 1 && r <= 1.0001                             % accomodate quantization 
                n = n+1; 
                Karr0(n,:) = [x y z];   
                r = 1;
                kLoctest(x+top+1,y+top+1,z+top+1) = r;           
            end
        end
    end
    Status2('busy',['x: ',num2str(x)],2);
end
Karr0 = Karr0(1:n,:);
kSampArr = Karr0*kstep;

%----------------------------------------------
% Test
%----------------------------------------------
r = sqrt(kSampArr(:,1).^2 + kSampArr(:,2).^2 + kSampArr(:,3).^2);
figure(1);
plot(r,ones(1,length(r)),'*');

%----------------------------------------------
% Return
%----------------------------------------------
PROJdgn.fov = fov;
PROJdgn.kmax = (D/2)*kstep;
PROJdgn.kstep = kstep;
PROJimp.nproj = 1;
PROJimp.npro = length(kSampArr);
PROJimp.maxrelkmax = 1;
PROJimp.meanrelkmax = 1;
Kmat = zeros(1,length(kSampArr),3);
Kmat(1,:,:) = kSampArr;
IMP.Kmat = Kmat;
IMP.PROJimp = PROJimp;
IMP.impPROJdgn = PROJdgn;






