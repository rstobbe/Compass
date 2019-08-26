%=====================================================
%
%=====================================================

function [GCONV,err] = GrappaConv_v1a_Func(GCONV,INPUT)

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
% Zero-Fill Kernel to size of Data
%---------------------------------------------
Kern = GKERN.Kern;
[ksz,~,~,Nrcvrs] = size(kDat);                  % assume symmetric
[Krnsz,~,~] = size(Kern);                       
zfKern = zeros(ksz,ksz,ksz);
zfKern(1:Krnsz,1:Krnsz,1:Krnsz) = Kern;

cenKern = zeros(size(Kern));
cenKern(GKERN.cen,GKERN.cen,GKERN.cen) = 1;
zfcenKern = zeros(ksz,ksz,ksz);
zfcenKern(1:Krnsz,1:Krnsz,1:Krnsz) = cenKern;

%---------------------------------------------
% Solve new kDat
%---------------------------------------------
nkDat = zeros(size(kDat));
for n = 0:ksz-Krnsz
    for m = 0:ksz-Krnsz   
        for p = 0:ksz-Krnsz
            tKern = circshift(zfKern,[n m p]);
            sampinds = logical(tKern);
            tcenKern = circshift(zfcenKern,[n m p]);
            cenind = logical(tcenKern);
            X = [];
            for i = 1:Nrcvrs
                tkDat = squeeze(kDat(:,:,:,i));
                tX = tkDat(sampinds);
                X = [X;tX(:)];
            end
            for i = 1:Nrcvrs
                tnkDat = nkDat(:,:,:,i);
                tnkDat(cenind) = G(:,i)'*X;
                nkDat(:,:,:,i) = tnkDat;
            end
        end
        Status2('busy',['m: ',num2str(m)],2);    
    end
    Status2('busy',['n: ',num2str(n)],3);
end

%---------------------------------------------
% Return
%---------------------------------------------
GCONV.kDat = kDat;

Status2('done','',2);
Status2('done','',3);



