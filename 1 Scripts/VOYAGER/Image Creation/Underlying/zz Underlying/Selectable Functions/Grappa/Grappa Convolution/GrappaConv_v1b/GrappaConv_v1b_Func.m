%=====================================================
%
%=====================================================

function [GCONV,err] = GrappaConv_v1b_Func(GCONV,INPUT)

Status2('busy','Grappa Convolution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GKERN = INPUT.GKERN;
G = INPUT.G;
kDat = INPUT.kDat;
clear INPUT;

%---------------------------------------------
% Get Kernel Info
%---------------------------------------------
Kern = GKERN.Kern;
[ksz,~,~,Nrcvrs] = size(kDat);                  % assume symmetric
[Krnsz,~,~] = size(Kern);                       
zfKern = zeros(size(kDat));
repKern = repmat(Kern,[1 1 1 Nrcvrs]);
zfKern(1:Krnsz,1:Krnsz,1:Krnsz,:) = repKern;
kerninds0 = find(logical(zfKern));
clear zfKern

cenKern = zeros(size(Kern));
cenKern(GKERN.cen,GKERN.cen,GKERN.cen) = 1;
zfcenKern = zeros(size(kDat));
repcenKern = repmat(cenKern,[1 1 1 Nrcvrs]);
zfcenKern(1:Krnsz,1:Krnsz,1:Krnsz,:) = repcenKern;
ceninds0 = find(logical(zfcenKern));
clear zfcenKern

%---------------------------------------------
% Solve new kDat
%---------------------------------------------
nkDat = kDat;                   % initialization to complex array (overwrite all...) 
%whos
for n = 0:ksz-Krnsz
    for m = 0:ksz-Krnsz 
        for p = 0:ksz-Krnsz
            kerninds = kerninds0 + n + m*ksz + p*ksz^2; 
            X = kDat(kerninds);
            ceninds = ceninds0 + n + m*ksz + p*ksz^2; 
            nkDat(ceninds) = G'*X;
        end
    end
    Status2('busy',['n: ',num2str(n)],3);
end

%---------------------------------------------
% Return
%---------------------------------------------
GCONV.kDat = nkDat;

Status2('done','',2);
Status2('done','',3);



