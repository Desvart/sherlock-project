snratio=-10:10:70;
for k=1:9,
	snratiotrain=snratio(k);,
   snratiotest=snratiotrain;
   demo2;
   perfotot(k)=perfo;
end;
