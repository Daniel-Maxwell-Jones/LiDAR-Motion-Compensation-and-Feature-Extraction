addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions')
addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Experiments_Code\Range_Testing_Experiment')

numFrames = [10 20 30 40 50 60 70 80 90 100];
%==============================================================
%==============================================================
%==============================================================
%DISTANCE 1 ARRAY
%==============================================================
%==============================================================
%==============================================================


%==============================================================
%10 neighbours
%==============================================================
lowFlt_B_D1 = excel2Array('Range_Experiment_LowFilt_Dist1.xlsx','I',16,25);
lowFlt_L_D1 = excel2Array('Range_Experiment_LowFilt_Dist1.xlsx','J',16,25);
lowFlt_H_D1 = excel2Array('Range_Experiment_LowFilt_Dist1.xlsx','K',16,25);

lowFlt_D1_Conf = excel2Array('Range_Experiment_LowFilt_Dist1.xlsx','D',16,25);
lowFlt_D1_Time = excel2Array('Range_Experiment_LowFilt_Dist1.xlsx','E',16,25);

%==============================================================
%100 neighbours
%==============================================================
midFlt_B_D1 = excel2Array('Range_Experiment_MidFilt_Dist1.xlsx','I',15,24);
midFlt_L_D1 = excel2Array('Range_Experiment_MidFilt_Dist1.xlsx','J',15,24);
midFlt_H_D1 = excel2Array('Range_Experiment_MidFilt_Dist1.xlsx','K',15,24);

midFlt_D1_Conf = excel2Array('Range_Experiment_MidFilt_Dist1.xlsx','D',15,24);
midFlt_D1_Time = excel2Array('Range_Experiment_MidFilt_Dist1.xlsx','E',15,24);

%==============================================================
%500 neighbours
%==============================================================
highFlt_B_D1 = excel2Array('Range_Experiment_HighFilt_Dist1.xlsx','I',16,25);
highFlt_L_D1 = excel2Array('Range_Experiment_HighFilt_Dist1.xlsx','J',16,25);
highFlt_H_D1 = excel2Array('Range_Experiment_HighFilt_Dist1.xlsx','K',16,25);

highFlt_D1_Conf = excel2Array('Range_Experiment_HighFilt_Dist1.xlsx','D',16,25);
highFlt_D1_Time = excel2Array('Range_Experiment_HighFilt_Dist1.xlsx','E',16,25);

%==============================================================
%==============================================================
%==============================================================
%DISTANCE 2 ARRAY
%==============================================================
%==============================================================
%==============================================================

%==============================================================
%10 neighbours
%==============================================================
lowFlt_B_D2 = excel2Array('Range_Experiment_LowFilt_Dist2.xlsx','I',23,32);
lowFlt_L_D2 = excel2Array('Range_Experiment_LowFilt_Dist2.xlsx','J',23,32);
lowFlt_H_D2 = excel2Array('Range_Experiment_LowFilt_Dist2.xlsx','K',23,32);

lowFlt_D2_Conf = excel2Array('Range_Experiment_LowFilt_Dist2.xlsx','D',23,32);
lowFlt_D2_Time = excel2Array('Range_Experiment_LowFilt_Dist2.xlsx','E',23,32);


%==============================================================
%==============================================================
%==============================================================
%DISTANCE 3 ARRAY
%==============================================================
%==============================================================
%==============================================================


%==============================================================
%10 neighbours
%==============================================================
lowFlt_B_D3 = excel2Array('Range_Experiment_LowFilt_Dist3.xlsx','I',17,25);
lowFlt_L_D3 = excel2Array('Range_Experiment_LowFilt_Dist3.xlsx','J',17,25);
lowFlt_H_D3 = excel2Array('Range_Experiment_LowFilt_Dist3.xlsx','K',17,25);

