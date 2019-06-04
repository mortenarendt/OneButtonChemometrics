clear; close all;
%%
% load datasets % fill in path and file
% set x and y
x = Xcal;
y = Ycal;
load preprocessing_methods.mat

% set constant things
cvi = {'rnd' 10 3}; % method for cross validation

% set design
f2 = [0 10 20 30]; % percentage of outliers to remove
ncomp = 20; % max number of components

% create design
DOE =     fullfact([length(PP) length(f2) 2 ncomp]);

% results prealocated. 
USEvariables = false(size(x,2),size(DOE,1)); 
USEsample = false(size(x,1),size(DOE,1)); 
RMSECV = NaN(size(DOE,1),1);
LV_varsel = NaN(size(DOE,1),1);

% set options for PLS, crossvalidation and selectvars

opt_cv = crossval('options');
opt_pls = pls('options');
opt_sv = selectvars('options');

opt_pls.plots = 'off';
opt_pls.display = 'off';
opt_cv.plots = 'off';

opt_sv.cvsplit = cvi;
%opt_sv.waitbar = 'off';
opt_sv.plots = 'off';

% loop over all combinations, and collect model settings and CV-performance
for i=1:max(DOE(:,1))
    ppX = PP{DOE(i,2)};
    
    % Factor 1 - preprocessing
    opt_cv.preprocessing = {ppX pp_y};
    opt_pls.preprocessing = {ppX pp_y};
    opt_sv.preprocessing = {ppX pp_y};
    for ii=1:max(DOE(:,2))
        % Pre-modeling Factor 2 - outlier removal
        prc = f2(ii);
        IDkeep = removeoutliers(x,y,ncomp,opt_pls,prc);
        
        for iiii=1:max(DOE(:,4))
            x.include{1} = find(IDkeep(:,iiii));
            y.include{1} = find(IDkeep(:,iiii));
            
            for iii=1:2
                [i ii iii iiii]
                if iii==1 % perform just crossvalidation
                    mdl = crossval(x,y,'sim',cvi,iiii,opt_cv);
                    rmsecv = mdl.rmsecv(iiii);
                    use = x.include{2};
                    lvs_varsel = iiii;
                elseif iii==2 % run selection procedure
                    mdl = selectvars(x,y,iiii,opt_sv);
                    use = mdl.use;
                    rmsecv = mdl.fit;
                    lvs_varsel = mdl.lvs;
                end
                
                id_doe = DOE(:,1)==i & DOE(:,2)==ii & DOE(:,3)==iii & DOE(:,4)==iiii;
                
                USEsample(:,id_doe) = IDkeep(:,iiii);
                USEvariables(use,id_doe) = true;
                RMSECV(id_doe) = rmsecv; 
                LV_varsel(id_doe) = lvs_varsel; 
            end
        end
    end
end


