3D Human Pose Estimation = 2D Pose Estimation + Matching

This package matlab code demo the 3D human pose estimation form single RGB image with given 2D pose landmarks. The 2D pose can be derived by state-of-the-art CNN such as CPM (https://github.com/shihenw/convolutional-pose-machines-release) or Hourglass

Download the 3D pose library from the following link:
https://drive.google.com/file/d/0BxZCS0CAHYZpRjA2S1FsWDNhcEU/view?usp=sharing

Usage:
 1. Implement a 2D pose estimation approach (ex. CPM or Hourglass)
 2. Open Matlab, set and include current directory to "Release", put "3D_library.mat" in "Release" folder
 3. Run demo.m (few examples are provided with associated 2D pose by CPM)
 4. Test your own image: Change the input image in demo.m (line 26) and load your own 2D pose estimation (line 32)

