function [heatMaps, prediction] = applyModel_human3d(test_image, param, rectangle, modelID)

caffe.reset_all();

%% check to use click mode or not
click = param.click;

%% select model, 1 for pose estimation, 2 for person detection
model = param.model;
model = model(modelID);
boxsize = model.boxsize;
np = model.np;

%% 
oriImg = imread(test_image);
makeFigure = 0;
octave = param.octave;
starting_range = param.starting_range;
ending_range = param.ending_range;
assert(starting_range <= ending_range, 'starting ratio should <= ending ratio');
assert(octave>=1, 'octave should >= 1');

starting_scale = boxsize/(size(oriImg,1)*ending_range);
ending_scale = boxsize/(size(oriImg,1)*starting_range);
multiplier = 2.^(log2(starting_scale):(1/octave):log2(ending_scale));

% set the center and roughly scale range (overwrite the config!) according to the rectangle
    x_start = max(rectangle(1), 1);
    x_end = min(rectangle(1)+rectangle(3), size(oriImg,2));
    y_start = max(rectangle(2), 1);
    y_end = min(rectangle(2)+rectangle(4), size(oriImg,1));
    
    middle_range = (y_end - y_start) / size(oriImg,1);
    starting_range = middle_range - 0.25;
    ending_range = middle_range + 0.25;
    
    center = [(x_start + x_end)/2, (y_start + y_end)/2];
    
    starting_scale = boxsize/(size(oriImg,1)*ending_range);
    ending_scale = boxsize/(size(oriImg,1)*starting_range);
    multiplier = 2.^(log2(starting_scale):(1/octave):log2(ending_scale));

% data container for each scale
score = cell(1);;
peakValue = zeros(length(multiplier), np+1);
pad = cell(1, length(multiplier));
ori_size = cell(1, length(multiplier));

for m = 1
    scale = multiplier(m);
    imageToTest = imresize(oriImg, scale);
    ori_size{m} = size(imageToTest);
    center_s = center * scale;
    [imageToTest, pad{m}] = padAround(imageToTest, boxsize, center_s, model.padValue); 
    imageToTest = preprocess(imageToTest, 0.5);
    if(m==1 || ~click)
        caffe.reset_all();
        system(sprintf('sed -i "4s/.*/input_dim: %d/" %s', size(imageToTest,2), model.deployFile));
        system(sprintf('sed -i "5s/.*/input_dim: %d/" %s', size(imageToTest,1), model.deployFile));
        net = caffe.Net(model.deployFile, model.caffemodel, 'test');
    end
    
    score{m} = applyDNN(imageToTest, net);

    pool_time = size(imageToTest,1) / size(score{m},1);
    score{m} = imresize(score{m}, pool_time);
    score{m} = resizeIntoScaledImg(score{m}, pad{m});
    score{m} = imresize(score{m}, [size(oriImg,2) size(oriImg,1)]);
                
    if(makeFigure)
        title(sprintf('Current Scale: %f, TOTAL: %f', multiplier(m), sum(peakValue(m,1:np))));
    end
end


%% make heatmaps into the size of scaled image according to pad

    final_score = zeros(size(score{1,1}));
    for m = 1:size(score,2)
        final_score = final_score + score{m};
    end
    heatMaps = permute(final_score, [2 1 3]); 

    % generate prediction
    prediction = zeros(np,2);
    for j = 1:np
        [prediction(j,1), prediction(j,2)] = findMaximum(final_score(:,:,j));
    end

function img_out = preprocess(img, mean)
    img_out = double(img)/256;  
    img_out = double(img_out) - mean;
    img_out = permute(img_out, [2 1 3]);
    img_out = img_out(:,:,[3 2 1]);
    boxsize = 368;
    centerMapCell = produceCenterLabelMap([boxsize boxsize], boxsize/2, boxsize/2);
    img_out(:,:,4) = centerMapCell{1};

    
function scores = applyDNN(images, net)
    input_data = {single(images)};
    % do forward pass to get scores
    % scores are now Width x Height x Channels x Num
    s_vec = net.forward(input_data);
    scores = s_vec{1}; % note this score is transposed
    
