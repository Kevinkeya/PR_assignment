clear all;

addpath('../prtools')
addpath('../coursedata')



%nb_training_data = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8];
nb_training_data = [0.8];

%feature_size = [5 6 7 8 9 10 11 12 13];
feature_size = [7 8 9 10 11 12];
test_error = zeros(length(nb_training_data) , length(feature_size));
train_error = zeros(length(nb_training_data) , length(feature_size));
test_variance = zeros(length(nb_training_data) , length(feature_size));
train_variance = zeros(length(nb_training_data) , length(feature_size));


%% ----- Dataset preparation

%Data loading
load_interval = 1; % depends on the size of the dataset we want.
prnist_data = prnist([0:9],[1:load_interval:1000])

%figure(1);
%show(a)

% Preprocessing


% First loop to vary the number of features
idx_feat = 0;
for feat_size = feature_size
    idx_feat = idx_feat + 1;
% Remove all empty rows, columns
a = prnist_data*im_box([],0);
% add a bounding box to the images to make it square.
a = a*im_box([],0,1);
% resample the images.
method = 'bicubic';% 'nearest'; % To test: bilinear and bicubic.
a = a*im_resize([],[feat_size,feat_size], method);
% add rows and columns to have a square image.
a = a*im_box(1,0);

%figure(2)
%show(a);
%show(gendat(a)) % Show the new images.
dataset = prdataset(a, getlabels(a));

% Test using no feature but only the pixels

% Feature creation
%feature_dataset = im_features(dataset, 'all');

% Split into test and training sets or cross-validation!

% Second loop to choose the number of training data
idx_data = 0;
for fract_training=nb_training_data
    idx_data = idx_data+1;
    	disp(['Config: nb_feature: ' num2str(feat_size) ' nb_data: ' num2str(fract_training) ])
%% ------ Feature extraction (reduction)

% TO DO: choose only a part of the total features for the final dataset.

%% ------ Classifiers preparation

% TO DO: test more classifiers, ex. combined classifiers, neural networks.
classifiers = {ldc, qdc, fisherc,nmc, knnc, parzenc, svc, loglc}; 
classifier = 'svc';

%% ------  Evaluation
%Last loop for the error
nb_repetitions = 1; % In order to compute mean error and variance
error_test_temp = [];
error_train_temp = [];
for repet=1:nb_repetitions
    % Classifier training
    [train_set , test_set, i_train, i_test] = gendat(dataset,fract_training); % Replace dataset by feature_dataset later. 
    W = svc(train_set,proxm('p',1) );
    length(train_set)
    error_test_temp = [error_test_temp testc(test_set*W)];
    error_train_temp = [error_train_temp testc(train_set*W)];    

end
test_error(idx_data, idx_feat) = mean(error_test_temp);
train_error(idx_data, idx_feat) = mean(error_train_temp);
test_variance(idx_data, idx_feat) = var(error_test_temp);
train_variance(idx_data, idx_feat) = var(error_train_temp);

end
end

str_title=sprintf('Error %s', classifier);
figure_saver(1) = figure('Name',str_title,'NumberTitle','on');
subplot(2,2,1)
surf(test_error)
	title('Mean Error test')
    xlabel('nb_features')
    ylabel('nb_data')
rotate3d;

subplot(2,2,2)
surf(test_variance)
	title('Var Error test')
    xlabel('nb_features')
    ylabel('nb_data')
rotate3d;

subplot(2,2,3)
surf(train_error)
	title('Mean Error train')
    xlabel('nb_features')
    ylabel('nb_data')
rotate3d;

subplot(2,2,4)
surf(train_variance)
	title('Variance Error train')
    xlabel('nb_features')
    ylabel('nb_data')
rotate3d;

save(['error_pixel_' classifier '_linear.mat'], 'test_error', 'test_variance', 'train_error', 'train_variance');
savefig(figure_saver , ['error_pixel_' classifier '_linear.fig']);
close(figure_saver);

% Feature curve
%{
fraction_training = 0.8;
feature_size = [1,3,5,7,10,12,15,17,20,22,24];
F1 = clevalf(train_set, classifiers{1}, feature_size, fraction_training, nb_repetitions);
figure();
plote(F1,'b')
hold on;
%Do th same with the other classifiers.
legend('ldc');
%}

%{
% Learning curve
train_size = [1,10,20,40,50,100 , 200 , 400, 500, 600, 800, 1000];
E1 = cleval(train_set, classifiers{1},train_size , nb_repetitions);
figure(3)
plote(E1,'b')
hold on;
%Do th same with the other classifiers.
legend('ldc');
%}




%% ------ Benchmark

% m NIST prdatafile, a dataset
% a = my_rep(m)

% Compute the classifier

% e = nist_eval(filename, w, n)

%% -------