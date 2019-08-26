%=========================================================
% 
%=========================================================

function [PROJimp,GQNT,IMPipt,err] = QVec_TPIDblStep_v1a(PROJdgn,PROJimp,GQNT,IMPipt,err)

func = GQNT.return;
wantedtro = GQNT.wantedtro;
wantediseg = GQNT.wantediseg;
noisegs = GQNT.noisegs;
wantedtwseg = GQNT.wantedtwseg;

twwords = round((wantedtro - noisegs*wantediseg)/wantedtwseg) +1;              % +1 is for the double step 
iseg0 = floor(wantediseg*10000);
twseg0 = ceil(wantedtwseg*10000);

VarianBase = 0.002;                     % 2 us seems to be minimum timebase for gradient waveforms.
maxisegmult = floor(wantediseg/VarianBase);
maxtwsegmult = floor(wantedtwseg/VarianBase);

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
    trotest(logical(ind)) = (noisegs*iseg(logical(ind))+(twseg(logical(ind))*(twwords -1)))/10000;       % -1 is for the double step 
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

GQNT.besttro = besttro(closest-2:closest+3);
GQNT.bestiseg = bestiseg(closest-2:closest+3);
GQNT.besttwseg = besttwseg(closest-2:closest+3);
GQNT.twwords = twwords;

if strcmp(func,'FindPossible');
    return
end

[N,M] = find(trotest == wantedtro);
GQNT = struct();
GQNT.iseg = iseg(N,M)/10000;
GQNT.twseg = twseg(N,M)/10000;
GQNT.idivno = idivno(N,M);
GQNT.twdivno = twdivno(N,M);
GQNT.reqtro = trotest(N,M);
GQNT.twwords = twwords;
GQNT.samptwseg = (GQNT.twseg * (twwords-1))/(twwords - 2);

GQNT.samparr = [0 (GQNT.iseg:GQNT.iseg:noisegs*GQNT.iseg) noisegs*GQNT.iseg + [GQNT.samptwseg/2 (GQNT.samptwseg:GQNT.samptwseg:wantedtro)]];
GQNT.scnrarr = [0 (GQNT.iseg:GQNT.iseg:noisegs*GQNT.iseg) (noisegs*GQNT.iseg+GQNT.twseg:GQNT.twseg:wantedtro)];

if GQNT.samparr(length(GQNT.samparr)) ~= wantedtro || GQNT.scnrarr(length(GQNT.scnrarr)) ~= wantedtro
    samparr = GQNT.samparr
    scnrarr = GQNT.scnrarr
    error();
end

iGwfmTbase = GQNT.iseg/GQNT.idivno;
twGwfmTbase = GQNT.twseg/GQNT.twdivno;
if round(iGwfmTbase*1e9) ~= round(twGwfmTbase*1e9)
    error('GwfmTbase should be constant');
end
if iGwfmTbase*1e3 < 2
    error('GwfmTbase must be greater than 2 us');
end
iGwfmTbase = round(iGwfmTbase*1e9)/1e9;
if rem(iGwfmTbase*1e6,50)
    error('GwfmTbase must be a multiple of 50 ns');
end

PROJimp.iseg = GQNT.iseg;
PROJimp.twseg = GQNT.twseg;
PROJimp.tro = GQNT.reqtro;
PROJimp.mingseg = min([PROJimp.iseg PROJimp.twseg]);

GQNT.panel{1} = {'iGseg_Imp (ms)',GQNT.iseg};
GQNT.panel{2} = {'twGseg_Imp (ms)',GQNT.twseg};
%[IMPipt] = AddToPanelOutput(IMPipt,'iGseg_Imp (ms)','0output',GQNT.iseg,'0numout');
%[IMPipt] = AddToPanelOutput(IMPipt,'twGseg_Imp (ms)','0output',GQNT.twseg,'0numout');