lowFlt_D3_Conf = excel2Array('Range_Experiment_LowFilt_Dist3.xlsx','D',17,25);
lowFlt_D3_Time = excel2Array('Range_Experiment_LowFilt_Dist3.xlsx','E',17,25);

%==============================================================
%Plots D1
%==============================================================
%Breadth

figure
plot(numFrames,lowFlt_B_D1,'LineWidth',3)
hold on
plot(numFrames,midFlt_B_D1, 'LineWidth',3)
hold on
plot(numFrames,highFlt_B_D1, 'LineWidth',3)
xlabel('Number of frames')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours","100 neighbours", "500 neighbours")
hold off



%==============================================================
%Length

figure
plot(numFrames,lowFlt_L_D1,'LineWidth',3)
hold on
plot(numFrames,midFlt_L_D1, 'LineWidth',3)
hold on
plot(numFrames,highFlt_L_D1, 'LineWidth',3)
xlabel('Number of frames')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours","100 neighbours", "500 neighbours")
hold off



%==============================================================
%Height

figure
plot(numFrames,lowFlt_H_D1,'LineWidth',3)
hold on
plot(numFrames,midFlt_H_D1, 'LineWidth',3)
hold on
plot(numFrames,highFlt_H_D1, 'LineWidth',3)
xlabel('Number of frames')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours","100 neighbours", "500 neighbours")
hold off

%==================================================================
%Confidence

figure
plot(numFrames,lowFlt_D1_Conf,'LineWidth',3)
hold on
plot(numFrames,midFlt_D1_Conf, 'LineWidth',3)
hold on
plot(numFrames,highFlt_D1_Conf, 'LineWidth',3)
xlabel('Number of frames')
ylabel("Confidence [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours","100 neighbours", "500 neighbours",'Location','southeast')
hold off


%==================================================================
%Time

figure
plot(numFrames,lowFlt_D1_Time,'LineWidth',3)
hold on
plot(numFrames,midFlt_D1_Time, 'LineWidth',3)
hold on
plot(numFrames,highFlt_D1_Time, 'LineWidth',3)
xlabel('Number of frames')
ylabel("Time [s]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours","100 neighbours", "500 neighbours")
hold off

%==============================================================
%Plots D2
%==============================================================
%Breadth

figure
plot(numFrames,lowFlt_B_D2,'LineWidth',3)
xlabel('Number of frames')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours")

%==============================================================
%Length

figure
plot(numFrames,lowFlt_L_D2,'LineWidth',3)
xlabel('Number of frames')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours")
%==============================================================
%Height

figure
plot(numFrames,lowFlt_H_D2,'LineWidth',3)
xlabel('Number of frames')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours")

%==================================================================
%Confidence

figure
plot(numFrames,lowFlt_D2_Conf,'LineWidth',3)
xlabel('Number of frames')
ylabel("Confidence [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours")

%==================================================================
%Time

figure
plot(numFrames,lowFlt_D2_Time,'LineWidth',3)
xlabel('Number of frames')
ylabel("Time [s]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours")

%==============================================================
%Plots D3
%==============================================================
%Breadth

figure
plot(numFrames(2:end),lowFlt_B_D3,'LineWidth',3)
xlabel('Number of frames')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours")

%==============================================================
%Length

figure
plot(numFrames(2:end),lowFlt_L_D3,'LineWidth',3)
xlabel('Number of frames')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours")
%==============================================================
%Height

figure
plot(numFrames(2:end),lowFlt_H_D3,'LineWidth',3)
xlabel('Number of frames')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours")

%==================================================================
%Confidence

figure
plot(numFrames(2:end),lowFlt_D3_Conf,'LineWidth',3)
xlabel('Number of frames')
ylabel("Confidence [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours",'Location','southeast')

%==================================================================
%Time

figure
plot(numFrames(2:end),lowFlt_D3_Time,'LineWidth',3)
xlabel('Number of frames')
ylabel("Time [s]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');
%legend("10 neighbours")

