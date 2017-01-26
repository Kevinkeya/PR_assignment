clc
clear
close all

% Suppressing warning
warning('off','all')

addpath('prtools')
addpath('coursedata')



%%
% This is for "vl_hog"...
% 
% http://www.vlfeat.org/download.html
% Only need to run this at first time when you start up MATLAB
% Please uncomment the following two lines.
run('vlfeat-0.9.20/toolbox/vl_setup')
vl_version verbose

%%
%Set scenario
% scenario1: 10*200 in this case
scenario=2;

%Set online test, true if you want online test.
live=true;
method=1

%Default setting
load_interval=5;
loadRatio=5;


% scenario2: 10*10 in this case
if scenario==2
    load_interval=100;
    loadRatio=100;
end

% Using to store time, can be any dimension array.
t=zeros(7,1);

%start counting time
% tic;

prnist_data = prnist([0:9],[1:load_interval:1000]);
% prnist_data = prnist([0:9],[1:1000/loadRatio]);

% Generating dataset with HOG as features
dataset=my_rep(prnist_data);

% First time
% t(1)=toc;

%Here you can choose different classfiers


% s= svc(proxm('p',2) );
% s= qdc();
% s = loglc();
% s= ldc();

% s = knnc([],2);
% W = bpxnc(dataset,13,1000);
s = parzenc();

W = dataset*s;

% Second time gap, usually as the training time
% t(2)=toc-t(1);



% Pick up one s2 if you want

% s2=loglc();
% s2= svc(proxm('r',1) );
% s2= nmc();
% % W2 = bpxnc(dataset,13,1000);
s2 = fisherc();
W2 = dataset*s2;

% Time agian
% t(3)=toc-t(2);

% Pick up one s3 if you want
% s3 = knnc([],2);
% s3=qdc();
% s3=svc(proxm('r',1) );
% s3 = loglc();
% W3 = dataset*s3;
% t(4)=toc-t(3);

W3 = bpxnc(dataset,11,1000);

% Combined classfier setting if you want
W_array=[W W2 W3];
% W_array = [W W2];
cvote=W_array*votec; %votec
cmax=W_array*maxc;
% 
% t(5)=toc-t(4);


%Test Error from benchwork
error1=nist_eval('my_rep',W,100);
% t(3)=toc-t(2);
% 
% t(5)=toc-t(5);
error2=nist_eval('my_rep',W2,100);
% t(6)=toc-t(5);
error3=nist_eval('my_rep',W3,100);
% t(7)=toc-t(6);

votec_error=nist_eval('my_rep',cvote,100);
maxc_error=nist_eval('my_rep',cmax,100);
error_combined =  min(votec_error,maxc_error);

% Test error from Live test.
if live == true
    liveDate=getLiveDataHOG(method);
    errorLive1=testc(liveDate*W);
    errorLive2=testc(liveDate*W2);
    errorLive3=testc(liveDate*W3);
    votec_errorLive=testc(liveDate*cvote);
    maxc_errorLive=testc(liveDate*cmax);
    error_combinedLive =  min(votec_errorLive,maxc_errorLive);
   
end

% To remove waiting bar
prwaitbar off;