%=========================================================
% (v1a)
%
%=========================================================

function [SDC,SDCS,SCRPTipt,err] = Iterate_DblConv_v1a(Kmat,PROJdgn,PROJimp,iSDC,DOV,KRNprms,SDCS,SCRPTipt,err)

Vis = SCRPTipt(strcmp('IterationVisuals',{SCRPTipt.labelstr})).entrystr;
if iscell(Vis)
    Vis = SCRPTipt(strcmp('IterationVisuals',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('CTFvis',{SCRPTipt.labelstr})).entryvalue};
end

IT.S2GConvfunc = 'mFCMexSingleR_v3';
IT.G2SConvfunc = 'mG2SMexSingleR_v3';
IT.Accfunc = SCRPTipt(strcmp('Accfunc',{SCRPTipt.labelstr})).entrystr;
IT.Anlzfunc = SCRPTipt(strcmp('Anlzfunc',{SCRPTipt.labelstr})).entrystr;
IT.Breakfunc = SCRPTipt(strcmp('Breakfunc',{SCRPTipt.labelstr})).entrystr;
S2Gconvfunc = str2func(IT.S2GConvfunc);
G2Sconvfunc = str2func(IT.G2SConvfunc);
accfunc = str2func(IT.Accfunc);
anlzfunc = str2func(IT.Anlzfunc);
breakfunc = str2func(IT.Breakfunc);

%--------------------------------------
% Normalize Projections to Grid
%--------------------------------------
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(Kmat,PROJdgn.nproj,PROJimp.npro,SDCS.actkmax,PROJdgn.kstep,KRNprms.W,SDCS.SubSamp,'M2A');
normrad = (((Kx(:)-C).^2 + (Ky(:)-C).^2 + (Kz(:)-C).^2).^(1/2));
maxnormrad = max(normrad(:));

%--------------------------------------
% Setup
%--------------------------------------
KRNprms.Kern = KRNprms.rootKern;
CONVprms.chW = ceil((KRNprms.W-2)/2);                    % with mFCMexSingleR_v3
StatLev = 3;
SDC = iSDC;
SDC = SDCMat2Arr(SDC,PROJdgn.nproj,PROJimp.npro);
DOV = SDCMat2Arr(DOV,PROJdgn.nproj,PROJimp.npro);

for j = 1:500

    if strcmp(Vis,'On');
        figure(51);
        [ArrKmat] = KMat2Arr(Kmat,PROJdgn.nproj,PROJimp.npro);
        rads = (sqrt(ArrKmat(:,1).^2 + ArrKmat(:,2).^2 + ArrKmat(:,3).^2))/SDCS.compkmax;
        plot(rads,SDC,'r*');
        title('SDC Values at Sampling Point Locations'); xlabel('relative radial dimension');
    end    
    
    Status2('busy',['Iteration: ',num2str(j)],2);   
    [CV,~,~] = S2Gconvfunc(Ksz,Kx,Ky,Kz,KRNprms,SDC,CONVprms,StatLev);         
        
    Status2('busy',['Iteration: ',num2str(j)],2);   
    [W,~,~] = G2Sconvfunc(Ksz,Kx,Ky,Kz,KRNprms,CV,CONVprms,StatLev);  
        
    test = W(1:100)
    
    acc = accfunc(j);
    SDC = ((DOV ./ W).^acc) .* SDC;                                      
    %SDC(SDC > max(SDCS.CTF.ConvTF(:))) = max(SDCS.CTF.ConvTF(:));
    SDC(SDC < 0) = 0.001*max(SDCS.CTF.ConvTF(:));  
    E = 1 - (DOV ./ W);
    SDCS = anlzfunc(SDCS,E,PROJdgn,PROJimp,SDC,j);    
    
    if strcmp(Vis,'On');
        figure(52); clf(52); hold on;
        plot(rads,W,'r*');
        
        matsize = size(SDCS.CTF.ConvTF,3);
        if matsize > 1
            plot(SDCS.CTF.rconv,squeeze(SDCS.CTF.ConvTF(((length(SDCS.CTF.rconv)+1)/2),((length(SDCS.CTF.rconv)+1)/2),:)),'b-*');
            plot(SDCS.CTF.rconv,squeeze(SDCS.CTF.ConvTF(((length(SDCS.CTF.rconv)+1)/2),:,((length(SDCS.CTF.rconv)+1)/2))),'g-*');
        else
            plot(SDCS.CTF.rconv,SDCS.CTF.ConvTF,'b-*');
        end
        title('Output Values at Sampling Point Locations'); xlabel('relative radial dimension');
        
        figure(53);
        plot(rads,E*100,'r*');
        title('Error (%) at Sampling Point Locations'); xlabel('relative radial dimension');
    end

    [stop,SDCS] = breakfunc(SCRPTipt,SDCS,E,PROJdgn,PROJimp,SDC,j);
    if stop == 1
        break
    end 
end
SDCS.it = j;
SDCS.IT = IT;

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Stop Reason','0output',SDCS.stopping,'0text');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Iterations','0output',num2str(SDCS.it),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Centre Error','0output',num2str(SDCS.CErr(length(SDCS.CErr))),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Average Error','0output',num2str(SDCS.AErr(length(SDCS.AErr))),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Sampling Eff','0output',num2str(SDCS.Eff(length(SDCS.Eff))),'0numout');

Status2('done','',2);

