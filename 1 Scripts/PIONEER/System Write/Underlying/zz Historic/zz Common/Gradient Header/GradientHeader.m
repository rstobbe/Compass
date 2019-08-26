%=================================================
% Write Header
%=================================================
function [Header] = GradientHeader(AIDgbl,AIDipars)

global USER

Header{1} = ['Created with AID ',AIDgbl.CV,' (Copywrite Rob Stobbe 2011)'];
Header{2} = ['User: ',USER];
Header{3} = ['Projection Set Name: ',AIDgbl.Folder];
Header{4} = ['Projection Creation Date: ',AIDgbl.Date];
Header{5} = ['Projection Type: ',AIDgbl.projdes];
Header{6} = ['Projection Type Version: ',AIDgbl.vers];
Header{7} = ['Implementation Method: ',AIDipars.impmeth];
Header{8} = ['Implementation Name: ',AIDipars.impname];
Header{9} = ['System: ',AIDipars.sysname];