function [img_padded, pad] = padAround(img, boxsize, center, padValue)
    center = round(center);
    h = size(img, 1);
    w = size(img, 2);
    pad(1) = boxsize/2 - center(2); % up
    pad(3) = boxsize/2 - (h-center(2)); % down
    pad(2) = boxsize/2 - center(1); % left
    pad(4) = boxsize/2 - (w-center(1)); % right
    
    pad_up = repmat(img(1,:,:), [pad(1) 1 1])*0 + padValue;
    img_padded = [pad_up; img];
    pad_left = repmat(img_padded(:,1,:), [1 pad(2) 1])*0 + padValue;
    img_padded = [pad_left img_padded];
    pad_down = repmat(img_padded(end,:,:), [pad(3) 1 1])*0 + padValue;
    img_padded = [img_padded; pad_down];
    pad_right = repmat(img_padded(:,end,:), [1 pad(4) 1])*0 + padValue;
    img_padded = [img_padded pad_right];
    
    center = center + [max(0,pad(2)) max(0,pad(1))];

    img_padded = img_padded(center(2)-(boxsize/2-1):center(2)+boxsize/2, center(1)-(boxsize/2-1):center(1)+boxsize/2, :); %cropping if needed

function [img_padded, pad] = padRightDownCorner(img, padValue)
    h = size(img, 1);
    w = size(img, 2);
    
    pad(1) = 76; % up
    pad(2) = 76; % left
    pad(3) = 76 + 8 - mod((152+h), 8); % down
    pad(4) = 76 + 8 - mod((152+w), 8); % right
    
    img_padded = img;
    pad_up = repmat(img_padded(1,:,:), [pad(1) 1 1])*0 + padValue;
    img_padded = [pad_up; img_padded];
    pad_left = repmat(img_padded(:,1,:), [1 pad(2) 1])*0 + padValue;
    img_padded = [pad_left img_padded];
    pad_down = repmat(img_padded(end,:,:), [pad(3) 1 1])*0 + padValue;
    img_padded = [img_padded; pad_down];
    pad_right = repmat(img_padded(:,end,:), [1 pad(4) 1])*0 + padValue;
    img_padded = [img_padded pad_right];

function [x,y] = findMaximum(map)
    [~,i] = max(map(:));
    [x,y] = ind2sub(size(map), i);
    
function score = resizeIntoScaledImg(score, pad)
    np = size(score,3)-1;
    score = permute(score, [2 1 3]);
    if(pad(1) < 0)
        padup = cat(3, zeros(-pad(1), size(score,2), np), zeros(-pad(1), size(score,2), 1));
        score = [padup; score]; % pad up
    else
        score(1:pad(1),:,:) = []; % crop up
    end
    
    if(pad(2) < 0)
        padleft = cat(3, zeros(size(score,1), -pad(2), np), zeros(size(score,1), -pad(2), 1));
        score = [padleft score]; % pad left
    else
        score(:,1:pad(2),:) = []; % crop left
    end
    
    if(pad(3) < 0)
        paddown = cat(3, zeros(-pad(3), size(score,2), np), zeros(-pad(3), size(score,2), 1));
        score = [score; paddown]; % pad down
    else
        score(end-pad(3)+1:end, :, :) = []; % crop down
    end
    
    if(pad(4) < 0)
        padright = cat(3, zeros(size(score,1), -pad(4), np), zeros(size(score,1), -pad(4), 1));
        score = [score padright]; % pad right
    else
        score(:,end-pad(4)+1:end, :) = []; % crop right
    end
    score = permute(score, [2 1 3]);
    
function label = produceCenterLabelMap(im_size, x, y) %this function is only for center map in testing
    sigma = 21;
    %label{1} = zeros(im_size(1), im_size(2));
    [X,Y] = meshgrid(1:im_size(1), 1:im_size(2));
    X = X - x;
    Y = Y - y;
    D2 = X.^2 + Y.^2;
    Exponent = D2 ./ 2.0 ./ sigma ./ sigma;
    label{1} = exp(-Exponent);