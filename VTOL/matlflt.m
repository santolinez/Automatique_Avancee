function derState = matlflt(t,state)
% donne le champ de vecteur de l'équation du PVTOL en boucle fermée avec la
% commande par platitude
% state(1) = x
% state(2) = xdot
% state(3) = z
% state(4) = zdot
% state(5) = theta
% state(6) = thetadot
% state(7) = F1
% state(8) = F2
% state(9) = zeta1
% state(10) = zeta2

global trajData_ % données de la trajectoire de référence (cf fonction traj)

jet = traj(t,trajData_);
output = controlflt(t,state,jet);
u = output(1:2);
derState = [pvtol(t,state(1:8),u); output(3:4)];
end
