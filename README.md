# PR_assignment

### HOGfeature.m

This is main function of using HOG extraing features, the main function, can be applied in two scenarios.

`Note:` if you are going to use `vl_hog` in my_rep.m, please uncomment the following lines in `HOGfeature.m` when you first run the file. You may want to comment it until you restart MATLAB next time because it slows down the code.

`run('vlfeat-0.9.20/toolbox/vl_setup')`

 `vl_version verbose`

### my_rep.m

This is the function to extract HOG. Three methods. Usually method 2 is the most stable one.

### HOG.m

This is another functinon for `HOG()`. Pretty useless because of the high error. But sometimes if you have an error of 90%, try this maybe. 
