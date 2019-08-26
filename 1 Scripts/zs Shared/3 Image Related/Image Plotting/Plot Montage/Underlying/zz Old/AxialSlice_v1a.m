%===================================================
% Display One Axial Slice
%===================================================

function AxialSlice_v1(IM,type,lvl,docolor,figno)

%----------------------------------------
% Extract Slice
%----------------------------------------
%slice = str2num(get(findobj('type','uicontrol','tag','slice'),'String'));
%[IM,abortflag] = Set_Volume(IM,0,0,0,0,slice,slice);
%if abortflag == 1
%    return
%end

%----------------------------------------
% Image Type
%----------------------------------------
if strcmp(type,'abs')
    IM = abs(IM);
elseif strcmp(type,'real')
    IM = real(IM);
elseif strcmp(type,'imag')
    IM = imag(IM);
elseif strcmp(type,'phase')
    IM = angle(IM);
end

%----------------------------------------
% Display Images
%----------------------------------------
figure(figno);
iptsetpref('ImshowBorder', 'tight');
imshow(IM,[lvl(1) lvl_max(2)]);
if docolor
    colormap('jet');
end
figsize = [300 300];
truesize(figno,figsize);