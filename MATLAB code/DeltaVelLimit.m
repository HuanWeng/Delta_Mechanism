function DeltaVelLimit( R1,R2,L1,L2,p,scale )
%Given the position of Delta robot, output the 3D plot of velocity limit
%   Example
%{
R1 = 1;
R2 = 0.5;
L1 = 1;
L2 = 1;
p = [0,0.3,1.3];
scale = 0.3;
DeltaVelLimit( R1,R2,L1,L2,p,scale )
%}

% construct unit sphere
r = scale;
nphi = 30;
ntheta = 40;
phi = linspace(0,pi,nphi);
theta = linspace(0,2*pi,ntheta);
[phi,theta] = meshgrid(phi,theta);
x = r*sin(phi).*cos(theta);
y = r*sin(phi).*sin(theta);
z = r*cos(phi); 

% Jacobian
J = DeltaJacobian( R1,R2,L1,L2,p );
xj = x;
yj = y;
zj = z;
for i=1:ntheta
    for j=1:nphi
        xyzj = J*[x(i,j);y(i,j);z(i,j)];
        xj(i,j) = xyzj(1);
        yj(i,j) = xyzj(2);
        zj(i,j) = xyzj(3);
    end
end
xj = p(1)*ones(ntheta,nphi)+xj;
yj = p(2)*ones(ntheta,nphi)+yj;
zj = p(3)*ones(ntheta,nphi)+zj;

figure
mesh(xj,yj,zj,'edgecolor','c')
alpha(0.1)
hold on

[thetalist,] = DeltaIkin(R1,R2,L1,L2,p);
DeltaVisualization( R1,R2,L1,L2,p,thetalist );
hold on

axeslength = scale;
plot3([0,axeslength],[0,0],[0,0],'LineWidth',1.5,'Color',[1,0,0])
plot3([0,0],[0,axeslength],[0,0],'LineWidth',1.5,'Color',[0,1,0])
plot3([0,0],[0,0],[0,axeslength],'LineWidth',1.5,'Color',[0,0,1])
vbx = p+[axeslength,0,0];
vby = p+[0,axeslength,0];
vbz = p+[0,0,axeslength];
plot3([p(1),vbx(1)],[p(2),vbx(2)],[p(3),vbx(3)],'LineWidth',1.5,'Color',[1,0,0])
plot3([p(1),vby(1)],[p(2),vby(2)],[p(3),vby(3)],'LineWidth',1.5,'Color',[0,1,0])
plot3([p(1),vbz(1)],[p(2),vbz(2)],[p(3),vbz(3)],'LineWidth',1.5,'Color',[0,0,1])
axis equal

end

