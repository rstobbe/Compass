%===========================================================================================
%
%===========================================================================================

function [SDC,SDCS,SCRPTipt,err] = Iterate_GridBased_v1a(Kmat,PROJdgn,PROJimp,iSDC,DOV,KRNprms,SDCS,SCRPTipt,err)


Vis = 'Off';

IT.Convfunc = 'mFCMexSingleR_v3';
IT.Accfunc = SCRPTipt(strcmp('Accfunc',{SCRPTipt.labelstr})).entrystr;
IT.Anlzfunc = SCRPTipt(strcmp('Anlzfunc',{SCRPTipt.labelstr})).entrystr;
IT.Breakfunc = SCRPTipt(strcmp('Breakfunc',{SCRPTipt.labelstr})).entrystr;
convfunc = str2func(IT.Convfunc);
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
KRNprms.W = KRNprms.W*SDCS.SubSamp;
KRNprms.res = KRNprms.res*SDCS.SubSamp;
KRNprms.iKern = 1/KRNprms.res;
CONVprms.chW = ceil((KRNprms.W-2)/2);                    % with mFCMexSingleR_v3
StatLev = 3;
SDC = iSDC;
SDC = SDCMat2Arr(SDC,PROJdgn.nproj,PROJimp.npro);
DOV = SDCMat2Arr(DOV,PROJdgn.nproj,PROJimp.npro);

for j = 1:500

    if strcmp(Vis,'On');
        figure(50);
        [ArrKmat] = KMat2Arr(Kmat,PROJdgn.nproj,PROJimp.npro);
        rads = (sqrt(ArrKmat(:,1).^2 + ArrKmat(:,2).^2 + ArrKmat(:,3).^2))/SDCS.compkmax;
        plot(rads,SDC,'r*');
        title('SDC Values at Sampling Point Locations');
    end    
    
    Status2('busy',['Iteration: ',num2str(j)],2);   
    [CV,~,~] = convfunc(Ksz,Kx,Ky,Kz,KRNprms,SDC,CONVprms,StatLev);         
    
    if strcmp(Vis,'On');
        load('ColorMap2');
        figure(501); 
        imshow(squeeze(CV(:,:,C)),[0 max(SDCS.CTF.SDconv)]);
        truesize(gcf,[250 250]);
        colormap(mycolormap); 
        caxis([0 max(SDCS.CTF.SDconv)]);
        colorbar;
        axis off;
        axis image;
        figure(502); 
        imshow(squeeze(CV(C,:,:)),[0 max(SDCS.CTF.SDconv)]);
        truesize(gcf,[250 250]);
        colormap(mycolormap); 
        caxis([0 max(SDCS.CTF.SDconv)]);
        colorbar;
        axis off;
        axis image;
    end  
    
    Status2('busy','Interpolate Sampling Density at Sampling Points',3);
    W = zeros(PROJdgn.nproj*PROJimp.npro,1);                                               
    for n = 1:PROJdgn.nproj*PROJimp.npro
        W(n) = trilin_interp(CV,Kx(n),Ky(n),Kz(n));                           
    end
        
    acc = accfunc(j);
    SDC = ((DOV ./ W).^acc) .* SDC;                                      
    SDC(SDC > max(SDCS.CTF.SDconv)) = max(SDCS.CTF.SDconv);
    SDC(SDC < 0) = 0.001*max(SDCS.CTF.SDconv);  
    E = 1 - (DOV ./ W);
    SDCS = anlzfunc(SDCS,E,PROJdgn,PROJimp,SDC,j);    
    
    if strcmp(Vis,'On');
        figure(52); clf(52); hold on;
        plot(rads,W,'r*');
        plot(SDCS.CTF.rconv,SDCS.CTF.SDconv,'b-');
        title('Output Values at Sampling Point Locations');
        
        figure(53);
        plot(rads,E*100,'r*');
        title('Error (%) at Sampling Point Locations');
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

