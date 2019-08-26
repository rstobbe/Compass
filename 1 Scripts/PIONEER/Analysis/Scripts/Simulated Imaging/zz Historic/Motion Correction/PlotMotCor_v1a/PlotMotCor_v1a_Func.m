%=========================================================
% 
%=========================================================

function [OUTPUT,err] = PlotMotCor_v1a_Func(INPUT)

Status('busy','Plot Montage');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

OUTPUT = struct();
%---------------------------------------------
% Get Input
%---------------------------------------------
MOTCOR = INPUT.MOTCOR;
PLOT = INPUT.PLOT;

%---------------------------------------------
% Translation Correction Compare
%---------------------------------------------
trans = 0;
if trans == 1
    TRANSCOR = MOTCOR.TRANSCOR;
    translations = TRANSCOR.translations;
    translations0 = TRANSCOR.translations0;

    figure(100); hold on
    plot(translations(:,1),'b*'); plot(translations0(:,1),'bo');
    plot(translations(:,2),'r*'); plot(translations0(:,2),'ro');
    plot(translations(:,3),'g*'); plot(translations0(:,3),'go');
    xlim([0 33]);
    xlabel('Trajectory Number');
    ylabel('Translation (mm)');
end

%---------------------------------------------
% Rotation Correction Compare
%---------------------------------------------
rot = 1;
if rot == 1
    ROTCOR = MOTCOR.ROTCOR;
    rotcor = ROTCOR.rotcor;
    rot0 = ROTCOR.rot0;
    meansqrerr = ROTCOR.meansqrerr

    figure(100); hold on
    plot(rotcor(:,1),'b*'); plot(rot0(:,1),'bo');
    plot(rotcor(:,2),'r*'); plot(rot0(:,2),'ro');
    plot(rotcor(:,3),'g*'); plot(rot0(:,3),'go');
    xlim([0 33]); ylim([-25 25]);
    xlabel('Trajectory Number');
    ylabel('Rotation (degrees)');
end

%---------------------------------------------
% kShift Correction Compare
%---------------------------------------------
kshft = 0;
if kshft == 1
    KSHFTCOR = MOTCOR.KSHFTCOR;
    kshfts = KSHFTCOR.kshfts;
    kshfts0 = KSHFTCOR.kshfts0;

    kshfts = kshfts*0.24;
    kshfts0 = kshfts0*0.24;
    
    figure(100); hold on
    plot(kshfts(:,1),'b*'); plot(-kshfts0(:,1),'bo');
    plot(kshfts(:,2),'r*'); plot(-kshfts0(:,2),'ro');
    plot(kshfts(:,3),'g*'); plot(-kshfts0(:,3),'go');
    xlim([0 33]); ylim([-4 4]);
    xlabel('Trajectory Number');
    ylabel('k-Space Shift (1/FoV)');
end


outstyle = 1;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2 1.5]);
    set(gca,'fontsize',10,'fontweight','bold');
    box on
end
