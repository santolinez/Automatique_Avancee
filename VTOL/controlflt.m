function output = controlflt(t,state,jet)
% output = controlflt(t,state,jet)
% calcule le vecteur de commande et le champ de vecteur d'état du contrôleur
% pour la commande par platitude
% Entrées :
% t : temps (scalaire)
% state : état combiné du PTVOL et de son contrôleur (vecteur de dim = 10)
% state = [x(t) dx/dt(t) z(t) dz/dt(t) theta(t) d theta/dt(t) F1 F2 ...
%          zeta1 zeta2]
% où zeta1 et zeta2 = états du contrôleur
%
% jet : trajectoire de référence et ses dérivées jusqu'à l'ordre 4
% jet(1) = x_ref,%  jet(2) = dx_ref/dt, ..., jet(5) = d^5x_ref/dt^5
% jet(6) = z_ref, ..., jet(10) = d^5z_ref/dt^5
% Sortie :
% output : vecteur de dimension 4 : [u1;u2;der_z1;der_z2]
% où u1 et u2 sont les commandes 
% et der_z1 et der_z2 sont les dérivées des états du contrôleur dynamique.


global  param_ gains_
g = param_(1);
a = param_(2);
b = param_(3);
epsilon =  param_(4);

gain1 = gains_(1,:);
gain2 = gains_(2,:);

X = state(1:6);
z = state(9:10);

Stheta = sin(X(5));
Ctheta = cos(X(5));
%%%% A modifier %%%%%%%%%%%

w = [0;0];
v = [0;0];
der_z = [0;0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = [a*v(1)+b*v(2); a*v(1)-b*v(2)]/2;

output = [u;der_z];
end
