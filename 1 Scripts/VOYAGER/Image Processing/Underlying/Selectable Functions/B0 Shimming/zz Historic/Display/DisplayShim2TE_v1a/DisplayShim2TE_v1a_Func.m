%===========================================
% 
%===========================================

function [DISP,err] = DisplayShim2TE_v1a_Func(DISP,INPUT)

Status('busy','Display Shims');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
AbsIm = INPUT.AbsIm;
fMap = INPUT.fMap;
Mask = INPUT.Mask;
Prof = INPUT.Prof;
PLOT = DISP.PLOT;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if fMap == 0
    err.flag = 1;
    err.msg = 'Incompatible Display Function';
    return
end

%---------------------------------------------
% Plot Full Original B0 Map
%---------------------------------------------
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Im = AbsIm;
INPUT.fMap = fMap;
INPUT.dispwid = DISP.dispfullwid;
INPUT.orient = DISP.orient;
INPUT.inset = DISP.inset;
INPUT.disptype = 'DualDispwMask';
INPUT.figno = 1000;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
fulldispwid = PLOT.dispwid;
clear INPUT;
if not(strcmp(fulldispwid,'None') || strcmp(fulldispwid,'Off'))
    title('Full Original B0 Map');
end

%---------------------------------------------
% Plot Full Fitted B0 Map
%---------------------------------------------
if not(isempty(Prof) || strcmp(fulldispwid,'None') || strcmp(fulldispwid,'Off'))
    func = str2func([DISP.plotfunc,'_Func']);  
    INPUT.Im = AbsIm;
    INPUT.fMap = (fMap-Prof);
    INPUT.dispwid = num2str(fulldispwid);
    INPUT.orient = DISP.orient;
    INPUT.inset = DISP.inset;
    INPUT.disptype = 'DualDispwMask';
    INPUT.figno = 1001;
    [PLOT,err] = func(PLOT,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    title('Full Fitted B0 Map');
end

%---------------------------------------------
% Histogram (full)
%---------------------------------------------
if not(isempty(Prof) || strcmp(fulldispwid,'None') || strcmp(fulldispwid,'Off'))
    test = fMap(:);
    test = test(not(isnan(test)));
    test = -test;       % neg sense rotation
    figure(1002); hold on;
    %[nels,cens] = hist(test,1000);
    %cens = (-fulldispwid:0.5:fulldispwid);
    %cens = (-fulldispwid:1:fulldispwid);
    %cens = (-fulldispwid:2:fulldispwid);
    cens = (-fulldispwid:4:fulldispwid);
    [nels,cens] = hist(test,cens);
    nels = smooth(nels,5,'moving');
    plot(cens,nels,'b');
    xlabel('Off Resonance (Hz)'); ylabel('Voxels');
    title('Full Histogram');
end

%---------------------------------------------
% Histogram (full)
%---------------------------------------------
if not(isempty(Prof) || strcmp(fulldispwid,'None') || strcmp(fulldispwid,'Off'))
    test = (fMap(:)-Prof(:));
    test = test(not(isnan(test)));
    test = -test;       % neg sense rotation
    figure(1002); hold on;
    [nels,cens] = hist(test,cens);
    nels = smooth(nels,5,'moving');
    plot(cens,nels,'r');
end

%======================================================

if not(isempty(Mask))
    %---------------------------------------------
    % Plot Masked Original B0 Map
    %---------------------------------------------
    func = str2func([DISP.plotfunc,'_Func']);  
    INPUT.Im = AbsIm;
    INPUT.fMap = fMap.*Mask;
    INPUT.dispwid = DISP.dispmaskwid;
    INPUT.orient = DISP.orient;
    INPUT.inset = DISP.inset;
    INPUT.disptype = 'DualDispwMask';
    INPUT.figno = 2000;
    [PLOT,err] = func(PLOT,INPUT);
    if err.flag
        return
    end
    maskdispwid = PLOT.dispwid;
    clear INPUT;
    if not(strcmp(maskdispwid,'None') || strcmp(maskdispwid,'Off'))
        title('Masked Original B0 Map');
    end
    
    %---------------------------------------------
    % Plot Masked Fitted B0 Map
    %---------------------------------------------
    if not(isempty(Prof) || strcmp(maskdispwid,'None') || strcmp(maskdispwid,'Off'))   
        func = str2func([DISP.plotfunc,'_Func']);  
        INPUT.Im = AbsIm;
        INPUT.fMap = (fMap-Prof).*Mask;
        INPUT.dispwid = num2str(maskdispwid);
        INPUT.orient = DISP.orient;
        INPUT.inset = DISP.inset;
        INPUT.disptype = 'DualDispwMask';
        INPUT.figno = 2001;
        [PLOT,err] = func(PLOT,INPUT);
        if err.flag
            return
        end
        clear INPUT;
        title('Masked Fitted B0 Map');
    end

    %---------------------------------------------
    % Histogram
    %---------------------------------------------
    if not(isempty(Prof) || strcmp(maskdispwid,'None') || strcmp(maskdispwid,'Off'))
        test = fMap(:).*Mask(:);
        test = test(not(isnan(test)));
        test = -test;       % neg sense rotation
        figure(2002); hold on;
        %[nels,cens] = hist(test,1000);
        %cens = (-1.25*maskdispwid:0.25:1.25*maskdispwid);
        %cens = (-1.25*maskdispwid:0.5:1.25*maskdispwid);
        %cens = (-1.25*maskdispwid:1:1.25*maskdispwid);
        cens = (-1.25*maskdispwid:2:1.25*maskdispwid);
        [nels,cens] = hist(test,cens);
        nels = smooth(nels,5,'moving');
        plot(cens,nels,'b');
        xlabel('Off Resonance (Hz)'); ylabel('Voxels');
        title('Masked Histogram');
    end

    %---------------------------------------------
    % Histogram
    %---------------------------------------------
    if not(isempty(Prof) || strcmp(maskdispwid,'None') || strcmp(maskdispwid,'Off'))      
        test = (fMap(:)-Prof(:)).*Mask(:);
        test = test(not(isnan(test)));
        test = -test;       % neg sense rotation
        figure(2002); hold on;
        [nels,cens] = hist(test,cens);
        nels = smooth(nels,5,'moving');
        plot(cens,nels,'r');
    end
end


Status2('done','',2);
Status2('done','',3);

