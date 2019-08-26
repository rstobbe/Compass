%=====================================================
% (v2a)
%       - remove 'trajectory sampling' from development (v1b)
%       - inclusion of 'startfrac' in TrajSamp makes this unneccesary 
%=====================================================

function [SCRPTipt,GQNTout,err] = QVecSlv_TPI_v2a(SCRPTipt,GQNT)

Status('busy','Quantize Gradient Waveforms');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
GQNTout = struct();
GQNTout.QVecfunc = GQNT.('QVecfunc').Func;
GQNTout.destwseg = str2double(GQNT.('twGseg'));
GQNTout.slvprior1 = GQNT.('Solve_Priority1');
GQNTout.slvprior2 = GQNT.('Solve_Priority2');

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
CallingPanelOutput = GQNT.Struct.labelstr;
QVEC = GQNT.('QVecfunc');
if isfield(GQNTout,([CallingPanelOutput,'_Data']))
    if isfield(GQNTout.([CallingPanelOutput,'_Data']),('QVecfunc_Data'))
        QVEC.QVecfunc_Data = GQNT.([CallingPanelOutput,'_Data']).QVecfunc_Data;
    end
end
PROJdgn = GQNT.PROJdgn;
PROJimp = GQNT.PROJimp;

switch GQNT.return

case 'FindBest'
%====================================================
% Find Best Quantization
%====================================================
    %---------------------------------------------
    % Prepare Underlying Function
    %---------------------------------------------
    quantfunc = str2func(GQNTout.QVecfunc);
    QVEC.wantediseg = PROJdgn.iseg;
    QVEC.wantedtro = PROJdgn.tro; 
    QVEC.wantedtwseg = GQNTout.destwseg;

    %---------------------------------------------
    % Solve Best Quantization
    %---------------------------------------------
    good = [];
    while true
        [SCRPTipt,QVECout,err] = quantfunc(SCRPTipt,QVEC);
        if err.flag
            ErrDisp(err);
            return
        end
        besttro = QVECout.besttro;
        bestiseg = QVECout.bestiseg;
        besttwseg = QVECout.besttwseg;
        twwords = QVECout.twwords;
        if strcmp(GQNTout.slvprior1,'TwGseg1');        
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
            if strcmp(GQNTout.slvprior2,'Tro2');   
                good = good(find(abs(besttro(good)-PROJdgn.tro) == min(abs(besttro(good)-PROJdgn.tro)),1,'first'));        
            elseif strcmp(GQNTout.slvprior2,'TwGseg2');   
                good = good(find(abs(besttwseg(good)-GQNTout.destwseg) == min(abs(besttwseg(good)-GQNTout.destwseg)),1,'first'));  
            elseif strcmp(GQNTout.slvprior2,'iGseg2');
                good = good(find(abs(bestiseg(good)-PROJdgn.iseg) == min(abs(bestiseg(good)-PROJdgn.iseg)),1,'first'));                
            end
            if not(isempty(good))
                break
            end 
        elseif strcmp(GQNTout.slvprior1,'Tro1');        
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
            if strcmp(GQNTout.slvprior2,'Tro2');   
                good = good(find(abs(besttro(good)-PROJdgn.tro) == min(abs(besttro(good)-PROJdgn.tro)),1,'first'));        
            elseif strcmp(GQNTout.slvprior2,'TwGseg2');   
                good = good(find(abs(besttwseg(good)-GQNTout.destwseg) == min(abs(besttwseg(good)-GQNTout.destwseg)),1,'first'));   
            elseif strcmp(GQNTout.slvprior2,'iGseg2');
                good = good(find(abs(bestiseg(good)-PROJdgn.iseg) == min(abs(bestiseg(good)-PROJdgn.iseg)),1,'first'));                
            end
            if not(isempty(good))
                break
            end
        elseif strcmp(GQNTout.slvprior1,'iGseg1');        
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
            if strcmp(GQNTout.slvprior2,'Tro2');   
                good = good(find(abs(besttro(good)-PROJdgn.tro) == min(abs(besttro(good)-PROJdgn.tro)),1,'first'));        
            elseif strcmp(GQNTout.slvprior2,'TwGseg2');   
                good = good(find(abs(besttwseg(good)-GQNTout.destwseg) == min(abs(besttwseg(good)-GQNTout.destwseg)),1,'first'));  
            elseif strcmp(GQNTout.slvprior2,'iGseg2');
                good = good(find(abs(bestiseg(good)-PROJdgn.iseg) == min(abs(bestiseg(good)-PROJdgn.iseg)),1,'first'));                
            end
            if not(isempty(good))
                break
            end     
        end
        QVEC.wantedtwseg = round(10000*(PROJdgn.tro-PROJdgn.iseg)/(twwords-1))/10000;
    end
    GQNTout.besttro = besttro(good);
    GQNTout.bestiseg = bestiseg(good);
    GQNTout.besttwseg = besttwseg(good);
    GQNTout.twwords = twwords;

case 'Output'    
%====================================================
% Generate Quantization Vector
%====================================================
    %---------------------------------------------
    % Test Quantization
    %---------------------------------------------
    quantfunc = str2func(GQNTout.QVecfunc);
    QVEC.wantediseg = PROJimp.iseg;
    QVEC.wantedtro = PROJimp.tro; 
    QVEC.wantedtwseg = PROJimp.twseg;
    [SCRPTipt,QVEC,err] = quantfunc(SCRPTipt,QVEC);
    if err.flag
        ErrDisp(err);
        return
    end

    %---------------------------------------------
    % Test Quantization
    %---------------------------------------------
    ind = find(QVEC.besttro == PROJimp.tro,1);
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
    GQNTout.tro = tro;
    GQNTout.iseg = iseg;
    GQNTout.twseg = twseg;
    GQNTout.idivno = QVEC.bestidivno(ind);
    GQNTout.twdivno = QVEC.besttwdivno(ind);
    GQNTout.twwords = QVEC.twwords;
    GQNTout.mingseg = min([GQNTout.iseg GQNTout.twseg]); 

    %---------------------------------------------
    % Return Quantization Array
    %---------------------------------------------
    GQNTout.samparr = [0 iseg (iseg+twseg:twseg:tro)];
    GQNTout.scnrarr = GQNTout.samparr;

    %---------------------------------------------
    % Tests
    %---------------------------------------------
    if GQNTout.samparr(length(GQNTout.samparr)) ~= tro
        samparr = GQNTout.samparr
        error();
    end
    iGQNTtbase = GQNTout.iseg/GQNTout.idivno;
    twGQNTtbase= GQNTout.twseg/GQNTout.twdivno;
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
    Panel(1,:) = {'Tro_Imp (ms)',GQNTout.tro,'Output'};
    Panel(2,:) = {'iGseg_Imp (ms)',GQNTout.iseg,'Output'};
    Panel(3,:) = {'twGseg_Imp (ms)',GQNTout.twseg,'Output'};
    Panel(4,:) = {'idivno',GQNTout.idivno,'Output'};
    Panel(5,:) = {'twdivno',GQNTout.twdivno,'Output'};
    Panel(6,:) = {'twwords',GQNTout.twwords,'Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);
    GQNTout.PanelOutput = PanelOutput;
        
end
