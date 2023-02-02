function [membership,cert,rejmembership]=testing(net,testfiles,NbreSigTest,v,d,vsep,dsep,M,Msep,totmean,totvar,snratio,rejectflag)

%initialisations
whitening=0;
s=size(testfiles,1);
NbClasses=length(NbreSigTest)-rejectflag;
feat=[];

%bruit fichier
%noise=getwav('/pe_users/AD/sounds/sounds/sounds44/new/tunnel2.wav');
noise=getwav('s:/sounds/sounds/sounds44/new/tunnel2.wav');
%signal=getwav('c:\AD\BDaudio\newBD\musics\music001.wav');
noise=noise/max(abs(noise));
noise=noise-mean(noise);
noise=noise/std(noise);

%Lectures des fichiers dans la variable x
for i=1:s,   
   [x,fs]=getwav(testfiles(i,:));
   %Ajout de bruit
   %[m,ind]=max(abs(x));
   %len=min(length(x)-ind,fs/4);
   %xlevel=10*log10(sum(x(ind(1):ind(1)+len-1).^2)/len);
   xlevel=10*log10(sum(x.^2)/length(x));
   noiselevel=xlevel-snratio;
   sigmanoise=10.^(noiselevel/20);

   %generation de bruit blanc
   n=sigmanoise*randn(1,length(x));
   
   %generation de bruit fichier
	%noise=repmat(noise,1,floor(length(x)/length(noise)));
	%n=sigmanoise*noise(1:length(x));

	%ajout du bruit
   x=x+n;
   
      %noisecreation for whitening
   if whitening~=0,
		white=sigmanoise*randn(1,length(x));
   	%whitening
		threshold=max(abs(n));
		ind=find(abs(x)<threshold);
      x(ind)=white(ind);
   end;

   
   tempfeat=features(x,fs);
   %tempfeat=meddis(x);
	%tempfeat=mfcc(x,fs);
   Nbframes(i)=size(tempfeat,2);
	feat=[feat tempfeat];%Calcul des features
end;

%Normalisation
totmean=mean(feat')';
normfeat=(feat'-repmat(totmean',size(feat,2),1))';
totvar=std(normfeat')';
normfeat=(normfeat'./repmat(totvar',size(normfeat,2),1))';
feat=normfeat;

%Reduction PCA
%[redfeat]=reduce(feat,v,d,M);
%redfeat=redfeat-repmat(mean(redfeat')',1,s);%zero-mean
%Resuction LDA
%[redfeat]=reduce(redfeat,vsep,dsep,Msep,0);
%feat=redfeat;%Mise en commentaire==> pas de r�duction

%classification de chaque frame par le reseau
framecert=sim(net,feat);
framecert=framecert./repmat(sum(framecert),size(framecert,1),1);
fullmembership=full(compet(framecert));
for i=1:size(framecert,2), framemembership(i)=find(fullmembership(:,i)==1); end;


%Classification pour chaque signal
cert_threshold=0.8;%0.99 pour 3 classes, %0.8 pour 6classes
for i=1:s, 
   start=sum(Nbframes(1:i-1))+1;
   stop=sum(Nbframes(1:i));
   
   %Rejection des mauvaises frames
   reject(i)=0;
   indgoodframes=find(max(framecert(:,start:stop))>cert_threshold);
   if isempty(indgoodframes), rejmembership(i)=0;
   else
   	temp=framemembership(start:stop);
	   for j=1:NbClasses, bilan(j)=length(find(temp(indgoodframes)==j));end;
   	%rejection
	   if ((length(indgoodframes)/(stop-start+1))<0.50), reject(i)=1; end;%pour proportion (mauvais)
   	if ((max(bilan)/sum(bilan)) < 0.85), reject(i)=1; end;%pour temporal %0.85 pour 3 classes
   
   	tempmem=find(bilan==max(bilan));
   	rejmembership(i)=tempmem(1);
		rejmembership(find(reject==1))=0;
   end;
  
	cert(:,i)=mean((framecert(:,start:stop))')';
   
   %pour no rejection!
   for j=1:NbClasses, bilan(j)=length(find(framemembership(start:stop)==j));end;
   tempmem=find(bilan==max(bilan));
   membership(i)=tempmem(1);
end;
