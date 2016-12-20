% solve for a plane's normal and center
function [n,v,m,aved]=plane_fit(A)
% A: input 3d points(N by 3)
% n: plane normal vector
% v: plane parallel vectors
% m: mean of input 3d points
% aved: average distance of points to the derived plane

m = mean(A,1);
R = bsxfun(@minus,A,m);
[v,~] = eig(R'*R);
n = v(:,1);
v = v(:,2:end);

%calculate the average distance
d=(A-repmat(m,length(A),1))*n;
aved=mean(abs(d));

end

