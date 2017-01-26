function [dataset] = my_rep_imfeature_nist(m)

addpath('/prtools')
addpath('/coursedata')

warning('off','all')

% Remove all empty rows, columns
a=m;



feat_size = 64;  % Change size of the image here!

a = m*im_box([],0);
% add a bounding box to the images to make it square.
a = a*im_box([],0,1);
% resample the images.
method = 'bilinear';% 'nearest'; % To test: bilinear and bicubic.  % Change method here!
a = a*im_resize([],[feat_size,feat_size], method);
% add rows and columns to have a square image.
% a = a*im_box(1,0);


dataset = prdataset(a, getlabels(a));
dataset = im_features(dataset, 'all');
