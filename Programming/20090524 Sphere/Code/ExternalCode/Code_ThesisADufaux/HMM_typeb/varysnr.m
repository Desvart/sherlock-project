%snratio=-10:10:70;
%for k=1:9,
%	snratiotest=snratio(k);
%   snratiotrain=90;
%   [perfo,sc,scatter]=demo2(snratiotrain,snratiotest);
%   perfotot(k)=perfo;
%   confmat(:,:,k)=sc;
%   scat(k)=scatter;
%end;
%save Tunnel2BarkNoWClean.mat


clear all;


snratio=-10:10:70;
for k=1:9,
	snratiotest=snratio(k);
   snratiotrain=snratiotest;
   [perfo,sc,scatter]=demo2(snratiotrain,snratiotest);
   perfotot(k)=perfo;
   confmat(:,:,k)=sc;
   scat(k)=scatter;
end;
save Tunnel2BarkNoWMatch.mat