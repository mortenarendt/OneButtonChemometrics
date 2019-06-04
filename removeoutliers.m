function IDkeep = removeoutliers(x,y,ncomp,opt_pls,prc)


n = size(x,1);
IDkeep = true(n,ncomp);
if prc==0 
    return
end

plsmdl = pls(x,y,ncomp,opt_pls);
scores = plsmdl.scores; 

loads = plsmdl.loads{2,1};
xp = preprocess('calibrate',opt_pls.preprocessing{1},x); 

for i=1:size(scores,2)
    E = xp.data - scores(:,1:i)*loads(:,1:i)';
    Qres(:,i) = diag(E*E');
    Qres(:,i) = Qres(:,i) / median(Qres(:,i));
    T2(:,i) = diag(scores(:,1:i)*scores(:,1:i)'); 
    T2(:,i) = T2(:,i)  / median(T2(:,i));
    
    c = Qres(:,i) + T2(:,i); 
    [~,r] = sort(c,'descend');
    [~,r] = sort(r);
    IDkeep(r<prc*n/100,i) = false;
end




