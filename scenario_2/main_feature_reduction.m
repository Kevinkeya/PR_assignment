clear all;

addpath('../prtools')
addpath('../coursedata')

% In this scenario we have 10 objects for training. And we will take 240
% objects for testing (for each class).

%variance_fraction = [0.6 0.8 0.97];
%variance_fraction = [0.7];
variance_fraction = [0.8 0.9 0.97];
%variance_fraction = [0.97];
%feature_size = [5 6 7 8 9 10 11 12 13 14 15 16 17];
feature_size = [10 15 20 25];
%feature_size = [8];

%feature_size = [12 14 16 18];
test_error = zeros(length(feature_size),length(variance_fraction));
train_error = zeros(length(feature_size),length(variance_fraction));
test_variance = zeros(length(feature_size),length(variance_fraction));
train_variance = zeros(length(feature_size),length(variance_fraction));


%% ----- Dataset preparation


% Preprocessing


% First loop to vary the number of features
idx_feat = 0;
for feat_size = feature_size
    idx_feat = idx_feat + 1;

% Test using no feature but only the pixels

% Split into test and training sets or cross-validation!

% Second loop to choose the number of training data


%% ------ Classifiers preparation

% TO DO: test more classifiers, ex. combined classifiers, neural networks.
classifiers = {ldc, qdc, fisherc,nmc, knnc, parzenc, svc, loglc}; 
classifier = 'ldc';

%% ------  Evaluation
%Last loop for the error
nb_repetitions = 5; % In order to compute mean error and variance
error_test_temp = [];
error_train_temp = [];
frac = 1;
for varFrac = variance_fraction
    disp(['Config: nb_feature: ' num2str(feat_size) ' Var frac: ' num2str(varFrac)])

for repet=1:nb_repetitions
    %Data loading
    load_interval = 4; % depends on the size of the dataset we want.
    prnist_data = prnist([0:9],[nb_repetitions:load_interval:1000])
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

    
    
    % Classifier training
    [train_set , test_set, i_train, i_test] = gendat(dataSetFeatures,[10,10,10,10,10,10,10,10,10,10]); % Replace dataset by feature_dataset later. 
    s = scalem([],'variance')*pcam([],varFrac)*knnc;
    W = train_set*s;
    %disp(['train set size ' num2str(size(train_set))])
    error_test_temp = [error_test_temp testc(test_set*W)];
    error_train_temp = [error_train_temp testc(train_set*W)];    

end
test_error(idx_feat,frac) = mean(error_test_temp);
train_error(idx_feat,frac) = mean(error_train_temp);
test_variance(idx_feat,frac) = var(error_test_temp);
train_variance(idx_feat,frac) = var(error_train_temp);
frac= frac +1;
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


