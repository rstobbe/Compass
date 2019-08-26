%=========================================================
% (v2a)
%    - no subsampling
%=========================================================

function [SDC,SDCS,SCRPTipt,err] = Iterate_InterpError_v2a(Kmat,PROJdgn,PROJimp,iSDC,CTF,KRNprms,SDCS,SCRPTipt,err)

Vis = SCRPTipt(strcmp('IterationVisuals',{SCRPTipt.labelstr})).entrystr;
if iscell(Vis)
    Vis = SCRPTipt(strcmp('IterationVisuals',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('CTFvis',{SCRPTipt.labelstr})).entryvalue};
end

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
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(Kmat,PROJdgn.nproj,PROJimp.npro,SDCS.compkmax,PROJdgn.kstep,KRNprms.W,1,'M2A');

%--------------------------------------
% Setup
%--------------------------------------
KRNprms.W = KRNprms.W;
KRNprms.res = KRNprms.res;
KRNprms.iKern = 1/KRNprms.res;
CONVprms.chW = ceil((KRNprms.W-2)/2);                    % with mFCMexSingleR_v3

StatLev = 3;
SDC = iSDC;
SDC = SDCMat2Arr(SDC,PROJdgn.nproj,PROJimp.npro);
DOV = CTF.ConvTF;

for j = 1:500
    Status2('busy',['Iteration: ',num2str(j)],2);  
    [CV,~,~] = convfunc(Ksz,Kx,Ky,Kz,KRNprms,SDC,CONVprms,StatLev);       
    
    if strcmp(Vis,'On');
        figure(51);
        [ArrKmat] = KMat2Arr(Kmat,PROJdgn.nproj,PROJimp.npro);
        rads = (sqrt(ArrKmat(:,1).^2 + ArrKmat(:,2).^2 + ArrKmat(:,3).^2))/SDCS.compkmax;
        plot(rads,SDC,'r*');
        title('SDC Values at Sampling Point Locations'); xlabel('relative radial dimension');
      
        figure(52); clf; hold on;
        plot(squeeze(DOV(C,C,:)),'b-*');
        plot(squeeze(CV(C,C,:)),'r*');
        figure(53); clf; hold on;
        plot(squeeze(DOV(:,C,C)),'b-*');
        plot(squeeze(CV(:,C,C)),'r*');
    end
        
    rErr = CV./DOV;
    
    Status2('busy','Interpolate rErr',3);
    rErri = zeros(PROJdgn.nproj*PROJimp.npro,1);                                               
    for n = 1:PROJdgn.nproj*PROJimp.npro
        rErri(n) = trilin_interp(rErr,Kx(n),Ky(n),Kz(n));                           
    end
        
    acc = accfunc(j);
    SDC = ((1 ./ rErri).^acc) .* SDC;                                      
    %SDC(SDC > max(DOV)) = max(DOV);
    SDC(SDC < 0) = 0.001*max(DOV(:));  

    %[stop,SDCS] = breakfunc(SCRPTipt,SDCS,E,PROJdgn,PROJimp,SDC,j);   
    stop = 0;    
    if j == 20
        stop = 1;
    end
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

