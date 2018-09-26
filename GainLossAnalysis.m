function GainLossAnalysis()
% GainLossAnalysis
% Runs all analysis steps


GLDataLoad%find data files and get info
GLDataProcess%process info, apply unblinded conditions
GLDataAnalysis%load data and analyse

GLDataGraphsForPaper%only draws figures from paper (plus summary stats table)


end
