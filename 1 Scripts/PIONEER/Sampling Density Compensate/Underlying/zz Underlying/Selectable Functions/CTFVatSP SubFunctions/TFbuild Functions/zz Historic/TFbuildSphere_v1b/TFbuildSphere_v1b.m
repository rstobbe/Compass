%================================================================================
% (v1b)
%       - Update for RWSUI_BA 
%       - Location values defined at integers when normalized to grid
%           (otherwise can yeild systematic kernel quantizatio error)
%       - limit W to integer multiples
%================================================================================

function [SCRPTipt,TFBout,err] = TFbuildSphere_v1b(SCRPTipt,TFB)

Status2('done','Build TF',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
TFBout.MinRadDim = str2double(TFB.('MinRadDim'));
TFBout.MaxSubSamp = str2double(TFB.('MaxSubSamp'));

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
PROJdgn = TFB.PROJdgn;
PROJimp = TFB.PROJimp;
TFO = TFB.TFO;
KRNprms = TFB.KRNprms;

DblKern = KRNprms.DblKern;
FwdKern = KRNprms.FwdKern;
RvsKern = KRNprms.RvsKern;

%----------------------------------------
% Error Tests
%----------------------------------------
if isfield(PROJdgn,'elip')
    if PROJdgn.elip ~= 1;                   
        if length(err) ~= 1
            errn = length(err)+1;
        else
            errn = 1;
        end
        err(errn).flag = 1;
        err(errn).msg = 'Elip Not Supported with TFbuildSphere';
        return
    end
end

%----------------------------------------
% 'Sphere-Array' Size Test
%----------------------------------------
m = 1;
for n = DblKern.OKforSS:0.0005:TFBout.MaxSubSamp
    test = round(1e9/(n*DblKern.res))/1e9;
    if not(rem(test,1)) && not(rem(DblKern.W*n,1))
        psubsamp(m) = n;
        m = m+1;
    end    
end  
kmax = PROJdgn.kmax*PROJimp.meanrelkmax;
SubSamp = psubsamp(1);
TFBout.RadDim = round((kmax/PROJdgn.kstep)*SubSamp);
while TFBout.RadDim < TFBout.MinRadDim
    ind = find(psubsamp == SubSamp,1);
    if ind == length(psubsamp)
        err.flag = 1;
        err.msg = 'increase ''MaxSubSamp'' or decrease ''MinRadDim''';
        return
    end
    SubSamp = psubsamp(ind+1);
    TFBout.RadDim = round((kmax/PROJdgn.kstep)*SubSamp);
end
TFBout.SubSamp = SubSamp;

%----------------------------------------
% Continue
%----------------------------------------
if TFBout.RadDim > 100 || TFBout.SubSamp > 2.5
    button = questdlg(['RadDim = ',num2str(TFBout.RadDim),', SubSamp = ',num2str(TFBout.SubSamp),', Continue:']);
    if strcmp(button,'No')
        err.flag = 4;
        err.msg = '';
        return
    end   
end

%----------------------------------------
% Test
%----------------------------------------
TFquantrad = TFBout.RadDim/TFBout.SubSamp;
DESquantrad = kmax/PROJdgn.kstep;
TFBout.rKernWid = TFquantrad/DESquantrad; 
if abs(TFBout.rKernWid-1) > 0.001
    button = questdlg(['TF Sphere Quantization Error = ',num2str(100*abs(TFBout.rKernWid-1)),'% Continue:']);
    if strcmp(button,'No')
        err.flag = 4;
        err.msg = '';
        return
    end  
end

%----------------------------------------
% Build 'Sphere-Array'
%----------------------------------------
Status2('busy','Build Transfer Function Shape',2);
top = ceil(TFBout.RadDim) + 1;
bot = ceil((FwdKern.W+RvsKern.W)*SubSamp/2) + 1;
Loc = zeros((2*bot+1)^2*(top+bot+1),3);
Val = zeros((2*bot+1)^2*(top+bot+1),3);
n = 1;
m = 1;
L = length(TFO.r)-1;
for x = -bot:top
    for y = -bot:bot
        for z = -bot:bot
            r = sqrt(x^2 + y^2 + z^2)/TFBout.RadDim;
            if r <= 1 
                 Loc(n,:) = [x y z];  
                 Val(n) = lin_interp4(TFO.tf,r,L);
                 n = n+1;
            elseif r > 1 && r <= 1.0001                             % accomodate quantization (for TFBout.MinRadDim > 80, below does nothing)
                 Loc(n,:) = [x y z];  
                 r = 1;
                 Val(n) = lin_interp4(TFO.tf,r,L);
                 n = n+1;                
            end
        end
    end
    Status2('busy',num2str(top+bot-m+1),3);
    m = m+1;    
end
Status2('done','',3);
%TFBout.Loc = kmax*Loc(1:n-1,:)/TFBout.RadDim;                  % wrong way
TFBout.Loc = Loc(1:n-1,:)*(PROJdgn.kstep/SubSamp);
TFBout.Val = Val(1:n-1);
TFBout.LocMax = max((TFBout.Loc(:,1).^2 + TFBout.Loc(:,2).^2 + TFBout.Loc(:,3).^2).^(0.5));
TFBout.rLocMax = TFBout.LocMax/kmax;

%----------------------------------------
% Test (already done - same result)
%----------------------------------------
%if abs(TFBout.rLocMax-1) > 0.001
%    err.flag = 1;
%    err.msg = 'increase ''MinRadDim''';
%    return
%end

Status2('done','',2);
Status2('done','',3);


