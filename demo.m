%% LGSC_v1 , i.e. Local Graph Structure Consensus
% based the Consensus of Graphs constructed by Neighborhhod Topology
% using Multi-scale and iteration strategy
% by Yifan Xia, "Robust Feature Matching via Local Graph Structure Consensus"
clear;
close all;
initialization; % run it only at the first time

%% Input image pair with putative matches
% load a pair of images
fn_l = '.\data\29_l.jpg';
fn_r = '.\data\29_r.jpg';
Il = imread(fn_l);
Ir = imread(fn_r);
[Iusl,Iusr] = uniform_size(Il,Ir);
% load ground truth, i.e., inliers
load '.\data\yun29.mat';

%% Run Mismatch Rejecting
tic;
ind = LGSC(X,Y);
toc;

% calculate metrics
[TP,TN,FP,FN] = plot_matches(Iusl, Iusr, X, Y, ind, CorrectIndex);
precise = length(TP)/(length(TP)+length(FP))
recall = length(TP)/(length(TP) + length(FN))
F1_score = 2*precise*recall/(precise+recall)
plot_4c(Iusl, Iusr, X, Y, ind, CorrectIndex);

%% Uniform size of the image pair
function [Iusl,Iusr] = uniform_size(Il,Ir)
if size(Il,3)==1
    Il = repmat(Il,[1,1,3]);
end
if size(Ir,3)==1
    Ir = repmat(Ir,[1,1,3]);
end
[wl,hl,~] = size(Il);
[wr,hr,~] = size(Ir);
maxw = max(wl,wr); maxh = max(hl,hr);
Il(wl+1:maxw,hl+1:maxh,:) = 0;
Ir(wr+1:maxw,hr+1:maxh,:) = 0;
Iusl = Il; Iusr = Ir;
end