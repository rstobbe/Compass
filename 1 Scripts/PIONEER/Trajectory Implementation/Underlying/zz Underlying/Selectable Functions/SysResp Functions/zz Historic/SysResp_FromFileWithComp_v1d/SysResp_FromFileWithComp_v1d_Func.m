%=====================================================
% 
%=====================================================

function [SYSRESP,err] = SysResp_FromFileWithComp_v1e_Func(SYSRESP,INPUT)

Status2('busy','Include System Response',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJimp = INPUT.PROJimp;
qT0 = INPUT.qT0;
if isfield(INPUT,'GQKSA0')
    GQKSA0 = INPUT.GQKSA0;
end
if isfield(INPUT,'G0')
    G0 = INPUT.G0;
end
SYS = INPUT.SYS;
mode = INPUT.mode;
GSYSMOD = SYSRESP.GSYSMOD;
clear INPUT

%==================================================================
% Delay Gradient (potentially relevant for Siemens which starts the Gradients early)
%==================================================================
if strcmp(mode,'Delay')
    if rem(GSYSMOD.delaygradient,SYS.GradSampBase)
        err.flag = 1;
        err.msg = ['System response model not suitable for ',SYS.System];
        return
    end
    [nProj,~,~] = size(GQKSA0);
    initzeroadd = GSYSMOD.delaygradient/SYS.GradSampBase;
    initzeromat = zeros(nProj,initzeroadd,3);
    SYSRESP.GQKSA = cat(2,initzeromat,GQKSA0);
    SYSRESP.qT = [qT0 qT0(end)+(SYS.GradSampBase:SYS.GradSampBase:SYS.GradSampBase*initzeroadd)/1000];
    SYSRESP.efftrajdel = GSYSMOD.delaygradient/1000;
    Status2('done','',3);
end   
        
%==================================================================
% Compensate 
%==================================================================
if strcmp(mode,'Compensate')

    %---------------------------------------------
    % Add regression delay 
    %---------------------------------------------
    [nProj,~,~] = size(SYSRESP.GQKSA);
    initzeroadd = GSYSMOD.regressiondelay/SYS.GradSampBase;
    initzeromat = zeros(nProj,initzeroadd,3);
    GQKSAtraj = cat(2,initzeromat,SYSRESP.GQKSA);
    qTtraj = [SYSRESP.qT SYSRESP.qT(end)+(SYS.GradSampBase:SYS.GradSampBase:SYS.GradSampBase*initzeroadd)/1000]; 
    G0 = cat(2,initzeromat,G0);
    qT = [qT0 qT0(end)+(SYS.GradSampBase:SYS.GradSampBase:SYS.GradSampBase*initzeroadd)/1000];    
    [GQKSA,~] = ReSampleKSpace_v7a(G0,qT,qT,PROJimp.gamma);
    
    %---------------------------------------------
    % Compensate
    %---------------------------------------------
    G00 = G0;
    Time = (0:GSYSMOD.dwell:qT(end)+1.0);
    GradImp0 = permute(interp1(qT(1:end-1)-0.0001,permute(G0,[2 1 3]),Time,'previous',0),[2 1 3]);
    GradImp = GradImp0;   
    for n = 1:6
        Gfilt = zeros(size(GradImp)); 
        Tfilt = [Time Time(end)+GSYSMOD.dwell]; 
        
        %---------------------------------------------
        % Filter
        %---------------------------------------------
        for d = 1:3
            filt = dsp.FIRFilter;
            reset(filt);
            filt.Numerator = GSYSMOD.filtcoeff(:,d).';                 
            reset(filt);
            Gfilt(:,:,d) = (step(filt,squeeze(GradImp(:,:,d)).')).';                           
        end

        %---------------------------------------------
        % Account for delay in modeling
        %---------------------------------------------   
        backup = round((GSYSMOD.regressiondelay/1000)/GSYSMOD.dwell);               % assuming design for integer
        Gfilt = Gfilt(:,backup+1:end,:);
        Tfilt = Tfilt(1:end-backup); 
        [Kfilt,~] = ReSampleKSpace_v7a(Gfilt,Tfilt,qT,PROJimp.gamma);

        fh = figure(12345); clf;
        fh.Name = 'System Response Compensation';
        fh.NumberTitle = 'off';
        fh.Position = [200 150 1400 800];
        subplot(2,3,1); hold on;
        plot(Time,GradImp0(1,:,1),'b:'); plot(Time,GradImp0(1,:,2),'g:'); plot(Time,GradImp0(1,:,3),'r:'); 
        xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('Gradient Modification');
        
        subplot(2,3,2); hold on;
        plot(qTtraj,GQKSAtraj(1,:,1),'b*'); plot(qTtraj,GQKSAtraj(1,:,2),'g*'); plot(qTtraj,GQKSAtraj(1,:,3),'r*');
        plot(qT,GQKSA(1,:,1),'b*'); plot(qT,GQKSA(1,:,2),'g*'); plot(qT,GQKSA(1,:,3),'r*');
        plot(qT,Kfilt(1,:,1),'b-'); plot(qT,Kfilt(1,:,2),'g-'); plot(qT,Kfilt(1,:,3),'r-');
        xlabel('(ms)'); ylabel('kSpace (1/m)'); title('Output Comparison');

        Kerr = Kfilt-GQKSA;
        subplot(2,3,3); hold on;
        plot(qT,Kerr(1,:,1),'b'); plot(qT,Kerr(1,:,2),'g'); plot(qT,Kerr(1,:,3),'r');
        xlabel('(ms)'); ylabel('kSpace (1/m)'); title('k-Space Output Error'); ylim([-0.05 0.05]);
        
        sz = size(Kerr);
        for i = 1:sz(1)
           for j = 1:sz(3)
               Kerr(i,:,j) = smooth(squeeze(Kerr(i,:,j)),5);
           end
        end

        Gerr = SolveGradQuant_v1b(qT,Kerr,PROJimp.gamma);
        %--
        retreat = 10;
        decay = exp(-(1:retreat)/(retreat/4));
        decaymesh = repmat(decay,nProj,1,3);
        %--
        Gerr(:,length(SYSRESP.qT)+initzeroadd+(-retreat+1:0),:) = Gerr(:,length(SYSRESP.qT)+initzeroadd+(-retreat+1:0),:).*decaymesh;
        Gerr(:,length(SYSRESP.qT)+initzeroadd+1:end,:) = 0;
        subplot(2,3,4); hold on;
        plot(qT(1:end-1),Gerr(1,:,1),'b'); plot(qT(1:end-1),Gerr(1,:,2),'g'); plot(qT(1:end-1),Gerr(1,:,3),'r');
        xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('Gradient Output Error'); ylim([-0.1 0.1]);
         
        G0 = G0-Gerr;
        G0(:,1:initzeroadd,:) = 0;
        GradImp = permute(interp1(qT(1:end-1)-0.0001,permute(G0,[2 1 3]),Time,'previous',0),[2 1 3]);
        subplot(2,3,1); hold on;
        plot(Time,GradImp(1,:,1),'b'); plot(Time,GradImp(1,:,2),'g'); plot(Time,GradImp(1,:,3),'r'); 
        
        subplot(2,3,5); hold on;
        Galt = G00-G0;
        plot(qT(1:end-1),Galt(1,:,1),'b'); plot(qT(1:end-1),Galt(1,:,2),'g'); plot(qT(1:end-1),Galt(1,:,3),'r');
        xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('Gradient Alteration'); ylim([-1 1]);  
    end
    SYSRESP.Gcomp = G0(:,initzeroadd+1:end,:);
    SYSRESP.Tcomp = qT0;
    SYSRESP.efftrajdel = GSYSMOD.delaygradient/1000;
    Status2('done','',3); 
end

%==================================================================
% Analyze
%==================================================================
if strcmp(mode,'Analyze')

    %---------------------------------------------
    % Add regression delay 
    %---------------------------------------------
    [nProj,~,~] = size(G0);
    initzeroadd = GSYSMOD.regressiondelay/SYS.GradSampBase;
    initzeromat = zeros(nProj,initzeroadd,3);
    G0 = cat(2,initzeromat,G0);
    qT = [qT0 qT0(end)+(SYS.GradSampBase:SYS.GradSampBase:SYS.GradSampBase*initzeroadd)/1000];    
    
    Time = (0:GSYSMOD.dwell:qT(end)+1.0);
    GradImp = permute(interp1(qT(1:end-1)-0.0001,permute(G0,[2 1 3]),Time,'previous',0),[2 1 3]); 
    Gfilt = zeros(size(GradImp)); 
    Tfilt = [Time Time(end)+GSYSMOD.dwell]; 
    
    %---------------------------------------------
    % Filter
    %---------------------------------------------
    for d = 1:3
        filt = dsp.FIRFilter;
        reset(filt);
        filt.Numerator = GSYSMOD.filtcoeff(:,d).';                 
        reset(filt);
        Gfilt(:,:,d) = (step(filt,squeeze(GradImp(:,:,d)).')).';                           
    end

    backup = round((GSYSMOD.regressiondelay/1000)/GSYSMOD.dwell);               % assuming design for integer
    Gfilt = Gfilt(:,backup+1:end,:);    
    SYSRESP.Grecon = Gfilt;  
    SYSRESP.Trecon = Tfilt(1:end-backup) - GSYSMOD.regressiondelay/1000;
    SYSRESP.efftrajdel = GSYSMOD.delaygradient/1000;
    Status2('done','',3);
end
