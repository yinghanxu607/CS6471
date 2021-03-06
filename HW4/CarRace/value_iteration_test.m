clear
clc
addpath('/Users/yinghanxu/Downloads/HW4/MDPtoolbox')

global VMAX Map_Data Finish_Data Pos_Vector_Indexes Speed_Vector_Indexes  st_len

cpu_time = cputime;

% Initialising the important constants:
% VMAX is the maximum allowed speed, in norm. It must be an integer.
VMAX=2;
% m and n are the dimensions of the data matrix
m=50;
n=50;
% p is an action probability of non-transmission
p=0.1;
% penalty is the penalty associated to an accident.
penalty=100;

% Reading the data from the file
Map_Data=read_data('data/50x50/50_50_track.txt',m,n);

% Computing the indexes for position and speed
[Pos_Vector_Indexes,Speed_Vector_Indexes]=index_computation;

[Start_Indexes_Y Start_Indexes_X]=find(Map_Data==2);

% Computing the start-line data (boundaries, center, coefficients; see
% generate_starting_state.m for details

y1=Start_Indexes_Y(1);
x1=Start_Indexes_X(1);
y2=Start_Indexes_Y(size(Start_Indexes_Y,1));
x2=Start_Indexes_X(size(Start_Indexes_Y,1));
yc=Start_Indexes_Y(floor(size(Start_Indexes_Y,1)/2));
xc=Start_Indexes_X(floor(size(Start_Indexes_Y,1)/2));
a=(y1-y2)/(x1-x2);
b=y1-a*x1;
Finish_Data=[y1 x1;y2 x2;yc xc;VMAX*VMAX 0;a b];

% initialising variables

courant=0;
st_len=size(Pos_Vector_Indexes,1)*size(Speed_Vector_Indexes,1);
P2=cell(9,1);
C2=cell(9,1);

% computing the transition and cost matrices

for s=-1:1,
    for t=-1:1,       
        [Y X V Cost]=transition_matrix(s,t,p);
        Prob=sparse(Y,X,V,st_len+2,st_len+2);
        % Cost is entered as -Cost because the solving algorithms are
        % reward-maxing instead of cost-minimizing.
        CC=sparse(Y,X,-Cost,st_len+2,st_len+2);
        % Due to the sparse format, some costs will be 2 when they should be 1.
        % This corrects it.
        CC(CC==-2)=-1;
        courant=courant+1
        P2{courant}=Prob;
        C2{courant}=CC;         
    end
end

cpu_time = cputime - cpu_time

S=generate_starting_state;

% Value Iteration
[Policy1, ite, cpu_time1] = mdp_value_iteration(P2, C2, 0.99);

% Displaying a random trajectory
[T1,C1]=trajectory(S,Policy1,st_len,p);
figure()
display_race(T1(1:(size(T1,1)-1)),st_len,Policy1);
