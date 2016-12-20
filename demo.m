% demo code for 3D human pose estimation from a monocular RGB image
% this demo code uses CPM (Convolutional Pose Machines) for 2D pose
% estimation, however, any 2D pose estimator from image can be applied.
% prediction: The 2D pose, a 14X2 matrix, 14 corresponding position as
% listed in the following order, 3 columns with [x y] coordinates.
% (head)
% (neck)
% (right shoulder)
% (right elbow)
% (right wrist)
% (left shoulder)
% (left elbow)
% (left wrist)
% (right hip)
% (right knee)
% (right ankle)
% (left hip)
% (left knee)
% (left ankle)

%% setup
% param = model_config();
load('3D_library.mat');

%% input image path
test_image = ['imgs/im0371.jpg'];
im = imread(test_image);

% load the precomputed 2D pose derived by Convolutional Pose Machines,
% other 2D pose estimation methods is applicable, format the 2D pose in the
% definition described above
load('0371.mat');

%{
% get image size
[H,W,~] = size(im);

%% detect human using CPM
rectangle(1) = 1; 
rectangle(2) = 1;
rectangle(3) = W-1;
rectangle(4) = H-1;
[heatMaps, human_c] = applyModel_human3d(test_image, param, rectangle, 2);

%% 2D pose estimation using CPM with the bounding box specified by the
% detected human postition
rectangle(1) = human_c(1) - 0.5*W;
rectangle(2) = human_c(2) - 0.5*H;
rectangle(3) = 1*W;
rectangle(4) = 1*H;
[heatMaps, prediction] = applyModel_human3d(test_image, param, rectangle, 1);
%}
Prediction{1}=prediction;

% manually adjust two hips' position due to the variation across MPII and
% H36M
prediction(9,2) = prediction(9,2) - 20;
prediction(12,2) = prediction(12,2) - 20;

%% extract the nearest neighbor 
[j_p] = NN_pose(s1_s9_2d_n,s1_s9_3d,prediction);
% [j_p] = kNN_pose_procrus(s1_s9_2d_n,s1_s9_3d,prediction, 10);

% compute the scale between pixel and real world to recover real size of
% prediction
scale = (max(j_p(:,2))-min(j_p(:,2)))/(max(prediction(:,2))-min(prediction(:,2)));

% predict the depth of each joint by the exemplar
prediction(:,3) = j_p(:,3)/scale;


%% visualization
H=figure(); 
subplot(1,3,[1 2]);imshow(im);
% self-defined ground plane
prediction(:,3) = prediction(:,3) - min(prediction(:,3)) + 1300;
an_x_m = min(prediction(:,1));
an_x_M = max(prediction(:,1));
an_y_M = max(prediction(11,2),prediction(14,2));
x = [an_x_m-100 an_x_M+100 an_x_m-100 an_x_M+100];
y = [an_y_M-10 an_y_M-10 an_y_M+40 an_y_M+40];
z = [min(prediction(:,3)-120) min(prediction(:,3)-120) max(prediction(:,3)+120) max(prediction(:,3)+120)];
A = [x(:) y(:) z(:)];
% solve for the ground plane
[n,v,m,aved]=plane_fit(A);

% draw the prediction on the input image
vis_2d(prediction);

% draw the 3D pose
subplot(1,3,3);
vis_3d(prediction);

% draw the ground plane
planeplot(A,n,m)

% draw camera
scale = 50;
P = scale*[0 0 0;0.5 0.5 0.8; 0.5 -0.5 0.8; -0.5 0.5 0.8;-0.5 -0.5 0.8];
cen = mean(prediction);P1=(P+repmat([cen(1:2), 800],[5,1]));
line([P1(1,1) P1(2,1)],[P1(1,2) P1(2,2)],[P1(1,3) P1(2,3)],'color','k')
line([P1(1,1) P1(3,1)],[P1(1,2) P1(3,2)],[P1(1,3) P1(3,3)],'color','k')
line([P1(1,1) P1(4,1)],[P1(1,2) P1(4,2)],[P1(1,3) P1(4,3)],'color','k')
line([P1(1,1) P1(5,1)],[P1(1,2) P1(5,2)],[P1(1,3) P1(5,3)],'color','k')

line([P1(2,1) P1(3,1)],[P1(2,2) P1(3,2)],[P1(2,3) P1(3,3)],'color','k')
line([P1(3,1) P1(5,1)],[P1(3,2) P1(5,2)],[P1(3,3) P1(5,3)],'color','k')
line([P1(5,1) P1(4,1)],[P1(5,2) P1(4,2)],[P1(5,3) P1(4,3)],'color','k')
line([P1(4,1) P1(2,1)],[P1(4,2) P1(2,2)],[P1(4,3) P1(2,3)],'color','k')

% adjust the viewing angle
view(26,-56);
axis equal
axis off