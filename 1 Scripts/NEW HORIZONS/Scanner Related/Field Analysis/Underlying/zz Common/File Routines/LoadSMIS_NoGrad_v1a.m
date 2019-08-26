%=====================================================
% (v1a)
%   - update to match LoadVarian_NoGrad_v1a
%=====================================================

function [Tpars,FID,ParamsDisp,StudyDisp,err] = LoadSMIS_NoGrad_v1a(path)

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
ind = strfind(Text,'KHz  ');                            % not sure why extra space here
Text = Text(ind(1)+5:length(Text));
ind2 = strfind(Text,char(32));
Tpars.dwell = str2double(Text(1:ind2(1)-1))/1000;         % in us

%------------------------------------------
% Build Panel Displays
%------------------------------------------ 

