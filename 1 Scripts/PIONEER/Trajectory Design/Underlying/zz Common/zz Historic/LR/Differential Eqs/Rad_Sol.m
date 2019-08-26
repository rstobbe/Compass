%==================================
%
%==================================

function dr = Rad_Sol(t,r,flag,deradsolfunc) 

dr = 1/(r^2*deradsolfunc(r));      


