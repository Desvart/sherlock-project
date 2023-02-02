%Ahlea Systems Corp. Pattern Recognition Toolbox
%Version 1.0, 01-Jan-96
%
%    This toolbox contains a number of routines that assist in
%    pattern recognition problems
%
%    Data Formats and Terminology:
%	DATA is stored as column vectors
%	FEATURES are stored as column vectors EXTRACTED from DATA
%	MEMBERSHIPS are stored as a row vector of class indices
%	SINGLE-CLASS STATS are comprised of the following two matrices
%           MEAN is stored as column vector
%	    COVARIANCE is stored as square matrix
%	MULTI-CLASS LISTS are comprised of the following two matrices
%	    MEANS are stored as row vectors (1 per class)
%	    COVARIANCES are stored as RESHAPED row vectors (1 per class)
%
%    Data management routines include:
%class_add      - Add class statistics to multi-class lists
%class_delete   - Delete class statistics from multi-class lists
%class_extract  - Extract class statistics from multi-class lists
%class_join     - Join members of multi-class lists
%class_multi    - Force class statistics into of multi-class lists
%class_rand     - Generate random multi-class lists
%class_split    - Divide member of multi-class lists
%
%    Statistics routines include:
%certain        - Calculate the certainties of classifications
%chi2         	- Calculate chi-squared statistic
%coveig         - Perform eigenanalysis on the covariance matrix of a data set
%dbayes         - Calculate distance of points to Gaussian clusters
%divergence     - Calculate the divergence between Gaussian classes 
%entropy        - Estimate entropy of a process (assumed Gaussian)
%estimate       - Estimate the statistics of data sets
%fuzzclassify   - Calculate the certainties of classifications
%likelihood     - Calculate likelihoods for Gaussian distributions
%mahalanobis    - Calculate Mahalanobis distance between two Gaussian classes
%normalize      - Normalize data set to zero-mean, unit-variance
%pdf            - Calculate values of p.d.f. for Gaussian distributions
%
%     Classification routines include:
%classify       - Associate feature vectors with Gaussian-distributed classes
%cluster        - A non-parametric Gaussian clustering algorithm
%kmeans         - K-means clustering algorithm
%reduce         - Reduce dimensionality of data set
%score          - Compare calculated versus known classifications
%
%    Visualization routines include:
%fillclassify   - Grid and colour the current figure according to classification
%plotboundary   - Calculate and plot the boundaries between Gaussian classes
%plotclasses    - Pretty plot of multi-class data
%plotellipse    - Draw ellipses/ellipsoids described by means and covariances
%plotoutliers   - Plot outliers boundaries

%    Utility functions for toolbox
%boundary	- Calculate the decision boundary between 2-D gaussian classes
%randnorm	- Generate some data for multi-class lists
%mini		- Index of the smallest component
%maxi		- Index of the largest component

%Copyright (c) 1993-1995 by Ahlea Systems Corp.  All rights reserved.
