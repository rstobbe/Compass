%=====================================================
% (v1a)
%   -
%=====================================================

function [Tpars,FID,ParamsDisp,StudyDisp,err] = LoadSMIS_SingleRFPostGrad_v1a(path)

Tpars = struct();
FID = [];
ParamsDisp = [];
StudyDisp = [];
err.flag = 0;
err.msg = '';

%------------------------------------------
% Load Parameters 
%------------------------------------------ 
DataSetOffset = 0;
nSets = 0;
[~,Pars] = ReadSMIS_v1(path,DataSetOffset,nSets);

%------------------------------------------
% Test
%------------------------------------------ 
ind = strfind(Pars,'.ppl');
Text = Pars(1:ind(1)-1);
ind = strfind(Text,'\');
seq = Text(ind(length(ind))+1:length(Text));
if not(strcmp(seq,'VeryShortEddy_v3'))
    err.flag = 1;
    err.msg = 'Improper sequence for File_Grad';
    return
end

%------------------------------------------
% Build Structure
%------------------------------------------ 
Tpars.np = str2double(ParseParsSMIS_v1(Pars,'no_samples'));

ind = strfind(Pars,'sample_period');
Text = Pars(ind:ind+200);
ind = strfind(Text,'KHz  ');
Text = Text(ind(1)+5:length(Text));
ind2 = strfind(Text,char(32));
Tpars.dwell = str2double(Text(1:ind2(1)-1))/1000;         % in us

ind = strfind(Pars,'grad_var');
Text = Pars(ind:ind+200);
ind = strfind(Text,',');
Gxmax = str2double(Text(ind(3)+1:ind(4)-1))/42.577; % in mT/m
Gymax = str2double(Text(ind(4)+1:ind(5)-1))/42.577; % in mT/m
Gzmax = str2double(Text(ind(5)+1:ind(5)+5))/42.577; % in mT/m
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
Tpars.gmax = Gmax;
gval = str2double(ParseParsSMIS_v1(Pars,'grad_amp'));
Tpars.gval = Gmax*gval/32767;

Tpars.tr = str2double(ParseParsSMIS_v1(Pars,'tr'));             % in ms
Tpars.pgdel = str2double(ParseParsSMIS_v1(Pars,'pgdel'));       % in us

pw = str2double(ParseParsSMIS_v1(Pars,'p90'));
trdd = str2double(ParseParsSMIS_v1(Pars,'trdd'));               % ring down
pred = str2double(ParseParsSMIS_v1(Pars,'pred'));               % pre RF delay
Tpars.seqtime = pw+trdd+pred;                                   % should be tested

Tpars.falltime = str2double(ParseParsSMIS_v1(Pars,'tramp'));

%------------------------------------------
% Build Panel Displays
%------------------------------------------ 

%------------------------------------------
% Load FID
%------------------------------------------ 
DataSetOffset = 0;
nSets = 1;
[fid(1,:,1),~] = ReadSMIS_v1(path,DataSetOffset,nSets);
FID = conj(fid);            % to make further into magnet positive, and out of magnet negative


