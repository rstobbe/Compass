%=====================================================
% 
%=====================================================

function [SYSRESP,err] = SysResp_FromFile_v1a_Func(SYSRESP,INPUT)

Status2('busy','Include System Response',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G0;
T = INPUT.T;
SYS = INPUT.SYS;
mode = INPUT.mode;
GSYSMOD = SYSRESP.GSYSMOD;
[nProj,~,~] = size(G);
clear INPUT

%==================================================================
% Compensate (Add a delay - Siemens starts the gradients early)
%==================================================================
if strcmp(mode,'Compensate')
    if rem(GSYSMOD.delaygradient,SYS.GradSampBase)
        err.flag = 1;
        err.msg = ['System response model not suitable for ',SYS.System];
        return
    end
    initzeroadd = GSYSMOD.delaygradient/SYS.GradSampBase;
    initzeromat = zeros(nProj,initzeroadd,3);
    SYSRESP.Gcomp = cat(2,initzeromat,G);
    SYSRESP.Tcomp = [T T(end)+SYS.GradSampBase/1000*(1:initzeroadd)];
    SYSRESP.efftrajdel = GSYSMOD.efftrajdel;                                  % for calculating end of trajectory
    Status2('done','',3);
    return
end

%==================================================================
% Compensate
%==================================================================
if strcmp(mode,'Analyze')

    %---------------------------------------------
    % Interpolate Gradients (at appropriate time)
    %---------------------------------------------
    Time = (0:GSYSMOD.dwell:T(end)+0.5);
    GradImp = permute(interp1(T(1:end-1)-GSYSMOD.delaygradient/1000-0.0001,permute(G,[2 1 3]),Time,'previous',0),[2 1 3]);

    %---------------------------------------------
    % Plot
    %---------------------------------------------
    %N = 1;
    %fh = figure(1234); hold on; 
    %fh.Position = [400 150 1000 800];
    %plot(Time,GradImp(N,:,1),'k*','linewidth',1);
    %xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)');

    Grecon = zeros(size(GradImp));    
    for d = 1:3
        %---------------------------------------------
        % Filter
        %---------------------------------------------
        filt = dsp.FIRFilter;
        reset(filt);
        filt.Numerator = GSYSMOD.filtcoeff(:,d).';                 
        reset(filt);
        Grecon(:,:,d) = (step(filt,squeeze(GradImp(:,:,d)).')).';
        %plot(Time,Grecon(N,:,1),'r-','linewidth',1);
        SYSRESP.Grecon = Grecon;
        SYSRESP.Trecon = [Time Time(end)+GSYSMOD.dwell];                            
    end
    SYSRESP.efftrajdel = GSYSMOD.efftrajdel; 
    Status2('done','',3);
end
