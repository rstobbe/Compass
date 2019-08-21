%============================================
% 
%============================================
function [error,errorflag] = Export_ROI(rois)

global SAVEDXLOC
global SAVEDYLOC
global SAVEDZLOC
global IMINFO
global CURFIG
global IMT

error = '';
errorflag = 0;

ind = find(rois~=0);    
if ind > 1
    error;  % not supported yet
end

savedxloc = squeeze(SAVEDXLOC(ind,:));                              
savedyloc = squeeze(SAVEDYLOC(ind,:));                             
savedzloc = squeeze(SAVEDZLOC(ind,:));

ind = find(not(isempty(savedxloc)));
if ind > 1
    error; % not supported yet
end

pixdim = IMINFO(CURFIG).pixdim;

h_ROI = [savedyloc{1}*pixdim(2);savedxloc{1}*pixdim(1);savedzloc(1)*ones(size(savedxloc{1}))*pixdim(3);].';

IM = cell2mat(IMT(CURFIG));
sz = size(IM);

IMroimask0 = roipoly(ones(sz(1),sz(2)),savedxloc{1},savedyloc{1});
%IMroimask0 = flipdim(IMroimask0,1);
IMroimask0 = permute(IMroimask0,[2 1]);
%IMroimask0 = flipdim(IMroimask0,1);
[inds1,inds2] = find(IMroimask0);
ROI = [inds2 inds1 savedzloc(1)*ones(size(inds1))];

ROISem = 'AND';

[file,path] = uiputfile('*.mat','*.mat');
if path == 0
    error = 'ROIs not saved';
    errorflag = 1;
    return;
end

save([path,file],'ROI','h_ROI','ROISem');

