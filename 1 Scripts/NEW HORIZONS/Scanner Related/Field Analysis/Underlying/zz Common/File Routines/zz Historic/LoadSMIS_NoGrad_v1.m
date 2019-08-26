%=====================================================
% 
%=====================================================

function [dwell,np,errorflag,error] = BackGradParamsSMIS_v1(path)

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
Text = Text(ind(1)+5:length(Text));
ind2 = strfind(Text,char(32));
dwell = str2double(Text(1:ind2(1)-1))/1000;         % in us

