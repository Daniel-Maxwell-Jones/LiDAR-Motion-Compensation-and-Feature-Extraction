addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Helper_Functions')
addpath('C:\Users\gamin\Desktop\LiDAR_Motion_Comp_Feature_Extract_Repo\LiDAR-Motion-Compensation-and-Feature-Extraction\Experiments_Code\Static_Feature_Extraction_Experiment')

numFrames = [5 10 15 20 25 30 35 40 45 50];
%==============================================================
%10 neighbours
%==============================================================
lowFlt_B_Tall = excel2Array('Static_Experiment_Spreadsheet2.xlsx','I',24,33);
lowFlt_L_Tall = excel2Array('Static_Experiment_Spreadsheet2.xlsx','J',24,33);
lowFlt_H_Tall = excel2Array('Static_Experiment_Spreadsheet2.xlsx','K',24,33);

lowFlt_Tall_Conf = excel2Array('Static_Experiment_Spreadsheet2.xlsx','D',24,33);
lowFlt_Tall_Time = excel2Array('Static_Experiment_Spreadsheet2.xlsx','E',24,33);

lowFlt_B_Short = excel2Array('Static_Experiment_Spreadsheet2.xlsx','I',39,48);
lowFlt_L_Short = excel2Array('Static_Experiment_Spreadsheet2.xlsx','J',39,48);
lowFlt_H_Short = excel2Array('Static_Experiment_Spreadsheet2.xlsx','K',39,48);

lowFlt_Short_Conf = excel2Array('Static_Experiment_Spreadsheet2.xlsx','D',39,48);
lowFlt_Short_Time = excel2Array('Static_Experiment_Spreadsheet2.xlsx','E',39,48);

%==============================================================
%100 neighbours
%==============================================================
midFlt_B_Tall = excel2Array('Static_Experiment_Spreadsheet1.xlsx','I',35,44);
midFlt_L_Tall = excel2Array('Static_Experiment_Spreadsheet1.xlsx','J',35,44);
midFlt_H_Tall = excel2Array('Static_Experiment_Spreadsheet1.xlsx','K',35,44);

midFlt_Tall_Conf = excel2Array('Static_Experiment_Spreadsheet1.xlsx','D',35,44);
midFlt_Tall_Time = excel2Array('Static_Experiment_Spreadsheet1.xlsx','E',35,44);

midFlt_B_Short = excel2Array('Static_Experiment_Spreadsheet1.xlsx','I',23,32);
midFlt_L_Short = excel2Array('Static_Experiment_Spreadsheet1.xlsx','J',23,32);
midFlt_H_Short = excel2Array('Static_Experiment_Spreadsheet1.xlsx','K',23,32);


midFlt_Short_Conf = excel2Array('Static_Experiment_Spreadsheet1.xlsx','D',23,32);
midFlt_Short_Time = excel2Array('Static_Experiment_Spreadsheet1.xlsx','E',23,32);
%==============================================================
%500 neighbours
%==============================================================
highFlt_B_Tall = excel2Array('Static_Experiment_Spreadsheet3.xlsx','I',24,33);
highFlt_L_Tall = excel2Array('Static_Experiment_Spreadsheet3.xlsx','J',24,33);
highFlt_H_Tall = excel2Array('Static_Experiment_Spreadsheet3.xlsx','K',24,33);

highFlt_Tall_Conf = excel2Array('Static_Experiment_Spreadsheet3.xlsx','D',24,33);
highFlt_Tall_Time = excel2Array('Static_Experiment_Spreadsheet3.xlsx','E',24,33);

highFlt_B_Short = excel2Array('Static_Experiment_Spreadsheet3.xlsx','I',38,47);
highFlt_L_Short = excel2Array('Static_Experiment_Spreadsheet3.xlsx','J',38,47);
highFlt_H_Short = excel2Array('Static_Experiment_Spreadsheet3.xlsx','K',38,47);

highFlt_Short_Conf = excel2Array('Static_Experiment_Spreadsheet3.xlsx','D',38,47);
highFlt_Short_Time = excel2Array('Static_Experiment_Spreadsheet3.xlsx','E',38,47);

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
set(ax, 'FontWeight', 'bold');
ax.FontSize = 18;
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
