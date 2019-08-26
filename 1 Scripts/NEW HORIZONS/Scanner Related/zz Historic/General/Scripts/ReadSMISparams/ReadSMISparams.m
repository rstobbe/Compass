%====================================================
%
%====================================================

function [SCRPTipt] = ReadSMISparams(SCRPTipt,SCRPTGBL)

addpath('D:\0 Programs\A0 AID_TRICS\1 Underlying\3 System\2 SMIS\ReadSMIS');
DataSetOffset = 0;
nSets = 0;

[Cplx_Data,Pars] = ReadSMIS(SCRPTGBL.outpath,DataSetOffset,nSets);

n = length(SCRPTipt)+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0output';
SCRPTipt(n).labelstr = 'NSamples';
SCRPTipt(n).entrystyle = '0text';
SCRPTipt(n).entrystr = num2str(Cplx_Data(1));
SCRPTipt(n).selstyle = '0text';
SCRPTipt(n).selstr = '';

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0output';
SCRPTipt(n).labelstr = 'NViews1';
SCRPTipt(n).entrystyle = '0text';
SCRPTipt(n).entrystr = num2str(Cplx_Data(2));
SCRPTipt(n).selstyle = '0text';
SCRPTipt(n).selstr = '';

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0output';
SCRPTipt(n).labelstr = 'NViews2';
SCRPTipt(n).entrystyle = '0text';
SCRPTipt(n).entrystr = num2str(Cplx_Data(3));
SCRPTipt(n).selstyle = '0text';
SCRPTipt(n).selstr = '';

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0output';
SCRPTipt(n).labelstr = 'NSlices';
SCRPTipt(n).entrystyle = '0text';
SCRPTipt(n).entrystr = num2str(Cplx_Data(4));
SCRPTipt(n).selstyle = '0text';
SCRPTipt(n).selstr = '';

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0output';
SCRPTipt(n).labelstr = 'NEchos';
SCRPTipt(n).entrystyle = '0text';
SCRPTipt(n).entrystr = num2str(Cplx_Data(5));
SCRPTipt(n).selstyle = '0text';
SCRPTipt(n).selstr = '';

n = n+1;
SCRPTipt(n).number = n;
SCRPTipt(n).labelstyle = '0output';
SCRPTipt(n).labelstr = 'NExperiments';
SCRPTipt(n).entrystyle = '0text';
SCRPTipt(n).entrystr = num2str(Cplx_Data(6));
SCRPTipt(n).selstyle = '0text';
SCRPTipt(n).selstr = '';

set(findobj('tag','TestBox'),'string',Pars);