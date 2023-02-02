clear all;

%Param�tres Principaux:

%3classes
%NbreSig=[69 58 38];%Nombre de Signaux : Explosions, Bris de verre, cris
%homedir='/pe_users/AD/sounds/sounds/sounds44/petitebd';%repertoire des sons
%homedir='s:/sounds/sounds/sounds44/petitebd';%repertoire des sons
%homedir='c:/AD/IMT/sounds/sounds44/petitebd';%repertoire des sons

%homedir='e:/sounds44/petitebd';%chemin pour le repertoire des sons
%repertclasses{1}='/portes/porte';
%repertclasses{2}='/explos/explo';
%repertclasses{3}='/verres/verre';

%6classes
NbreSig=[314 62 88 73 225 60];
%homedir='/pe_users/AD/sounds/sounds/sounds44';
homedir='s:/sounds/sounds/sounds44';%repertoire des sons

repertclasses{1}='/portes/porte';
repertclasses{2}='/ex/explosion';
repertclasses{3}='/verres/verre';
repertclasses{4}='/cris_/scream';
repertclasses{5}='/guns____/gun';
repertclasses{6}='/noisex/noise';

iterations=100;%Nombre d'iterations de crossvalidation 
M=10;%Nombre de features apr�s r�duction
noiselevel=1;%Amplitude maximum du bruit ajout� au signaux

%initialisations
sc=zeros(length(NbreSig));
trainsnr=zeros(1,iterations);
testsnr=trainsnr;
rejectionratetot=[];

%vecteurs consid�r�s pour chaque classe
NbClasses=length(NbreSig);
NbreSigTrain=ceil(NbreSig/2);
NbreSigTest=NbreSig-NbreSigTrain;
target=[];
for j=1:NbClasses, target=[target j*ones(1,NbreSigTest(j))]; end;

for i=1:iterations,
   
   %iteration courante
   i
   trainfiles=[];
	testfiles=[];

   %Repartition des vecteurs pour training et testing
	rand('state',sum(100*clock));
   for j=1:NbClasses, 
      indices{j}=randperm(NbreSig(j)); 
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
   
   %testfiles=[testfiles;trainfiles];NbreSigTest=NbreSig;

   
   %Training
   [net,v,d,vsep,dsep,totmean,totvar,trainsnr(i)]=training(trainfiles,NbreSigTrain,M,noiselevel);
 	%save training.mat Vectors target net v d;
    
    
   %Testing
	%load training;
   [membership,output,testsnr(i)]=test(net,testfiles,NbreSigTest,v,d,vsep,dsep,M,totmean,totvar,noiselevel);
   
   %rejection 
   %cert_threshold=0.80;
   %certmax=max(output);
   %membership(find(certmax<cert_threshold))=0;
   %rejectionrate=length(find(membership==0))/length(membership)
   %rejectionratetot=[rejectionratetot rejectionrate];
   %indOK=find(membership~=0);
   %membership=membership(indOK);
   %target=target(indOK);

   
   %Evaluation de performance
   newsc=score(membership,target);
   sc=sc+newsc
   res(i)=sum(diag(newsc))/sum(sum(newsc));
   perfo=sum(diag(sc))/sum(sum(sc))
end;

%rejectionrate=mean(rejectionratetot)
scatter=std(res)
snr=mean([trainsnr testsnr])