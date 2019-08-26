%=====================================================
% 
%=====================================================

function [dwell,np,gval,errorflag,error] = PosLocParamsSMIS_v1(path)

error = '';
errorflag = 0;

DataSetOffset = 0;
nSets = 0;
[~,Pars] = ReadSMIS_v1(path,DataSetOffset,nSets);

%set(findobj('tag','TestBox'),'string',Pars);

np = str2double(ParseParsSMIS_v1(Pars,'no_samples'));

ind = strfind(Pars,'sample_period');
Text = Pars(ind:ind+200);
ind = strfind(Text,'KHz ');
Text = Text(ind(1)+4:length(Text));
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


