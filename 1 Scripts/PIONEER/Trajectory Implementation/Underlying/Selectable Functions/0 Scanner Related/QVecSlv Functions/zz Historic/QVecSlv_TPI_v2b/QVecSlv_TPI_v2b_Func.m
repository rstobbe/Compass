%=====================================================
% 
%=====================================================

function [GQNT,err] = QVecSlv_TPI_v2b_Func(GQNT,INPUT)

Status2('busy','Quantize Gradient Waveforms',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
mode = INPUT.mode;
QVEC = GQNT.QVEC;
clear INPUT

switch mode
case 'FindBest'
%====================================================
% Find Best Quantization
%====================================================
    %---------------------------------------------
    % Prepare Underlying Function
    %---------------------------------------------
    quantfunc = str2func([GQNT.QVecfunc,'_Func']);
    INPUT.wantediseg = PROJdgn.iseg;
    INPUT.wantedtro = PROJdgn.tro; 
    INPUT.wantedtwseg = GQNT.destwseg;

    %---------------------------------------------
    % Solve Best Quantization
    %---------------------------------------------
    good = [];
    while true
        [QVECout,err] = quantfunc(QVEC,INPUT);
        if err.flag
            ErrDisp(err);
            return
        end
        besttro = QVECout.besttro;
        bestiseg = QVECout.bestiseg;
        besttwseg = QVECout.besttwseg;
        twwords = QVECout.twwords;
        if strcmp(GQNT.slvprior1,'TwGseg1');        
            trobound = 0.005;
            isegbound = 0.005;
            twsegbound = 0.002;
            n = 0;
            for i = 1:length(besttro)
                if abs(besttro(i)-PROJdgn.tro) < PROJdgn.tro*trobound
                    if abs(bestiseg(i)-PROJdgn.iseg) < PROJdgn.iseg*isegbound
                        if abs(((besttro(i)-bestiseg(i))/twwords)-PROJimp.wantedtwseg) < PROJimp.wantedtwseg*twsegbound
                            n = n+1;
                            good(n) = i;
                        end
                    end
                end
            end    
            if strcmp(GQNT.slvprior2,'Tro2');   
                good = good(find(abs(besttro(good)-PROJdgn.tro) == min(abs(besttro(good)-PROJdgn.tro)),1,'first'));        
            elseif strcmp(GQNT.slvprior2,'TwGseg2');   
                good = good(find(abs(besttwseg(good)-GQNT.destwseg) == min(abs(besttwseg(good)-GQNT.destwseg)),1,'first'));  
            elseif strcmp(GQNT.slvprior2,'iGseg2');
                good = good(find(abs(bestiseg(good)-PROJdgn.iseg) == min(abs(bestiseg(good)-PROJdgn.iseg)),1,'first'));                
            end
            if not(isempty(good))
                break
            end 
        elseif strcmp(GQNT.slvprior1,'Tro1');        
            trobound = 0.002;
            isegbound = 0.002;
            n = 0;
            for i = 1:length(besttro)
                if abs(besttro(i)-PROJdgn.tro) < PROJdgn.tro*trobound
                    if abs(bestiseg(i)-PROJdgn.iseg) < PROJdgn.iseg*isegbound
                        n = n+1;
                        good(n) = i;
                    end
                end
            end   
            if strcmp(GQNT.slvprior2,'Tro2');   
                good = good(find(abs(besttro(good)-PROJdgn.tro) == min(abs(besttro(good)-PROJdgn.tro)),1,'first'));        
            elseif strcmp(GQNT.slvprior2,'TwGseg2');   
                good = good(find(abs(besttwseg(good)-GQNT.destwseg) == min(abs(besttwseg(good)-GQNT.destwseg)),1,'first'));   
            elseif strcmp(GQNT.slvprior2,'iGseg2');
                good = good(find(abs(bestiseg(good)-PROJdgn.iseg) == min(abs(bestiseg(good)-PROJdgn.iseg)),1,'first'));                
            end
            if not(isempty(good))
                break
            end
        elseif strcmp(GQNT.slvprior1,'iGseg1');        
            trobound = 0.002;
            isegbound = 0.002;
            n = 0;
            for i = 1:length(besttro)
                if abs(besttro(i)-PROJdgn.tro) < PROJdgn.tro*trobound
                    if abs(bestiseg(i)-PROJdgn.iseg) < PROJdgn.iseg*isegbound
                        n = n+1;
                        good(n) = i;
                    end
                end
            end       
            if strcmp(GQNT.slvprior2,'Tro2');   
                good = good(find(abs(besttro(good)-PROJdgn.tro) == min(abs(besttro(good)-PROJdgn.tro)),1,'first'));        
            elseif strcmp(GQNT.slvprior2,'TwGseg2');   
                good = good(find(abs(besttwseg(good)-GQNT.destwseg) == min(abs(besttwseg(good)-GQNT.destwseg)),1,'first'));  
            elseif strcmp(GQNT.slvprior2,'iGseg2');
                good = good(find(abs(bestiseg(good)-PROJdgn.iseg) == min(abs(bestiseg(good)-PROJdgn.iseg)),1,'first'));                
            end
            if not(isempty(good))
                break
            end     
        end
        INPUT.wantedtwseg = round(10000*(PROJdgn.tro-PROJdgn.iseg)/(twwords-1))/10000;
    end
    GQNT.besttro = besttro(good);
    GQNT.bestiseg = bestiseg(good);
    GQNT.besttwseg = besttwseg(good);
    GQNT.twwords = twwords;

case 'Output'    
%====================================================
% Generate Quantization Vector
%====================================================
    %---------------------------------------------
    % Test Quantization
    %---------------------------------------------
    quantfunc = str2func([GQNT.QVecfunc,'_Func']);
    INPUT.wantediseg = PROJimp.iseg;
    INPUT.wantedtro = PROJimp.tro; 
    INPUT.wantedtwseg = PROJimp.twseg;
    [QVEC,err] = quantfunc(QVEC,INPUT);
    if err.flag
        ErrDisp(err);
        return
    end

    %---------------------------------------------
    % Test Quantization
    %---------------------------------------------
    ind = find(QVEC.besttro == PROJimp.tro & QVEC.besttwseg == PROJimp.twseg,1);
    if isempty(ind)
        error('quantization problem');
    end
    tro = QVEC.besttro(ind);
    iseg = QVEC.bestiseg(ind);
    twseg = QVEC.besttwseg(ind);
    if tro ~= PROJimp.tro || iseg ~= PROJimp.iseg || twseg ~= PROJimp.twseg
        error('quantization problem');
    end
    
    %---------------------------------------------
    % Return Quantization Params
    %---------------------------------------------
    GQNT.tro = tro;
    GQNT.iseg = iseg;
    GQNT.twseg = twseg;
    GQNT.idivno = QVEC.bestidivno(ind);
    GQNT.twdivno = QVEC.besttwdivno(ind);
    GQNT.twwords = QVEC.twwords;
    GQNT.mingseg = min([GQNT.iseg GQNT.twseg]); 

    %---------------------------------------------
    % Return Quantization Array
    %---------------------------------------------
    GQNT.samparr = [0 iseg (iseg+twseg:twseg:tro)];
    GQNT.scnrarr = GQNT.samparr;

    %---------------------------------------------
    % Tests
    %---------------------------------------------
    if GQNT.samparr(length(GQNT.samparr)) ~= tro
        samparr = GQNT.samparr
        error();
    end
    iGQNTtbase = GQNT.iseg/GQNT.idivno;
    twGQNTtbase= GQNT.twseg/GQNT.twdivno;
    if round(iGQNTtbase*1e9) ~= round(twGQNTtbase*1e9)
        error('GQNTtbase must be constant');
    end
    if iGQNTtbase*1e3 < 2
        error('GQNTtbase must be greater than 2 us');
    end
    iGQNTtbase= round(iGQNTtbase*1e9)/1e9;
    if rem(iGQNTtbase*1e6,50)
        error('GQNTtbase must be a multiple of 50 ns');
    end

    %---------------------------------------------
    % Panel Output
    %---------------------------------------------    
    Panel(1,:) = {'Tro_Imp (ms)',GQNT.tro,'Output'};
    Panel(2,:) = {'iGseg_Imp (ms)',GQNT.iseg,'Output'};
    Panel(3,:) = {'twGseg_Imp (ms)',GQNT.twseg,'Output'};
    Panel(4,:) = {'idivno',GQNT.idivno,'Output'};
    Panel(5,:) = {'twdivno',GQNT.twdivno,'Output'};
    Panel(6,:) = {'twwords',GQNT.twwords,'Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);
    GQNT.PanelOutput = PanelOutput;
        
end
