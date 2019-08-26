%===========================================================================================
% (mN) - convolution onto neighbors
% (06) -
% (a) -
% (v1) - 
%===========================================================================================

function [SDC,SDCS,SDCipt,abort,abortflag] = mN06a_v1(Kmat,iSDC,AIDrp,AIDimp,PROJdgn,SDCS,SDCipt,SDconv,KRNprms,visuals)

SDCS.DOVFunc = SDCipt(strcmp('DOVFunc',{SDCipt.labelstr})).entrystr;
SDCS.FindFunc = SDCipt(strcmp('FindFunc',{SDCipt.labelstr})).entrystr;
SDCS.KernValFunc = SDCipt(strcmp('KernValFunc',{SDCipt.labelstr})).entrystr;
SDCS.ConvFunc = SDCipt(strcmp('ConvFunc',{SDCipt.labelstr})).entrystr;
SDCS.AccFunc = SDCipt(strcmp('AccFunc',{SDCipt.labelstr})).entrystr;
SDCS.AnlzFunc = SDCipt(strcmp('AnlzFunc',{SDCipt.labelstr})).entrystr;
SDCS.BreakFunc = SDCipt(strcmp('BreakFunc',{SDCipt.labelstr})).entrystr;

dovfunc = str2func(SDCS.DOVFunc);
findfunc = str2func(SDCS.FindFunc);
kernvalfunc = str2func(SDCS.KernValFunc);
convfunc = str2func(SDCS.ConvFunc);
accfunc = str2func(SDCS.AccFunc);
anlzfunc = str2func(SDCS.AnlzFunc);
breakfunc = str2func(SDCS.BreakFunc);

Status2('busy','Find Desired Convolved Output Values at Sampling Point Locations',2);
[DOV,SDCS,abort,abortflag] = dovfunc(Kmat,AIDrp,AIDimp,PROJdgn,SDCS,SDCipt,SDconv,visuals);
if abortflag == 1
    return
end

Status2('busy','Find Neighbors',2);
[NGH,abort,abortflag] = findfunc(Kmat,SDCS.W,AIDrp);
if abortflag == 1
    return
end

Status2('busy','Solve Kernel Values at Neighbour Locations',2);
[KrnVals,abort,abortflag] = kernvalfunc(NGH,Kmat,KRNprms,SDCS,AIDrp);
if abortflag == 1
    return
end

SDC = iSDC;
for j = 1:2500

    if visuals == 0
        figure(99); clf(99); hold on;
        [ArrKmat] = KMat2Arr(Kmat,AIDrp.nproj,AIDrp.npro);
        rads = (sqrt(ArrKmat(:,1).^2 + ArrKmat(:,2).^2 + ArrKmat(:,3).^2))/AIDimp.impkmax;
        [ArrSDC] = DatMat2Arr(SDC,AIDrp.nproj,AIDrp.npro);
        plot(rads,ArrSDC,'r*');
        title('SDC Values at Sampling Point Locations');
    end
    
    Status2('busy',['Iteration: ',num2str(j)],2);
    CV = convfunc(NGH,KrnVals,SDC,AIDrp);    

    acc = accfunc(j);
    SDC = ((DOV ./ CV).^acc) .* SDC;                                      
    SDC(SDC > max(SDconv)) = max(SDconv);
    SDC(SDC < 0) = 0.001*max(SDconv);  
    E = 1 - (DOV ./ CV);
    SDCS = anlzfunc(SDCS,E,AIDrp,SDC,j);

    if visuals == 0
        figure(100); clf(100); hold on;
        plot(SDCS.ConvTFRad,SDconv,'b-*');
        [ArrCV] = DatMat2Arr(CV,AIDrp.nproj,AIDrp.npro);
        plot(rads,ArrCV,'r*');
        title('Output Values at Sampling Point Locations');
        
        figure(101); clf(101); hold on;
        [ArrE] = DatMat2Arr(E,AIDrp.nproj,AIDrp.npro);
        plot(rads,ArrE*100,'r*');
        title('Error (%) at Sampling Point Locations');
    end

    [stop,SDCS] = breakfunc(SDCipt,SDCS,E,AIDrp,SDC,j);
    if stop == 1
        break
    end    
end
SDCS.it = j;
Status2('done','',2);

SDC = SDCMat2Arr(SDC,AIDrp.nproj,AIDrp.npro);

M = length(SDCipt)+1;
n = M;
SDCipt(n).number = n;
SDCipt(n).labelstyle = '0output';
SDCipt(n).labelstr = 'Stop Reason';
SDCipt(n).entrystr = SDCS.stopping;
SDCipt(n).entrystyle = '0text';

n = n+1;
SDCipt(n).number = n;
SDCipt(n).labelstyle = '0output';
SDCipt(n).labelstr = 'Iterations';
SDCipt(n).entrystr = num2str(SDCS.it);
SDCipt(n).entrystyle = '0text';

n = n+1;
SDCipt(n).number = n;
SDCipt(n).labelstyle = '0output';
SDCipt(n).labelstr = 'Centre Error';
SDCipt(n).entrystr = num2str(SDCS.CErr(length(SDCS.CErr)));
SDCipt(n).entrystyle = '0text';

n = n+1;
SDCipt(n).number = n;
SDCipt(n).labelstyle = '0output';
SDCipt(n).labelstr = 'Average Error';
SDCipt(n).entrystr = num2str(SDCS.AErr(length(SDCS.AErr)));
SDCipt(n).entrystyle = '0text';

n = n+1;
SDCipt(n).number = n;
SDCipt(n).labelstyle = '0output';
SDCipt(n).labelstr = 'Sampling Eff';
SDCipt(n).entrystr = num2str(SDCS.Eff(length(SDCS.Eff)));
SDCipt(n).entrystyle = '0text';

