% Re-rank the top k candidates by searching a transformation when given camera intrinsics
% pred: the prediction 3D pose
% M_pool: the 2D pose library for matching
% GT_pool: the 3D pose library
% k: the number of extracted nearest candidates
% cameraParams: a camera object compatible with Matlab 
function j_NN = kNN_cam_align(M_pool,GT_pool,pred,k,cameraParams)
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
        
        %scale = (max(j_2d(:,2))-min(j_2d(:,2)))/(max(pred(:,2))-min(pred(:,2)));
        [r,~] = extrinsics(pred(:,1:2),j_2d,cameraParams);
        
        p2d = j_2d*r*cameraParams.IntrinsicMatrix';
        [~,Z] = procrustes(p2d,pred(:,1:2));
        su = j_2d(:,1:2)-Z(:,1:2);
        Sum = zeros(size(su,1),1);
        for i = 1:size(su,2)
            Sum = Sum+su(:,i).^2;
        end
        e(ii) = mean(sqrt(Sum));
        
        %e(ii) = MPJPE_procrus(pred(:,1:2),j_2d(:,1:2));
        %e(ii) = MPJPE_procrus([pred(:,1:2)*scale, j_2d(:,3)] ,j_2d);
        
    end
        
    [~,iid] = min(e);
    j_2d = GT_pool(m_idx(iid),:);
    j_2d = reshape(j_2d,3,14);
    j_NN = double(j_2d'); 
end