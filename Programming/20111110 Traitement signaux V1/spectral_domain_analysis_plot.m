figure('color', 'white');

subplot(1,2,1);
pcolor(stdftTAxis, stdftFAxis, db(stdft));
shading flat;

subplot(1,2,2);
mesh(stdftTAxis, stdftFAxis, db(stdft));
shading flat;