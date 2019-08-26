%=====================================================
% (v1a)
%   - 
%=====================================================

function [Tpars,FID,ParamsDisp,StudyDisp,err] = LoadSMIS_RFPreSingleGrad_v1a(path)

FID = [];
ParamsDisp = [];
StudyDisp = [];
err.flag = 0;
err.msg = '';

%------------------------------------------
% Load Parameters / FID
%------------------------------------------ 
DataSetOffset = 0;
nSets = 1;
[FID,Pars] = ReadSMIS_v1(path,DataSetOffset,nSets);
FID = permute(FID,[2 1]);
FID = conj(FID);            % to make further into magnet positive, and out of magnet negative

%------------------------------------------
% Build Structure
%------------------------------------------ 
Tpars.np = str2double(ParseParsSMIS_v1(Pars,'no_samples'));

ind = strfind(Pars,'sample_period');
Text = Pars(ind:ind+200);
ind = strfind(Text,'KHz ');
Text = Text(ind(1)+4:length(Text));
ind2 = strfind(Text,char(32));
if ind2(1) == 1
    Tpars.dwell = str2double(Text(2:ind2(2)-1))/1000;         % in us
else
    Tpars.dwell = str2double(Text(1:ind2(1)-1))/1000;         % in us
end

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
    Tpars.graddir = 'LR';
    Gmax = Gxmax;
elseif gy_on == 1
    Tpars.graddir = 'TB';
    Gmax = Gymax;
elseif gz_on == 1
    Tpars.graddir = 'IO';
    Gmax = Gzmax;
end
gval = str2double(ParseParsSMIS_v1(Pars,'grad_amp'));
Tpars.gval = Gmax*gval/32767;

%------------------------------------------
% Extra
%------------------------------------------ 
Tpars.pnum = 1;

%------------------------------------------
% Build Panel Displays
%------------------------------------------ 

