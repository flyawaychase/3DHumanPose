# 3D Human Pose Estimation = 2D Pose Estimation + Matching

### Contact
Ching-Hang Chen

email: flyawaychase@gmail.com

This matlab code demo the 3D human pose estimation from single RGB image with given 2D pose landmarks. The 2D pose can be derived by state-of-the-art CNN such as CPM (https://github.com/shihenw/convolutional-pose-machines-release) or Hourglass

## Demo Videos
Before start, check out the demo videos!

https://www.youtube.com/watch?v=T_gEx7eQqEg

https://www.youtube.com/watch?v=uGBKZ7QQlDI


## Getting Started

Download the 3D pose library from the following link:
https://drive.google.com/file/d/0BxZCS0CAHYZpRjA2S1FsWDNhcEU/view?usp=sharing&resourcekey=0-sQrEU466ZG3Ty-ulY-cpaQ

Usage:
 1. Open Matlab, set and include current directory to "Release", put "3D_library.mat" in "Release" folder
 2. Run demo.m (few examples are provided with associated 2D pose by CPM)
 3. Implement 2D pose estimation (ex. CPM or Hourglass) to run your own examples
 4. Change the input image in demo.m (line 26) and load your own 2D pose estimation (line 32)

## Reference
3D Human Pose Estimation = 2D Pose Estimation + Matching
http://arxiv.org/abs/1612.06524
