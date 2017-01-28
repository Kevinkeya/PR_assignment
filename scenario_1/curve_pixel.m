clear all;

addpath('../prtools')
addpath('../coursedata')



%% ----- Dataset preparation

%Data loading
load_interval = 1; % depends on the size of the dataset we want.
prnist_data = prnist([0:9],[1:load_interval:1000])


% Preprocessing


feat_size = 8;
% Remove all empty rows, columns
a = prnist_data*im_box([],0);
% add a bounding box to the images to make it square.
a = a*im_box([],0,1);
% resample the images.
method = 'bicubic';% 'nearest'; % To test: bilinear and bicubic.
a = a*im_resize([],[feat_size,feat_size], method);
% add rows and columns to have a square image.
a = a*im_box(1,0);

dataset = prdataset(a, getlabels(a));
dataSetFeatures = im_features(dataset, 'all');

% Test using no feature but only the pixels



%% ------  Evaluation
%Last loop for the error
nb_repetitions = 5; % In order to compute mean error and variance
%nb_set = [100 200 300 400 500 600 700 800 900 1000];
nb_set = [100 200 300 400 500 600 700 800];

% Learning curve
% error = [cleval(dataset, scalem([],'variance')*pcam([],46)*knnc,nb_set,nb_repetitions) ; cleval(dataset, scalem([],'variance')*pcam([],30)*parzenc,nb_set,nb_repetitions)]; 
%error = [cleval(dataset,qdc,nb_set,nb_repetitions);cleval(dataset,knnc,nb_set,nb_repetitions);cleval(dataset,loglc,nb_set,nb_repetitions)]; 
% Feature curve
%nb_set = [5,10,15,20,25, 30, 35, 40, 45 , 50 ,55, 60 ,64];
nb_set = [5,10,15,20,24];
error = [clevalf(dataset, qdc,nb_set,0.8 , 5),clevalf(dataset, knnc,nb_set,0.8 , 5),clevalf(dataset, loglc,nb_set,0.8 , 5)]; 

H = plote(error)
   