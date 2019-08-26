%=========================================================
% 
%=========================================================

function [TRANSCOR,err] = TransCorMSYB_v1a_Func(TRANSCOR,INPUT)

Status2('busy','Correct for Object Translation from Motion',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KSMP = INPUT.KSMP;
translations0 = KSMP.TRANS.translations;
MOTCOR = INPUT.MOTCOR;
GrdDatCen = INPUT.GrdDatCen;
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------     
kmax = IMP.impPROJdgn.kmax;
nproj = IMP.PROJimp.nproj;
npro = IMP.PROJimp.npro;
subsamp = MOTCOR.GRD.SS;
vox = IMP.impPROJdgn.vox;
rad = IMP.impPROJdgn.rad;

%---------------------------------------------
% Data to Matrix
%---------------------------------------------
[DAT] = DatArr2Mat(KSMP.SampDat,IMP.PROJimp.nproj,IMP.PROJimp.npro);

%---------------------------------------------
% Test
%---------------------------------------------
if subsamp ~= 1
    err.flag = 1;
    err.msg = 'TransCorMSYB_v1a only designed for SubSamp = 1';
end

%---------------------------------------------
% Further Isolate Middle
%---------------------------------------------
Ksz = length(GrdDatCen(1,:,:,:));
Cen = (Ksz+1)/2;
Crad = 1;
CkSpace = GrdDatCen(:,Cen-Crad:Cen+Crad,Cen-Crad:Cen+Crad,Cen-Crad:Cen+Crad);

%---------------------------------------------
% Determine kSpace Shift of Each Trajectory
%---------------------------------------------
for n = 1:nproj
    %---------------------------------------------
    % Extract Linear Motion
    if n == 1
        phCkSpace1 = squeeze(angle(CkSpace(1,:,:,:)));
        phslp(1) = 0;
    %---------------------------------------------
    % Extract Motion
    elseif n > 1
        phCkSpace = squeeze(angle(CkSpace(n,:,:,:)));
        phdif = phCkSpace - phCkSpace1;

        %---------------------------------------------
        % Phase Ramp X
        meanXYphdif = mean(phdif,3);
        meanXphdif = mean(meanXYphdif,1);
        t = [-1 0 1];
        [r,phslp(n,2),pfoffset] = regression(t,meanXphdif);
        
        %---------------------------------------------
        % Phase Ramp Y
        meanXYphdif = mean(phdif,3);
        meanYphdif = mean(meanXYphdif,2);
        meanYphdif = permute(meanYphdif,[2,1]);
        t = [-1 0 1];
        [r,phslp(n,1),pfoffset] = regression(t,meanYphdif);
        
        %---------------------------------------------
        % Phase Ramp Z
        meanXZphdif = squeeze(mean(phdif,1));
        meanZphdif = squeeze(mean(meanXZphdif,1));
        t = [-1 0 1];
        [r,phslp(n,3),pfoffset] = regression(t,meanZphdif);    
        
        %---------------------------------------------
        % Translation
        translations(n,:) = (phslp(n,:)*rad/pi)*vox;
        
        %---------------------------------------------
        % Test
        figure(102); hold on;
        plot(translations(:,1),'b*'); plot(translations0(:,1),'bo');
        plot(translations(:,2),'r*'); plot(translations0(:,2),'ro');
        plot(translations(:,3),'g*'); plot(translations0(:,3),'go');
        xlabel('Trajectory Number'); ylabel('Translation (mm)');
        
    end 
end

%---------------------------------------------
% Add Phase Ramps to Data
%---------------------------------------------
Kmat = Kmat/kmax;
phslp = (translations/vox)*pi;
for n = 1:nproj
    DAT(n,:) = DAT(n,:).*exp(-1i*phslp(n,1)*ones(1,npro).*squeeze(Kmat(n,:,1)));  
    DAT(n,:) = DAT(n,:).*exp(-1i*phslp(n,2)*ones(1,npro).*squeeze(Kmat(n,:,2)));  
    DAT(n,:) = DAT(n,:).*exp(-1i*phslp(n,3)*ones(1,npro).*squeeze(Kmat(n,:,3)));  
end

%---------------------------------------------
% Calculate Translation Mag
%---------------------------------------------
magtranslations = sqrt(translations(:,1).^2 + translations(:,2).^2 + translations(:,3).^2);
stdmagtranslations = std(magtranslations);

%---------------------------------------------
% mean square error
%---------------------------------------------
meansqrerr = sum(sum((translations - translations0).^2))

%---------------------------------------------
% Data to Matrix
%---------------------------------------------
[SampDat] = DatMat2Arr(DAT,IMP.PROJimp.nproj,IMP.PROJimp.npro);

%--------------------------------------------
% Return
%--------------------------------------------
TRANSCOR.SampDat = SampDat;
TRANSCOR.translations0 = translations0;
TRANSCOR.translations = translations;
TRANSCOR.magtranslations = magtranslations;
TRANSCOR.stdmagtranslations = stdmagtranslations;
TRANSCOR.meansqrerr = meansqrerr;

Status2('done','',2);
Status2('done','',3);


