function [R,t] = H_getRigidTransform(A, B)
cenA = mean(A);
cenB = mean(B);
% R*A + t approximate to B

N = size(A,1);
% H = (A - repmat(cenA, N, 1))' * (B - repmat(cenB, N, 1));

H = (B - repmat(cenB, N, 1))' * (A - repmat(cenA, N, 1));
[U,S,V] = svd(H);
R = U*V';
if det(R) < 0
   U(:,3) = - U(:,3);
   R = U*V';
end
t = -R*cenA' + cenB';
end