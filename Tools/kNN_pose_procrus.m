% re-rank the top k nearest neighbors by procrustes analysis
% pred: the prediction 2D pose
% M_pool: the 2D pose library for matching
% GT_pool: the 3D pose library
% k: the number of extracted nearest candidates
function j_NN = kNN_pose_procrus(M_pool,GT_pool,pred,k)
    temp = zeros(1,28);
    temp_root = 0.5 * (pred(9,:) + pred(12,:));
    for a = 1:14
        temp(1,a*2-1) = pred(a,1) - temp_root(1);
        temp(1,a*2) = pred(a,2) - temp_root(2);
        y_c(a) = temp(1,2*a);
    end
    scale = max(y_c)-min(y_c);
    temp = temp / scale;
    m_idx = knnsearch(M_pool,temp,'k',k);
    e = zeros(1,k);
    for ii=1:k
        j_2d = GT_pool(m_idx(ii),:);
        j_2d = reshape(j_2d,3,14);
        j_2d = double(j_2d'); 
        
        scale = (max(j_2d(:,2))-min(j_2d(:,2)))/(max(pred(:,2))-min(pred(:,2)));
        %jroot=mean(j_2d(:,1:2));
        %lsum = j_2d(:,1:2)-repmat(jroot,14,1);
        %jroot_p = mean(pred(:,1:2)*scale);
        %lsu = pred(:,1:2)*scale - repmat(jroot_p,14,1);
        %temp = lsum - lsu;%*scale;
        %e(ii) = mean(sqrt(temp(:,1).^2+temp(:,2).^2));
        
        
        [~, Z, trans] = procrustes(j_2d(:,1:3),pred(:,1:2)*scale,'reflection',false,'scaling',false);
        su = j_2d(:,1:2)-Z(:,1:2);
        Sum = zeros(size(su,1),1);
        for i = 1:size(su,2)
            Sum = Sum+su(:,i).^2;
        end
        
        e(ii) = mean(sqrt(Sum));
        T(ii) = trans;
        %e(ii) = MPJPE_procrus(j_2d(:,1:2),pred(:,1:2));
        %e(ii) = MPJPE_procrus([pred(:,1:2)*scale, j_2d(:,3)] ,j_2d);
        
    end
        
    [~,iid] = min(e);
    j_2d = GT_pool(m_idx(iid),:);
    j_2d = reshape(j_2d,3,14);
    j_NN = double(j_2d');
    %j_NN = j_NN * inv(T(iid).T);
end