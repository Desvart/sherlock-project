%function  [perfo,sc,scatter]=demo2(snratiotrain,snratiotest);

clear all;

%flag pour supplementaire rejection class
%rem: la rejection par seuil est automatiquement active
%rem: son mode peut etre choisi plus bas (mean/temporal/les deux) 
rejectflag=0;%flag pour la classe suppl�mentaire � tester
worldflag=0; %flag pour la classe world artificielle a entrainer
if (worldflag==1), rejectflag=1;end;

%3classes:
NbreSig=[69 58 38];%Nombre de Signaux : Explosions, Bris de verre, cris
homedir='/pe_users/AD/sounds/sounds/sounds44/petitebd';%repertoire des sons
%homedir='s:/sounds/sounds/sounds44/petitebd';%repertoire des sons
%homedir='c:/AD/IMT/sounds/sounds44/petitebd';%repertoire des sons
%homedir='e:/sounds44/petitebd';%chemin pour le repertoire des sons
repertclasses{1}='/portes/porte';
repertclasses{2}='/explos/explo';
repertclasses{3}='/verres/verre';
%repertclasses{4}='/worlds/world';
if (rejectflag==1), 
   repertclasses{length(NbreSig)+1}='/musics/music';
   Nbreject=30;
end;


%6classes
%NbreSig=[314 62 88 73 225 60 41];
%homedir='/pe_users/AD/sounds/sounds/sounds44';
%repertclasses{1}='/portes/porte';
%repertclasses{2}='/ex/explosion';
%repertclasses{3}='/verres/verre';
%repertclasses{4}='/cris_/scream';
%repertclasses{5}='/guns____/gun';
%repertclasses{6}='/noisex/noise';
%repertclasses{7}='/worlds/world';
%if (rejectflag==1), 
%   repertclasses{length(NbreSig)+1}='/musics/music';
%   Nbreject=50;
%end;

%10classes
%homedir='/pe_users/AD/sounds/sounds/sounds44';%
%NbreSig=[314 62 88 73 225 60 55 51 81 87];
%repertclasses{1}='/portes/porte';
%repertclasses{2}='/ex/explosion';
%repertclasses{3}='/verres/verre';
%repertclasses{4}='/cris_/scream';
%repertclasses{5}='/guns____/gun';
%repertclasses{6}='/noisex/noise';
%repertclasses{7}='/chiens/chien';
%repertclasses{8}='/phones/phone';
%repertclasses{9}='/coupbas/coup';
%repertclasses{10}='/enfant/enfan';%87
%repertclasses{11}='/cymbals/cymb';%52
%repertclasses{11}='/worlds/world';%41
%if (rejectflag==1), 
%   repertclasses{length(NbreSig)+1}='/musics/music';%60
%   Nbreject=50;
%end;


iterations=1;%Nombre d'iterations de crossvalidation 
M=10;%Nombre de features apr�s r�duction PCACA
Msep=2;%Nombre de features apr�s r�duction LDADA
snratiotrain=90;%Signal to noise ratio
snratiotest=90;

N=3;%Nombre d'etats des HMM

%initialisations
sc=zeros(length(NbreSig)+worldflag);
rejsc=zeros(length(NbreSig)+rejectflag);

%vecteurs consid�r�s pour chaque classese
NbreSigTrain=ceil(NbreSig/2);
NbreSigTest=NbreSig-NbreSigTrain;
if (rejectflag==1), NbreSigTest=[NbreSigTest Nbreject]; end;

for i=1:iterations,
   
   i%iteration courante
   trainfiles=[];
	testfiles=[];
   NbClasses=length(NbreSig);

   %Repartition des vecteurs pour training et testing
	rand('state',sum(100*clock));
   for j=1:NbClasses, 
      indices{j}=randperm(NbreSig(j));
      %indices{j}=1:NbreSig(j);
   end;

	%fichiers de training
   for j=1:NbClasses,
      files{j}=filenames([homedir repertclasses{j}],indices{j}(1:NbreSigTrain(j)));
   	trainfiles=[trainfiles; files{j}];  
   end;
	%fichiers de testing
   for j=1:NbClasses,
      files{j}=filenames([homedir repertclasses{j}],indices{j}(NbreSigTrain(j)+1:NbreSig(j)));
      testfiles=[testfiles; files{j}];
   end;
   if (rejectflag==1), 
      testfiles=[testfiles; filenames([homedir repertclasses{NbClasses+1}],1:Nbreject)];
   end;
   %testfiles=[testfiles;trainfiles];NbreSigTest=NbreSig;
   
   %Training
	[m,c,A,v,d,vsep,dsep,totmean,totvar]=training(trainfiles,NbreSigTrain,N,M,Msep,snratiotrain,worldflag);
	%save training.mat m c A v d vsep dsep totmean totvar;
     
   %Testing
   %load training;
   pio=eye(N);pio=pio(1,:);
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
   		falserejectionrate=sum(diag(rej))/(i*sum(NbreSigTest(1:NbClasses-1)))
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

end
