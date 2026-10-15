function u = controltgt(t,X,jet)
% u = controltgt(t,state,jet)
% calcule le vecteur de sortie pour la commande par le linéarisé tangent
% entrées :
% t : temps (scalaire)
% state : état  du PTVOL  (vecteur de dim = 8)
% state = [x(t) dx/dt(t) z(t) dz/dt(t) theta(t) d theta/dt(t) F1 F2]
%
% jet : trajectoire de référence et ses dérivées jusqu'à l'ordre 4
% jet(1) = x_ref,%  jet(2) = dx_ref/dt, ..., jet(5) = d^5x_ref/dt^5
% jet(6) = z_ref, ..., jet(10) = d^5z_ref/dt^5
% Sortie :
% u: vecteur de dimension 2 : [u1;u2]
% où u1 et u2 sont les commandes
global param_ gains_

g = param_(1);
a = param_(2);
b = param_(3);
gain1 = gains_(1,:);
gain2 = gains_(2,1:2);
%%%%%%%% A Modifier   %%%%%%%%%%%%%%%%%%%
x_ref = jet(1);
dx_ref = jet(2);
d2x_ref = jet(3);
d3x_ref = jet(4);
d4x_ref = jet(5);

z_ref = jet(6);
dz_ref = jet(7);
d2z_ref = jet(8);

x = X(1);
dx = X(2);
z = X(3);
dz = X(4);
theta = X(5);
dtheta = X(6);

d2x = -g * theta;
d3x = -g * dtheta;

delta_v1 = d2z_ref + gain2(1) * (z_ref - z) + gain2(2) * (dz_ref - dz);

delta_v2 = -1/g * (d4x_ref + gain1(1) * (x_ref - x) + ...
                             gain1(2) * (dx_ref - dx) + ...
                             gain1(3) * (d2x_ref - d2x) + ...
                             gain1(4) * (d3x_ref - d3x));

v1 = g + delta_v1;
v2 = 0 + delta_v2;

v = [v1; v2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = [a*v(1)+b*v(2); a*v(1)-b*v(2)]/2;
end
