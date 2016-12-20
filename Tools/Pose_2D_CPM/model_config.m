function param = model_config()
%% set the parameters for CNN forward
% CPU mode or GPU mode
param.use_gpu = 1;

% GPU device number
GPUdeviceNumber = 0;

param.click = 1;

% Scaling paramter: starting and ending ratio of person height to image
% height, and number of scales per octave
param.starting_range = 0.5;
param.ending_range = 0.5;
param.octave = 2;


%% don't edit this part
% path of your caffe
caffepath = textread('caffePath.cfg', '%s', 'whitespace', '\n\t\b ');
disp(caffepath);
caffepath = [caffepath{1} '/matlab/'];
addpath(caffepath);

if(param.use_gpu)
    caffe.set_mode_gpu();
    caffe.set_device(GPUdeviceNumber);
else
    caffe.set_mode_cpu();
end
caffe.reset_all();
                     
param.model(1).caffemodel = 'CPM_models/pose_iter_630000.caffemodel';
param.model(1).deployFile = 'CPM_models/pose_deploy_centerMap.prototxt';
param.model(1).description = 'MPII 6 stage L level';
param.model(1).boxsize = 368;
param.model(1).padValue = 128;
param.model(1).np = 14;
param.model(1).limbs = [1 2; 3 4; 4 5; 6 7; 7 8; 9 10; 10 11; 12 13; 13 14];
param.model(1).part_str = {'head', 'neck', 'Rsho', 'Relb', 'Rwri', ...
                         'Lsho', 'Lelb', 'Lwri', ...
                         'Rhip', 'Rkne', 'Rank', ...
                         'Lhip', 'Lkne', 'Lank', 'bkg'};

                     
param.model(2).caffemodel = 'CPM_models/person_iter_70000.caffemodel';
param.model(2).deployFile = 'CPM_models/person_deploy.prototxt';
param.model(2).description = 'detect person model';
param.model(2).boxsize = 368;
param.model(2).padValue = 128;
param.model(2).np = 1;
%{
param.model(3).caffemodel = '/home/capstone/capstone126/ching/human3D/H80K/caffe_model/9th/1st/3Dpose_iter_20000.caffemodel';
param.model(3).deployFile = '/home/capstone/capstone126/ching/human3D/H80K/prototxt/1st_train/pose_deploy.prototxt';
param.model(3).description = 'MPII 6 stage L level';
param.model(3).boxsize = 368;
param.model(3).padValue = 128;
param.model(3).np = 14;
param.model(3).limbs = [1 2; 3 4; 4 5; 6 7; 7 8; 9 10; 10 11; 12 13; 13 14];
param.model(3).part_str = {'head', 'neck', 'Rsho', 'Relb', 'Rwri', ...
                         'Lsho', 'Lelb', 'Lwri', ...
                         'Rhip', 'Rkne', 'Rank', ...
                         'Lhip', 'Lkne', 'Lank', 'bkg'};

%}
end
