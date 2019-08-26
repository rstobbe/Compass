%=====================================================
% 
%=====================================================

function [dwell,np,gval,gofftime,FID,errorflag,error] = PostGradEddy_v3_LoadSMIS(path)

error = '';
errorflag = 0;
dwell = [];
np = [];
gval = [];
gofftime = [];
FID = [];

DataSetOffset = 0;
nSets = 0;
[~,Pars] = ReadSMIS_v1(path,DataSetOffset,nSets);

%set(findobj('tag','TestBox'),'string',Pars);

ind = strfind(Pars,'.ppl');
Text = Pars(1:ind(1)-1);
ind = strfind(Text,'\');
seq = Text(ind(length(ind))+1:length(Text));
if not(strcmp(seq,'LongEddy_v3')) && not(strcmp(seq,'MediumEddy_v3')) && not(strcmp(seq,'ShortEddy_v3'))
    error = 'LongEddy_v3 Sequence Not Used';
    errorflag = 1;
    return
end

np = str2double(ParseParsSMIS_v1(Pars,'no_samples'));

ind = strfind(Pars,'sample_period');
Text = Pars(ind:ind+200);
ind = strfind(Text,'KHz ');
Text = Text(ind(1)+5:length(Text));
ind2 = strfind(Text,char(32));
dwell = str2double(Text(1:ind2(1)-1))/1000;         % in us

ind = strfind(Pars,'grad_var');
Text = Pars(ind:ind+200);
ind = strfind(Text,',');
Gxmax = str2double(Text(ind(3)+1:ind(4)-1))/42.577; % in mT/m
Gymax = str2double(Text(ind(4)+1:ind(5)-1))/42.577; % in mT/m
Gzmax = str2double(Text(ind(5)+1:ind(5)+4))/42.577; % in mT/m

gx_on = str2double(ParseParsSMIS_v1(Pars,'gx_on'));
gy_on = str2double(ParseParsSMIS_v1(Pars,'gy_on'));
gz_on = str2double(ParseParsSMIS_v1(Pars,'gz_on'));
if gx_on == 1
    Grad = 'x';
    Gmax = Gxmax;
elseif gy_on == 1
    Grad = 'y';
    Gmax = Gymax;
elseif gz_on == 1
    Grad = 'z';
    Gmax = Gzmax;
end

gval = str2double(ParseParsSMIS_v1(Pars,'grad_amp'));
gval = Gmax*gval/32767;

nacqs = str2double(ParseParsSMIS_v1(Pars,'no_acqs'));
tr = str2double(ParseParsSMIS_v1(Pars,'tr'))/1000;
nexps = str2double(ParseParsSMIS_v1(Pars,'no_experiments'));

ind = strfind(Pars,'initdels');
Text = Pars(ind:ind+200);
ind = strfind(Text,char(32));
for n = 1:nexps-1
    initdels(n) = str2double(Text(ind(n+1)+1:ind(n+2)-2))/1000;
end
Text = Text(ind(nexps+1)+1:length(Text));
ind2 = strfind(Text,char(13));
initdels(nexps) = str2double(Text(1:ind2(1)-1))/1000;

DataSetOffset = 0;
nSets = nacqs*nexps;
[fid,Pars] = ReadSMIS_v1(path,DataSetOffset,nSets);

for n = 1:nexps
    gofftime(n,:) = (initdels(n):tr:tr*nacqs);
    FID(n,:,:) = fid(:,(n-1)*nacqs+1:n*nacqs);
end

FID = conj(FID);            % to make further into magnet positive, and out of magnet negative


