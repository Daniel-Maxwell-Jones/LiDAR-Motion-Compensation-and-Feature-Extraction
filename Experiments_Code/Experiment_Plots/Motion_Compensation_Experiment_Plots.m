addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions')
addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Experiments_Code\Motion_Compensation_Experiment')

numFrames = [5 10 15 20 25 30 35 40 45 50];
%==============================================================
%10 neighbours
%==============================================================
lowFlt_B_Tall = excel2Array('Motion_Experiment_LowFilt.xlsx','I',37,46);
lowFlt_L_Tall = excel2Array('Motion_Experiment_LowFilt.xlsx','J',37,46);
lowFlt_H_Tall = excel2Array('Motion_Experiment_LowFilt.xlsx','K',37,46);

lowFlt_Tall_Conf = excel2Array('Motion_Experiment_LowFilt.xlsx','D',37,46);
lowFlt_Tall_Time = excel2Array('Motion_Experiment_LowFilt.xlsx','E',37,46);

lowFlt_B_Short = excel2Array('Motion_Experiment_LowFilt.xlsx','I',24,33);
lowFlt_L_Short = excel2Array('Motion_Experiment_LowFilt.xlsx','J',24,33);
lowFlt_H_Short = excel2Array('Motion_Experiment_LowFilt.xlsx','K',24,33);

lowFlt_Short_Conf = excel2Array('Motion_Experiment_LowFilt.xlsx','D',24,33);
lowFlt_Short_Time = excel2Array('Motion_Experiment_LowFilt.xlsx','E',24,33);

%==============================================================
%100 neighbours
%==============================================================
midFlt_B_Tall = excel2Array('Motion_Experiment_MidFilt.xlsx','I',37,46);
midFlt_L_Tall = excel2Array('Motion_Experiment_MidFilt.xlsx','J',37,46);
midFlt_H_Tall = excel2Array('Motion_Experiment_MidFilt.xlsx','K',37,46);

midFlt_Tall_Conf = excel2Array('Motion_Experiment_MidFilt.xlsx','D',37,46);
midFlt_Tall_Time = excel2Array('Motion_Experiment_MidFilt.xlsx','E',37,46);

midFlt_B_Short = excel2Array('Motion_Experiment_MidFilt.xlsx','I',24,33);
midFlt_L_Short = excel2Array('Motion_Experiment_MidFilt.xlsx','J',24,33);
midFlt_H_Short = excel2Array('Motion_Experiment_MidFilt.xlsx','K',24,33);


midFlt_Short_Conf = excel2Array('Motion_Experiment_MidFilt.xlsx','D',24,33);
midFlt_Short_Time = excel2Array('Motion_Experiment_MidFilt.xlsx','E',24,33);
%==============================================================
%500 neighbours
%==============================================================
highFlt_B_Tall = excel2Array('Motion_Experiment_HighFilt.xlsx','I',39,48);
highFlt_L_Tall = excel2Array('Motion_Experiment_HighFilt.xlsx','J',39,48);
highFlt_H_Tall = excel2Array('Motion_Experiment_HighFilt.xlsx','K',39,48);

highFlt_Tall_Conf = excel2Array('Motion_Experiment_HighFilt.xlsx','D',39,48);
highFlt_Tall_Time = excel2Array('Motion_Experiment_HighFilt.xlsx','E',39,48);

highFlt_B_Short = excel2Array('Motion_Experiment_HighFilt.xlsx','I',26,35);
highFlt_L_Short = excel2Array('Motion_Experiment_HighFilt.xlsx','J',26,35);
highFlt_H_Short = excel2Array('Motion_Experiment_HighFilt.xlsx','K',26,35);

highFlt_Short_Conf = excel2Array('Motion_Experiment_HighFilt.xlsx','D',26,35);
highFlt_Short_Time = excel2Array('Motion_Experiment_HighFilt.xlsx','E',26,35);

%==============================================================
%Plots
%==============================================================
%Breadth

figure
plot(numFrames,lowFlt_B_Tall,'LineWidth',3)
hold on
plot(numFrames,midFlt_B_Tall, 'LineWidth',3)
hold on
plot(numFrames,highFlt_B_Tall, 'LineWidth',3)
xlabel('Number of frames')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');

%legend("10 neighbours","100 neighbours", "500 neighbours")
hold off

figure
plot(numFrames,lowFlt_B_Short,'LineWidth',3)
hold on
plot(numFrames,midFlt_B_Short, 'LineWidth',3)
hold on
plot(numFrames,highFlt_B_Short, 'LineWidth',3)
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
plot(numFrames,lowFlt_L_Tall,'LineWidth',3)
hold on
plot(numFrames,midFlt_L_Tall, 'LineWidth',3)
hold on
plot(numFrames,highFlt_L_Tall, 'LineWidth',3)
xlabel('Number of frames')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');

%legend("10 neighbours","100 neighbours", "500 neighbours")
hold off

figure
plot(numFrames,lowFlt_L_Short,'LineWidth',3)
hold on
plot(numFrames,midFlt_L_Short, 'LineWidth',3)
hold on
plot(numFrames,highFlt_L_Short, 'LineWidth',3)
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
plot(numFrames,lowFlt_H_Tall,'LineWidth',3)
hold on
plot(numFrames,midFlt_H_Tall, 'LineWidth',3)
hold on
plot(numFrames,highFlt_H_Tall, 'LineWidth',3)
xlabel('Number of frames')
ylabel("Relative error [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');

%legend("10 neighbours","100 neighbours", "500 neighbours")
hold off

figure
plot(numFrames,lowFlt_H_Short,'LineWidth',3)
hold on
plot(numFrames,midFlt_H_Short, 'LineWidth',3)
hold on
plot(numFrames,highFlt_H_Short, 'LineWidth',3)
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
plot(numFrames,lowFlt_Tall_Conf,'LineWidth',3)
hold on
plot(numFrames,midFlt_Tall_Conf, 'LineWidth',3)
hold on
plot(numFrames,highFlt_Tall_Conf, 'LineWidth',3)
xlabel('Number of frames')
ylabel("Confidence [%]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');

%legend("10 neighbours","100 neighbours", "500 neighbours",'Location','southeast')
hold off

figure
plot(numFrames,lowFlt_Short_Conf,'LineWidth',3)
hold on
plot(numFrames,midFlt_Short_Conf, 'LineWidth',3)
hold on
plot(numFrames,highFlt_Short_Conf, 'LineWidth',3)
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
plot(numFrames,lowFlt_Tall_Time,'LineWidth',3)
hold on
plot(numFrames,midFlt_Tall_Time, 'LineWidth',3)
hold on
plot(numFrames,highFlt_Tall_Time, 'LineWidth',3)
xlabel('Number of frames')
ylabel("Time [s]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');

%legend("10 neighbours","100 neighbours", "500 neighbours")
hold off

figure
plot(numFrames,lowFlt_Short_Time,'LineWidth',3)
hold on
plot(numFrames,midFlt_Short_Time, 'LineWidth',3)
hold on
plot(numFrames,highFlt_Short_Time, 'LineWidth',3)
xlabel('Number of frames')
ylabel("Time [s]")
ax = gca;
ax.FontSize = 18;
set(ax, 'FontWeight', 'bold');

%legend("10 neighbours","100 neighbours", "500 neighbours",'Location','southeast')
hold off
