% evaluate MPJPE up to a rigid transformation
function error = MPJPE(j_gt,j_p)
        % j_gt: ground truth 3D pose
        % j_p: prediction 3D pose
        % rigid transformation
        [R, t] = H_getRigidTransform(j_p, j_gt);
        su = (R * j_p' + repmat(t,[1,14]))' - j_gt;
        Sum = su(:,1).^2+su(:,2).^2+su(:,3).^2;
        error = mean(sqrt(Sum));

end