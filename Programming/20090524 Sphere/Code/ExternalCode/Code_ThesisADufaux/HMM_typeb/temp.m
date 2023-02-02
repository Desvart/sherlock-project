   [membership,maxlogl,logcert]=test(m,c,A,pio,testfiles,NbreSigTest,v,d,vsep,dsep,M,Msep,totmean,totvar,snratiotest,rejectflag);  
   
   %Target
   target=[];
   if (rejectflag==1), NbClasses=NbClasses+1; end;
   for j=1:NbClasses, target=[target j*ones(1,NbreSigTest(j))]; end;

   %rejection 
   %with logcert (globalement sur toutes les frames)
   cert_threshold=0.8;%0.795
   rejmembership=membership;
   %cert=exp(logcert);
   logcert=sort(logcert')';
   logcert=(logcert(:,1)-logcert(:,2))./logcert(:,1);
   rejmembership(find(logcert>cert_threshold))=0;
   indOK=find(rejmembership~=0);%seulement avec meancert rejection
   rejmembership=membership(indOK);
   rejtarget=target(indOK);
   
   
   if (worldflag==0),
   %Evaluation de performance sans rejection
   newsc=score(membership(1:sum(NbreSigTest(1:NbClasses-rejectflag))),target(1:sum(NbreSigTest(1:NbClasses-rejectflag))));
   sc=sc+newsc
   res(i)=sum(diag(newsc))/sum(sum(newsc));
   perfo=sum(diag(sc))/sum(sum(sc))
  
   %Evaluation de performance avec rejection
   if (rejectflag==0),
	   	rejnewsc=score(rejmembership,rejtarget);
    		rejsc=rejsc+rejnewsc
	   	rejres(i)=sum(diag(rejnewsc))/sum(sum(rejnewsc));
   		rejperfo=sum(diag(rejsc))/sum(sum(rejsc))
   		rej=sc-rejsc;
   		falserejectionrate=sum(diag(rej))/(i*sum(NbreSigTest))
   		OKrejectionrate=((sum(sum(sc))-sum(diag(sc))) - (sum(sum(rejsc))-sum(diag(rejsc))))/(sum(sum(sc))-sum(diag(sc)))
   	   scatter=std(res);
   else
      rejnewsc=score(rejmembership,rejtarget);
      if (size(rejnewsc)~=size(rejsc)), rejnewsc(NbClasses,1:NbClasses)=0;end;
      	rejsc=rejsc+rejnewsc
      	temprejsc=rejsc(1:NbClasses-1,1:NbClasses-1);
    		rejperfo=sum(diag(temprejsc))/sum(sum(temprejsc))
   		rej=sc-temprejsc;
   		falserejectionrate=sum(diag(rej))/(i*sum(NbreSigTest))
   		OKrejectionrate=((sum(sum(sc))-sum(diag(sc))) - (sum(sum(temprejsc))-sum(diag(temprejsc))))/(sum(sum(sc))-sum(diag(sc)))
   		classrejectionrate=1-sum(rejsc(NbClasses,1:NbClasses-1))/(i*Nbreject)
   end;
      
   else 
	newsc=score(membership,target);
   sc=sc+newsc
   tempsc=sc(1:NbClasses-1,1:NbClasses-1);
   perfo=sum(diag(tempsc))/sum(sum(tempsc))
   falserejectionrate=sum(sc(1:NbClasses-1,NbClasses))/sum(sum(sc(1:NbClasses-1,:)))
   classrejectionrate=sc(NbClasses,NbClasses)/sum(sc(NbClasses,1:NbClasses))
	end;
