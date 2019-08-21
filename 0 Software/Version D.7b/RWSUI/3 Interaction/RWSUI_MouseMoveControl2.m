%============================================
% 
%============================================
function RWSUI_MouseMoveControl2(src,event)

currentax = gca;
tab = currentax.Parent.Parent.Tag;
axnum = str2double(currentax.Tag);
MouseMoveControl(currentax,tab,axnum);