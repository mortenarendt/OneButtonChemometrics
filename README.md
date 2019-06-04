# OneButtonChemometrics
Scripts for automated calibration

This repo contains a pipeline for a fully automated calibration pipeline handling outlier removal, selection of preprocessing, variable selection and selection of number of components for PLS modelling. 

The pipeline were developed as a benchmark to compare with the performance of manual modelling building conduted by more or less experienced chemometricians. 

The OB.m contains the pipeline, preprocessing_methods.mat five NIR-relevant preprocessing methods and removeoutliers - a function for outlier removal based on Hotellings T2 and Q-residuals. The rest of the functionallity is engined by the PLS toolbox (ver 8.7) (Eigenvector Inc.)

The data folder contains three sets of NIR data with a calibration set and a testset.
