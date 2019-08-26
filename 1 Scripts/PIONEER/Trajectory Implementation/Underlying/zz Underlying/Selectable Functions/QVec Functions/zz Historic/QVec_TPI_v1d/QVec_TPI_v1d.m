%=========================================================
% (v1d)
%       - fix bug in GCD search
%=========================================================

function [SCRPTipt,QVECout,err] = QVec_TPI_v1d(SCRPTipt,QVEC)

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
    %trotest = zeros(L,L);
    %isegtest = zeros(L,L);
    %twsegtest = zeros(L,L);
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
    trotest = (iseg(logical(ind))+(twseg(logical(ind))*twwords))/10000;
    isegtest = iseg(logical(ind))/10000;
    twsegtest = twseg(logical(ind))/10000;
    idivnotest = idivno(logical(ind));
    twdivnotest = twdivno(logical(ind));
    [allbesttro,sortinds] = sort(trotest,'descend');
    allbestiseg = isegtest(sortinds);
    allbesttwseg = twsegtest(sortinds);
    allbestidivno = idivnotest(sortinds);
    allbesttwdivno = twdivnotest(sortinds);
    
    closest = find((allbesttro > wantedtro),1,'last');
    if isempty(closest)
        L = L+10;
    else
        if closest <= 2
            L = L+10;
        else
            if length(allbesttro) - closest < 3
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

%---------------------------------------------
% Compile 6 best to return
%---------------------------------------------
besttro = allbesttro(closest-2:closest+3);
bestiseg = allbestiseg(closest-2:closest+3);
besttwseg = allbesttwseg(closest-2:closest+3);
bestidivno = allbestidivno(closest-2:closest+3);
besttwdivno = allbesttwdivno(closest-2:closest+3);

QVECout.besttro = besttro;
QVECout.bestiseg = bestiseg;
QVECout.besttwseg = besttwseg;
QVECout.bestidivno = bestidivno;
QVECout.besttwdivno = besttwdivno;
QVECout.twwords = twwords;



