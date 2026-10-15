function jet = traj(t,trajData)
% calcule la trajectoire de référence et ses dérivées jusqu'à l'ordre 4
xi = trajData(1);
zi = trajData(2);
xf = trajData(3);
zf = trajData(4);
tf = trajData(5);

s = sat(t,tf);

jet1 = [...
	xi + (xf-xi)*s(1);
	(xf-xi)*s(2);
	(xf-xi)*s(3);
	(xf-xi)*s(4);
	(xf-xi)*s(5) ];

jet2 = [...
	zi + (zf-zi)*s(1);
	(zf-zi)*s(2);
	(zf-zi)*s(3);
	(zf-zi)*s(4);
	(zf-zi)*s(5) ];
	
 jet = [jet1;jet2];
end

function jet = sat(t,tf)
% vecteur [P(tau), dP/dt(tau),...,d4P/dt4P(tau)] où polynome P tel que P(1)=1
% et P(i)(0)=0 pour i=0,1, ..., 4 et P(i)(1)=0 i=1,...4
a = [126, -420, 540, -315, 70];

tau=max( min(t/tf,1) , 0 );
tau2=tau*tau;
tau3=tau2*tau;
tau4=tau3*tau;
tau5=tau4*tau;

jet = [tau5*(a(1)+tau*(a(2)+tau*(a(3)+tau*(a(4)+tau*a(5)))));
	tau4*(5*a(1)+tau*(6*a(2)+tau*(7*a(3)+tau*(8*a(4)+tau*9*a(5)))))/tf;
	tau3*(20*a(1)+tau*(30*a(2)+tau*(42*a(3)+tau*(56*a(4)+tau*72*a(5)))))/tf/tf;
	tau2*(60*a(1)+tau*(120*a(2)+tau*(210*a(3)+tau*(336*a(4)+tau*504*a(5)))))/tf/tf/tf ;
	tau*(120*a(1)+tau*(360*a(2)+tau*(840*a(3)+tau*(1680*a(4)+tau*3024*a(5)))))/tf/tf/tf/tf ];
end