c_midfilt = c_midfilt(2:end);
c_lowfilt = c_lowfilt(2:end);
c_highfilt = c_highfilt(2:end);

t_midfilt = t_midfilt(2:end);
t_lowfilt = t_lowfilt(2:end);
t_highfilt = t_highfilt(2:end);

numFrames = [200 400 600 800 1000 1200 1400 1600 1800 2000 3000 4000 5000 6000 7000 8000 9000 11000 12000 13000]; 

figure
plot(numFrames,b_lowfilt,'LineWidth',3)
hold on
plot(numFrames,b_midfilt, 'LineWidth',3)
hold on
plot(numFrames,b_highfilt, 'LineWidth',3)
xlabel('Points per plane')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours","100 neighbours", "500 neighbours")
hold off

figure
plot(numFrames,l_lowfilt,'LineWidth',3)
hold on
plot(numFrames,l_midfilt, 'LineWidth',3)
hold on
plot(numFrames,l_highfilt, 'LineWidth',3)
xlabel('Points per plane')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours","100 neighbours", "500 neighbours")
hold off

figure
plot(numFrames,h_lowfilt,'LineWidth',3)
hold on
plot(numFrames,h_midfilt, 'LineWidth',3)
hold on
plot(numFrames,h_highfilt, 'LineWidth',3)
xlabel('Points per plane')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours","100 neighbours", "500 neighbours")
hold off

figure
plot(numFrames,c_lowfilt,'LineWidth',3)
hold on
plot(numFrames,c_midfilt, 'LineWidth',3)
hold on
plot(numFrames,c_highfilt, 'LineWidth',3)
xlabel('Points per plane')
ylabel("Confidence [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours","100 neighbours", "500 neighbours")
hold off

figure
plot(numFrames,t_lowfilt,'LineWidth',3)
hold on
plot(numFrames,t_midfilt, 'LineWidth',3)
hold on
plot(numFrames,t_highfilt, 'LineWidth',3)
xlabel('Points per plane')
ylabel("Time [s]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours","100 neighbours", "500 neighbours")
hold off