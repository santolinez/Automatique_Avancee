function u = controlio(t,X,jet)
% u = controlio(t,state,jet)
% calcule le vecteur de sortie pour la commande par linéarisation
% entrée-sortie
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
global  param_ gains_

g = param_(1);
a = param_(2);
b = param_(3);
epsilon =  param_(4);

gain1 = gains_(1,1:2);
gain2 = gains_(2,1:2);
%%% A modifier %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_ref = jet(1);
dx_ref = jet(2);
d2x_ref = jet(3);

z_ref = jet(6);
dz_ref = jet(7);
d2z_ref = jet(8);

x = X(1);
dx = X(2);
z = X(3);
dz = X(4);
theta = X(5);
dtheta = X(6);

k1 = gain2(1);
k2 = gain2(2);
l1 = gain1(1);
l2 = gain1(2);

w1 = d2x_ref + k1 * (x_ref - x) + k2 * (dx_ref - dx);
w2 = d2z_ref + l1 * (z_ref - z) + l2 * (dz_ref - dz);

v1 = (w2 + g) * cos(theta) - w1 * sin(theta);
v2 = (1 / epsilon) * (w1 * cos(theta) + (w2 + g) * sin(theta));

v = [v1; v2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = [a*v(1)+b*v(2); a*v(1)-b*v(2)]/2;
end
