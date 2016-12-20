function planeplot(A,n,m)

K=convhull(A(:,1),A(:,2));%,(n(1).*(m(1)-A(:,1))+n(2).*(m(2)-A(:,2))+n(3).*m(3))./n(3));
%[X,Y] = meshgrid(linspace(min(A(:,1)),max(A(:,1)),2),linspace(min(A(:,2)),max(A(:,2)),2));
X=A(K,1); Y= A(K,2); %Z=A(K,3);
Z=(n(1).*(m(1)-X)+n(2).*(m(2)-Y)+n(3).*m(3))./n(3);
%plot the plane
%figure();
%plot3(A(:,1),A(:,2),A(:,3),'.'); 
hold on;
%surf(reshape(X,2,2),reshape(Y,2,2),reshape(Z,2,2),'facecolor','blue','facealpha',0.5);
fill3(X,Y,Z,'k','facealpha',0.3);
%fill3(A(:,1),A(:,2),(n(1).*(m(1)-A(:,1))+n(2).*(m(2)-A(:,2))+n(3).*m(3))./n(3),'g','facealpha',0.5);

%plot the normal vector
%quiver3(m(1),m(2),m(3),10*n(1),10*n(2),10*n(3),'b','linewidth',2)

end