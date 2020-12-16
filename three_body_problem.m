function driver

close all

m_sun = 1.989 * 10^30;

G = 6.67408 * 10^(-11);
m1 = m_sun; 
m2 = m_sun/2;
m3 = 50;
m = [m1 m2 m3];

day = 60*60*24;

AU = 149597870700;
dt = day;

r1 = [0.5 0 1]';
r2 = [0 1 0]';
r3 = [-0.5 0 -1]';

v_o = 2568000000/day;

v = [0.5;
     0;
     -0.5;
     0.1;
     -0.1;
     0;
     -.2;
     .5;
     0];

v = v_o *v;
ddr = @(r,t) [-G*m(2)*(r(1:3,:)-r(4:6,:))/(norm(r(1:3,:)-r(4:6,:))^3)-G*m(3)*(r(1:3,:)-r(7:9,:))/(norm(r(1:3,:)-r(7:9,:))^3);
              -G*m(1)*(r(4:6,:)-r(1:3,:))/(norm(r(4:6,:)-r(1:3,:))^3)-G*m(3)*(r(4:6,:)-r(7:9,:))/(norm(r(4:6,:)-r(7:9,:))^3);
              -G*m(1)*(r(7:9,:)-r(1:3,:))/(norm(r(7:9,:)-r(1:3,:))^3)-G*m(2)*(r(7:9,:)-r(4:6,:))/(norm(r(7:9,:)-r(4:6,:))^3)];

num_int = @(ddr,t0,dt,r) (dt)*(ddr(r,t0)+ddr(r,t0+dt))/2;        

r = AU*[r1; r2; r3];
r0 = r;
v0 = v;

for t = 0:dt:2*365*day*5
    r0 = r0 + dt*v0;
    r = [r r0];
    v0 = v0 + num_int(ddr,t,dt,r0);
end

figure


hold on

% view(250,5)
view(310,5)

plot3(r(1,:),r(2,:),r(3,:))
plot3(r(4,:),r(5,:),r(6,:))
plot3(r(7,:),r(8,:),r(9,:))
xlabel('x')
ylabel('y')
zlabel('z')

video(r)
end

function video(r)

figure

vid = VideoWriter('3bodyproblemvid','MPEG-4'); 
FileFormat = 'mp4';
open(vid) % begins writing
for index = 1:10:size(r,2) % for each data point
    
    
    
    clf % ensures graphs don't layer into frames
    hold on
    time = index;

    view(250+50*index/size(r,2),5)
    
    plot3(r(1,1:index),r(2,1:index),r(3,1:index))
    plot3(r(4,1:index),r(5,1:index),r(6,1:index))
    plot3(r(7,1:index),r(8,1:index),r(9,1:index))

    plot3(r(1,index),r(2,index),r(3,index),'o')
    plot3(r(4,index),r(5,index),r(6,index),'o')
    plot3(r(7,index),r(8,index),r(9,index),'o')
    
    title("time: " + string(time) + " days")
    xlabel("ree x")
    ylabel("ree y")
    zlabel("ree z")
    
    hold off
    Frame = getframe(gcf);
    writeVideo(vid,Frame); 
end

close(vid)

end


