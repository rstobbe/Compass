%=========================================================
% (v1c)
%       - update for RWSUI_BA / remove noisegs
%=========================================================

function [SCRPTipt,QVECout,err] = QVec_TPI_v1c(SCRPTipt,QVEC)

Status2('busy','Solve Quantization Vector',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
QVECout = struct();
QVECout.timebase = str2double(QVEC.('timebase'))/1000;

if QVECout.timebase ~= 0.002
    err.flag = 1;
    err.msg = 'time base should be 2 us for INOVA';             % 2 us seems to be minimum timebase for gradient waveforms on INOVA.
end

%---------------------------------------------
% Unload Variables
%---------------------------------------------
wantedtro = QVEC.wantedtro;
wantediseg = QVEC.wantediseg;
wantedtwseg = QVEC.wantedtwseg;

%---------------------------------------------
% Find Possible Quantization
%---------------------------------------------
twwords = round((wantedtro - wantediseg)/wantedtwseg);
iseg0 = floor(wantediseg*10000);
twseg0 = ceil(wantedtwseg*10000);
maxisegmult = floor(wantediseg/QVECout.timebase);
maxtwsegmult = floor(wantedtwseg/QVECout.timebase);
L = 40;
while true
    iseg = zeros(L,L);
    twseg = zeros(L,L);    
    idivno = zeros(L,L);
    twdivno = zeros(L,L);
    ind = zeros(L,L);
    trotest = zeros(L,L);
    isegtest = zeros(L,L);
    twsegtest = zeros(L,L);
    for n = 0:(L-1)
        for m = 0:(L-1)
            iseg(n+1,m+1) = iseg0-(L/2)+n;
            twseg(n+1,m+1) = twseg0+(L/2)-m;
            G = gcd(iseg(n+1,m+1),twseg(n+1,m+1));
            idivno(n+1,m+1) = iseg(n+1,m+1)/G;
            twdivno(n+1,m+1) = twseg(n+1,m+1)/G;
            if idivno(n+1,m+1) < maxisegmult && twdivno(n+1,m+1) < maxtwsegmult 
                ind(n+1,m+1) = 1;
            end
        end
    end    
    trotest(logical(ind)) = (iseg(logical(ind))+(twseg(logical(ind))*twwords))/10000;
    isegtest(logical(ind)) = iseg(logical(ind))/10000;
    twsegtest(logical(ind)) = twseg(logical(ind))/10000;
    [besttro,sortinds] = sort(trotest(:),'descend');
    bestiseg = isegtest(sortinds);
    besttwseg = twsegtest(sortinds);

    closest = find((besttro > wantedtro),1,'last');
    if isempty(closest)
        L = L+10;
    else
        if closest <= 2
            L = L+10;
        else
            if length(besttro(logical(besttro))) - closest < 3
                L = L+10;
            else
                break
            end
        end
    end
    if L >= 200
        error('Need Expanded Search for GCDs');
    end
end

besttro = besttro(logical(besttro));
bestiseg = bestiseg(logical(besttro));
besttwseg = besttwseg(logical(besttro));
idivno = idivno(logical(besttro));
twdivno = twdivno(logical(besttro));

%---------------------------------------------
% Compile 5 best to return
%---------------------------------------------
QVECout.besttro = besttro(closest-2:closest+3);
QVECout.bestiseg = bestiseg(closest-2:closest+3);
QVECout.besttwseg = besttwseg(closest-2:closest+3);
QVECout.idivno = idivno(closest-2:closest+3);
QVECout.twdivno = twdivno(closest-2:closest+3);
QVECout.twwords = twwords;




