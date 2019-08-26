%===========================================================================================
% (mG) - convolution onto grid
% (02) - 
% (a) -
% (v1) - 
%===========================================================================================

function [SDC,SDCS,SCRPTipt,err] = mG02a_v1(Kmat,PROJdgn,PROJimp,iSDC,CTF,KRNprms,SDCS,SCRPTipt,err)

visuals = 1;

SDCS.DOVFunc = SCRPTipt(strcmp('DOVFunc',{SCRPTipt.labelstr})).entrystr;
SDCS.ConvFunc = 'mFCMexSingleR_v3';
SDCS.SubSamp = str2double(SCRPTipt(strcmp('SubSamp',{SCRPTipt.labelstr})).entrystr);
SDCS.AccFunc = SCRPTipt(strcmp('AccFunc',{SCRPTipt.labelstr})).entrystr;
SDCS.AccVal = str2double(SCRPTipt(strcmp('AccVal',{SCRPTipt.labelstr})).entrystr);
SDCS.AnlzFunc = SCRPTipt(strcmp('AnlzFunc',{SCRPTipt.labelstr})).entrystr;
SDCS.BreakFunc = SCRPTipt(strcmp('BreakFunc',{SCRPTipt.labelstr})).entrystr;

dovfunc = str2func(SDCS.DOVFunc);
convfunc = str2func(SDCS.ConvFunc);
accfunc = str2func(SDCS.AccFunc);
anlzfunc = str2func(SDCS.AnlzFunc);
breakfunc = str2func(SDCS.BreakFunc);

%--------------------------------------
% Find Convolved TF Values
%--------------------------------------
Status2('busy','Find Convolved TF Values at Sampling Point Locations',2);
kmax = CTF.kmax;
rKmag = ((Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2).^(1/2))/kmax;
akmax = max(rKmag(:))*kmax;

DOV = zeros(size(rKmag),'single');
for n = 1:PROJdgn.nproj
    DOV(n,:) = interp1(CTF.rconv,CTF.SDconv,rKmag(n,:));
    if not(rem(n,100));
        Status2('busy',['Projection Number: ',num2str(n)],3);
    end
end

if visuals == 1
    figure(100); clf(100); hold on;
    plot(rKmag(:),DOV(:),'r*');
    plot(CTF.rconv,CTF.SDconv,'b-');
    title('Required Values at Sampling Point Locations');
end


%--------------------------------------
% Normalize Projections to Grid
%--------------------------------------
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(Kmat,PROJdgn.nproj,PROJimp.npro,akmax,PROJdgn.kstep,KRNprms.W,SDCS.SubSamp,'M2A');
radtest = (((Kx(:)-C).^2 + (Ky(:)-C).^2 + (Kz(:)-C).^2).^(1/2));

%--------------------------------------
% Setup
%--------------------------------------
KRNprms.W = KRNprms.W*SDCS.SubSamp;
KRNprms.res = KRNprms.res*SDCS.SubSamp;
KRNprms.iKern = 1/KRNprms.res;
CONVprms.chW = ceil((KRNprms.W-2)/2);                    % with mFCMexSingleR_v3
StatLev = 3;
SDC = iSDC;
SDC = SDCMat2Arr(SDC,PROJdgn.nproj,PROJimp.npro);
DOV = SDCMat2Arr(DOV,PROJdgn.nproj,PROJimp.npro);

for j = 1:500

    if visuals == 1
        figure(99); clf(99); hold on;
        [ArrKmat] = KMat2Arr(Kmat,PROJdgn.nproj,PROJimp.npro);
        rads = (sqrt(ArrKmat(:,1).^2 + ArrKmat(:,2).^2 + ArrKmat(:,3).^2))/kmax;
        plot(rads,SDC,'r*');
        title('SDC Values at Sampling Point Locations');
    end    
    
    Status2('busy',['Iteration: ',num2str(j)],2);   
    [CV,~,~] = convfunc(Ksz,Kx,Ky,Kz,KRNprms,SDC,CONVprms,StatLev);         
    
    Status2('busy','Interpolate Sampling Density at Sampling Points',3);
    W = zeros(PROJdgn.nproj*PROJimp.npro,1);                                               
    for n = 1:PROJdgn.nproj*PROJimp.npro
        W(n) = trilin_interp(CV,Kx(n),Ky(n),Kz(n));                           
    end
    
    acc = accfunc(j);
    SDC = ((DOV ./ W).^acc) .* SDC;                                      
    SDC(SDC > max(CTF.SDconv)) = max(CTF.SDconv);
    SDC(SDC < 0) = 0.001*max(CTF.SDconv);  
    E = 1 - (DOV ./ W);
    SDCS = anlzfunc(SDCS,E,PROJdgn,PROJimp,SDC,j);    
    
    if visuals == 1
        figure(100); clf(100); hold on;
        plot(rads,W,'r*');
        plot(CTF.rconv,CTF.SDconv,'b-');
        title('Output Values at Sampling Point Locations');
        
        figure(101); clf(101); hold on;
        plot(rads,E*100,'r*');
        title('Error (%) at Sampling Point Locations');
    end

    [stop,SDCS] = breakfunc(SCRPTipt,SDCS,E,PROJdgn,PROJimp,SDC,j);
    if stop == 1
        break
    end 
end
SDCS.it = j;
Status2('done','',2);

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Stop Reason','0output',SDCS.stopping,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Iterations','0output',num2str(SDCS.it),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Centre Error','0output',num2str(SDCS.CErr(length(SDCS.CErr))),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Average Error','0output',num2str(SDCS.AErr(length(SDCS.AErr))),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Sampling Eff','0output',num2str(SDCS.Eff(length(SDCS.Eff))),'0numout');


