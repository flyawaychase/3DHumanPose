% evaluate MPJPE up to aligning the reference body joint (pelvis)
function error = MPJPE_h36(joint,j_p)
        % joint: ground truth 3D pose
        % j_p: prediction 3D pose
        
        %%
        %h36m
        
        jroot=[(joint(9,1)+joint(12,1))/2, (joint(9,2)+joint(12,2))/2,(joint(9,3)+joint(12,3))/2];
        
        %jroot=mean(joint);
        
        lsum = joint-repmat(jroot,14,1);
        %Lsum = mean(sqrt(lsum(:,1).^2+lsum(:,2).^2+lsum(:,3).^2));     
        
        jroot_p = [(j_p(9,1)+j_p(12,1))/2, (j_p(9,2)+j_p(12,2))/2,(j_p(9,3)+j_p(12,3))/2];
        %jroot_p = mean(j_p);
        lsu = j_p - repmat(jroot_p,14,1);
        %Lsu = mean(sqrt(lsu(:,1).^2+lsu(:,2).^2+lsu(:,3).^2));
        
        %scale = Lsum/Lsu;
        temp = lsum - lsu;%*scale;
        
        
        
        error = mean(sqrt(temp(:,1).^2+temp(:,2).^2+temp(:,3).^2));


end