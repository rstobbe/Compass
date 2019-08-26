%=====================================================
%
%=====================================================

function [PROJimp,GQNT,SCRPTipt,err] = QVecSlv_TPI_v1a(PROJdgn,PROJimp,GQNT,SCRPTipt,err)

PROJimp.qvecfunc = SCRPTipt(strcmp('QVecfunc',{SCRPTipt.labelstr})).entrystr;
destwseg = str2double(SCRPTipt(strcmp('twGseg (ms)',{SCRPTipt.labelstr})).entrystr);
slvprior1 = SCRPTipt(strcmp('Solve_Priority1',{SCRPTipt.labelstr})).entrystr;
if iscell(slvprior1)
    slvprior1 = SCRPTipt(strcmp('Solve_Priority1',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Solve_Priority1',{SCRPTipt.labelstr})).entryvalue};
end
slvprior2 = SCRPTipt(strcmp('Solve_Priority2',{SCRPTipt.labelstr})).entrystr;
if iscell(slvprior2)
    slvprior2 = SCRPTipt(strcmp('Solve_Priority2',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Solve_Priority2',{SCRPTipt.labelstr})).entryvalue};
end

quantfunc = str2func(PROJimp.qvecfunc);

switch GQNT.return
   
%====================================================
% Build Quantization Vector
%====================================================
case 'FindPossible'
    GQNT.wantediseg = PROJdgn.iseg;
    GQNT.noisegs = 1;
    GQNT.wantedtro = PROJdgn.tro; 
    GQNT.wantedtwseg = destwseg;
    sampfunc = str2func(PROJimp.tsmpfunc);
    SAMP.writeout = 'no';
    good = [];
    while true
        [PROJimp,GQNT,SCRPTipt,err0] = quantfunc(PROJdgn,PROJimp,GQNT,SCRPTipt,[]);
        besttro = GQNT.besttro;
        bestiseg = GQNT.bestiseg;
        besttwseg = GQNT.besttwseg;
        osamp = [];
        for n = 1:length(besttro)
            testPROJdgn = PROJdgn;
            testPROJdgn.tro = besttro(n);
            [PROJimp,SAMP,SCRPTipt,err0] = sampfunc(testPROJdgn,PROJimp,SAMP,SCRPTipt,[]);
            osamp(n) = SAMP.osamp;    
        end
        if strcmp(slvprior1,'OvrSamp1');        
            osampbound = 1.05;
            trobound = 0.005;
            isegbound = 0.005;
            ind = find(osamp < SAMP.sampling*osampbound);
            if not(isempty(ind))
                n = 0;
                for i = 1:length(ind)
                    if abs(besttro(ind(i))-GQNT.wantedtro) < GQNT.wantedtro*trobound
                        if abs(bestiseg(ind(i))-GQNT.wantediseg) < GQNT.wantediseg*isegbound
                            n = n+1;
                            good(n) = ind(i);
                        end
                    end
                end
                if strcmp(slvprior2,'OvrSamp2');   
                    good = good(find(osamp(good) == min(osamp(good)),1,'first'));        
                elseif strcmp(slvprior2,'Tro2');   
                    good = good(find(abs(besttro(good)-GQNT.wantedtro) == min(abs(besttro(good)-GQNT.wantedtro)),1,'first'));        
                elseif strcmp(slvprior2,'TwGseg2');   
                    good = good(find(abs(besttwseg(good)-GQNT.wantedtwseg) == min(abs(besttwseg(good)-GQNT.wantedtwseg)),1,'first'));  
                elseif strcmp(slvprior2,'iGseg2');
                    good = good(find(abs(bestiseg(good)-GQNT.wantediseg) == min(abs(bestiseg(good)-GQNT.wantediseg)),1,'first'));                
                end
                if not(isempty(good))
                    break
                end
            end
        elseif strcmp(slvprior1,'TwGseg1');        
            osampbound = 1.5;
            trobound = 0.005;
            isegbound = 0.005;
            twsegbound = 0.002;
            ind = find(osamp < SAMP.osampdes*osampbound);
            if not(isempty(ind))
                n = 0;
                for i = 1:length(ind)
                    if abs(besttro(ind(i))-GQNT.wantedtro) < GQNT.wantedtro*trobound
                        if abs(bestiseg(ind(i))-GQNT.wantediseg) < GQNT.wantediseg*isegbound
                            if abs(((besttro(ind(i))-bestiseg(ind(i)))/GQNT.twwords)-PROJimp.wantedtwseg) < PROJimp.wantedtwseg*twsegbound
                                n = n+1;
                                good(n) = ind(i);
                            end
                        end
                    end
                end
                if strcmp(slvprior2,'OvrSamp2');   
                    good = good(find(osamp(good) == min(osamp(good)),1,'first'));        
                elseif strcmp(slvprior2,'Tro2');   
                    good = good(find(abs(besttro(good)-GQNT.wantedtro) == min(abs(besttro(good)-GQNT.wantedtro)),1,'first'));        
                elseif strcmp(slvprior2,'TwGseg2');   
                    good = good(find(abs(besttwseg(good)-GQNT.wantedtwseg) == min(abs(besttwseg(good)-GQNT.wantedtwseg)),1,'first'));  
                elseif strcmp(slvprior2,'iGseg2');
                    good = good(find(abs(bestiseg(good)-GQNT.wantediseg) == min(abs(bestiseg(good)-GQNT.wantediseg)),1,'first'));                
                end
                if not(isempty(good))
                    break
                end 
            end
        elseif strcmp(slvprior1,'Tro1');        
            osampbound = 1.5;
            trobound = 0.002;
            isegbound = 0.002;
            ind = find(osamp < SAMP.osampdes*osampbound);
            if not(isempty(ind))
                n = 0;
                for i = 1:length(ind)
                    if abs(besttro(ind(i))-GQNT.wantedtro) < GQNT.wantedtro*trobound
                        if abs(bestiseg(ind(i))-GQNT.wantediseg) < GQNT.wantediseg*isegbound
                            n = n+1;
                            good(n) = ind(i);
                        end
                    end
                end
                if strcmp(slvprior2,'OvrSamp2');   
                    good = good(find(osamp(good) == min(osamp(good)),1,'first'));        
                elseif strcmp(slvprior2,'Tro2');   
                    good = good(find(abs(besttro(good)-GQNT.wantedtro) == min(abs(besttro(good)-GQNT.wantedtro)),1,'first'));        
                elseif strcmp(slvprior2,'TwGseg2');   
                    good = good(find(abs(besttwseg(good)-GQNT.wantedtwseg) == min(abs(besttwseg(good)-GQNT.wantedtwseg)),1,'first'));   
                elseif strcmp(slvprior2,'iGseg2');
                    good = good(find(abs(bestiseg(good)-GQNT.wantediseg) == min(abs(bestiseg(good)-GQNT.wantediseg)),1,'first'));                
                end
                if not(isempty(good))
                    break
                end
            end
        elseif strcmp(slvprior1,'iGseg1');        
            osampbound = 1.5;
            trobound = 0.002;
            isegbound = 0.002;
            ind = find(osamp < SAMP.osampdes*osampbound);
            if not(isempty(ind))
                n = 0;
                for i = 1:length(ind)
                    if abs(besttro(ind(i))-GQNT.wantedtro) < GQNT.wantedtro*trobound
                        if abs(bestiseg(ind(i))-GQNT.wantediseg) < GQNT.wantediseg*isegbound
                            n = n+1;
                            good(n) = ind(i);
                        end
                    end
                end
                if strcmp(slvprior2,'OvrSamp2');   
                    good = good(find(osamp(good) == min(osamp(good)),1,'first'));        
                elseif strcmp(slvprior2,'Tro2');   
                    good = good(find(abs(besttro(good)-GQNT.wantedtro) == min(abs(besttro(good)-GQNT.wantedtro)),1,'first'));        
                elseif strcmp(slvprior2,'TwGseg2');   
                    good = good(find(abs(besttwseg(good)-GQNT.wantedtwseg) == min(abs(besttwseg(good)-GQNT.wantedtwseg)),1,'first'));  
                elseif strcmp(slvprior2,'iGseg2');
                    good = good(find(abs(bestiseg(good)-GQNT.wantediseg) == min(abs(bestiseg(good)-GQNT.wantediseg)),1,'first'));                
                end
                if not(isempty(good))
                    break
                end
            end         
        end
        GQNT.wantedtwseg = round(10000*(GQNT.wantedtro-GQNT.noisegs*GQNT.wantediseg)/(GQNT.twwords-1))/10000;
    end
    GQNT.besttro = besttro(good);
    GQNT.bestiseg = bestiseg(good);
    GQNT.besttwseg = besttwseg(good);

%====================================================
% Generate Quantization Vector
%====================================================
case 'Output'
    tGQNT = GQNT;
    tGQNT.wantedtro = GQNT.besttro; 
    tGQNT.wantediseg = GQNT.bestiseg;
    tGQNT.wantedtwseg = GQNT.besttwseg;
    [PROJimp,GQNT,SCRPTipt,err0] = quantfunc(PROJdgn,PROJimp,tGQNT,SCRPTipt,[]);
end
