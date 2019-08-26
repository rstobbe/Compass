%====================================================
%  
%====================================================

function [PWRCAL,err] = PwrCal_Im8_v1a_Func(PWRCAL,INPUT)

Status('busy','Calibrate Power');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Specified Flip Angles
%---------------------------------------------
inds = strfind(PWRCAL.specflip,':');
if not(isempty(inds))
    flipstart = str2double(PWRCAL.specflip(1:inds(1)-1));
    flipstep = str2double(PWRCAL.specflip(inds(1)+1:inds(2)-1));
    flipstop = str2double(PWRCAL.specflip(inds(2)+1:length(PWRCAL.specflip))); 
    flip = (flipstart:flipstep:flipstop);
else
    inds = strfind(PWRCAL.specflip,',');
    flip(1) = str2double(PWRCAL.specflip(1:inds(1)-1));
    for n = 2:length(inds)
    	flip(n) = str2double(PWRCAL.specflip(inds(n-1)+1:inds(n)-1));
    end
    flip(n+1) = str2double(PWRCAL.specflip(inds(n)+1:length(PWRCAL.specflip))); 
end
flip = pi*flip/180;

%---------------------------------------------
% Inload Image
%---------------------------------------------
ImSz = IMG{1}.ImSz;
ImMat = zeros(8,ImSz,ImSz,ImSz);
for m = 1:8
    ImMat(m,:,:,:) = IMG{m}.Im;
end    
clear IMG;

%---------------------------------------------
% Scale
%---------------------------------------------
ImMat = abs(ImMat)/abs(ImMat(8,ImSz/2,ImSz/2,ImSz/2));

%---------------------------------------------
% Regression
%---------------------------------------------
regfunc = str2func([PWRCAL.method,'_Reg']);
Est = [1 1];

PwrCal = zeros(ImSz^3,8);
n = 1;
B1tx = zeros(ImSz,ImSz,ImSz);
B1rx = zeros(ImSz,ImSz,ImSz);
PwrCal1 = zeros(ImSz,ImSz,ImSz);
for a = 1:ImSz
    for b = 1:ImSz
        for c = 1:ImSz
            Vals = permute(squeeze(ImMat(:,a,b,c)),[2 1]);
            if Vals(1) < 0.20
                B1tx(a,b,c) = NaN;
                PwrCal1(a,b,c) = NaN;
            else
                [beta,R] = nlinfit(flip,Vals,regfunc,Est);
                PwrCal(n,:) = R'./(beta(2)*sin(beta(1)*(flip)));
                PwrCal1(a,b,c) = PwrCal(n,1);
                B1tx(a,b,c) = beta(1);
                B1rx(a,b,c) = beta(2);
                %-----------------------------
                doplot = 0;
                if doplot == 1
                    clf(figure(100));
                    figure(100); hold on;
                    plot(flip,Vals,'r*');
                    plot(flip,(beta(2)*sin(beta(1)*(flip))));
                    figure(101); hold on;
                    plot(flip,PwrCal(n,:),'b*');
                end
                %-----------------------------
                n = n+1;
            end
        end
    end
    Status2('busy',num2str(ImSz-a),2);
end

PwrCal = PwrCal(1:n-1,:);
meanPwrCal = squeeze(mean(PwrCal,1));
stdPwrCal = squeeze(std(PwrCal,1));

figure(100); hold on;
plot(flip,meanPwrCal);
figure(101); hold on;
plot(flip,stdPwrCal);

maxB1txval = max(B1tx(:))
maxB1rxval = max(B1rx(:))

%---------------------------------------------
% Return
%---------------------------------------------
PWRCAL.B1tx = B1tx;
PWRCAL.B1rx = B1rx;
PWRCAL.Flip = flip;
PWRCAL.meanPwrCal = meanPwrCal;
PWRCAL.stdPwrCal = stdPwrCal;
PWRCAL.ImSz = ImSz;


Status('done','');
Status2('done','',2);
Status2('done','',3);

