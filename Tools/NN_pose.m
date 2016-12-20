% Extract the nearest exemplar from 3D pose library
% pool_2d: the 2D pose library for matching
% pool_3d: the 3D pose library
% pred: the prediction 2D pose
function [j_p] = NN_pose(pool_2d,pool_3d,pred)
    temp = zeros(1,28);
    temp_root = 0.5 * (pred(9,:) + pred(12,:));
    for a = 1:14
        temp(1,a*2-1) = pred(a,1) - temp_root(1);
        temp(1,a*2) = pred(a,2) - temp_root(2);
        y_c(a) = temp(1,2*a);
    end
    scale = max(y_c)-min(y_c);
    temp = temp / scale;
    
    [~,m_idx] = min(pdist2(temp, pool_2d));
    j_p = pool_3d(m_idx,:);
    j_p = reshape(j_p,3,14);
    j_p = double(j_p');
end