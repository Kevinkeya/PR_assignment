clear all;

addpath('../prtools')
addpath('../coursedata')


%% ----- Dataset preparation

%Data loading
load_interval = 1; % depends on the size of the dataset we want.
a = prnist([0:9],[1:load_interval:1000])
figure(1);
show(a)

% Preprocessing

% Remove all empty rows, columns
a = a*im_box([],0);
% add a bounding box to the images to make it square.
a = a*im_box([],0,1);
% resample the images.
a = a*im_resize([],[64,64]);
% add rows and columns to have a square image.
a = a*im_box(1,0);

figure(2)
show(a);
%show(gendat(a)) % Show the new images.
dataset = prdataset(a, getlabels(a));

% Test using no feature but only the pixels

% Feature creation
feature_dataset = im_features(dataset, 'all');

% Split into test and training sets or cross-validation!
fract_training = 0.8;
[train_set , test_set, i_train, i_test] = gendat(feature_dataset,fract_training); 

%% ------ Feature extraction (reduction)

% TO DO: choose only a part of the total features for the final dataset.

%% ------ Classifiers preparation

% TO DO: test more classifiers, ex. combined classifiers, neural networks.
classifiers = {ldc, qdc, fisherc,nmc, knnc, parzenc, svc}; 


%% ------  Evaluation
nb_repetitions = 10;

% Feature curve
fraction_training = 0.8;
feature_size = [1,3,5,7,10,12,15,17,20,22,24];
F1 = clevalf(train_set, classifiers{1}, feature_size, fraction_training, nb_repetitions);
figure();
plote(F1,'b')
hold on;
%Do th same with the other classifiers.

legend('ldc');

% Learning curve
train_size = [1,10,20,40,50,100 , 200 , 400, 500, 600, 800, 1000];
E1 = cleval(train_set, classifiers{1},train_size , nb_repetitions);
figure(3)
plote(E1,'b')
hold on;
%Do th same with the other classifiers.
legend('ldc');

%% ------ Benchmark

% m NIST prdatafile, a dataset
% a = my_rep(m)

% Compute the classifier

% e = nist_eval(filename, w, n)

%% -------