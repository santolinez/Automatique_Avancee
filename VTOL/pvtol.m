function dX=pvtol(t,X,u)
% Dynamical equations of the PVTOL

global param_
param = param_;
%param(5) = 20;
%param_ = [10 10000 10000 .1 20];
% param_(1) = g
% param_(2) = m/Calpha = a
% param_(3) = J/l/Calpha = b
% param_(4) = epsilon = Talpha
% param_(5) = lambda
Ctheta = cos(X(5));
Stheta = sin(X(5));
v = [(X(7)+X(8))/param(2); (X(7)-X(8))/param(3)];
dX = [...
  X(2)
  -v(1)*Stheta + param(4)*v(2)*Ctheta
  X(4)
  v(1)*Ctheta + param(4)*v(2)*Stheta - param(1)
  X(6)
  v(2)
  param(5)*( u(1) - X(7) )
  param(5)*( u(2) - X(8) ) ];
end
