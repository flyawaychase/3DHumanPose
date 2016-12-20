% evaluate MPJPE up to a similarity transformation
function error = MPJPE_procrus(j_gt,j_p)
        % j_gt: ground truth 3D pose
        % j_p: prediction 3D pose
        %procrustes analysis
        [~, Z] = procrustes(j_gt,j_p,'reflection',false);
        su = j_gt-Z;
        Sum = zeros(size(su,1),1);
        for i = 1:size(su,2)
            Sum = Sum+su(:,i).^2;
        end
        %Sum = su(:,1).^2+su(:,2).^2+su(:,3).^2;
        error = mean(sqrt(Sum));

end