function n21 = getN21(k0,h2,theta,e1)
c1 = k0*h2;
c2 = (sin(theta)*sqrt(e1)).^2;
n21 = [1i*c1,0,1i*c1*c2];