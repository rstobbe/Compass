%====================================================
%
%====================================================

function [default] = B1corrDW_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Correct';
default{m,1}.entrystr = 'TxRx';
default{m,1}.options = {'Tx','Rx','TxRx'};

