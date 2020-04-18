# Master thesis: Structured Auto-Encoder with application to Music Genre Recognition

[Michaël Defferrard](https://deff.ch).
Supervized by [Xavier Bresson](https://www.ntu.edu.sg/home/xbresson),
[Johan Paratte](https://www.linkedin.com/in/johan-paratte-a2070039),
[Pierre Vandergheynst](https://people.epfl.ch/pierre.vandergheynst).

> In this work, we present a technique that learns discriminative audio
> features for Music Information Retrieval (MIR). The novelty of the proposed
> technique is to design auto-encoders that make use of data structures to
> learn enhanced sparse data representations. The data structure is borrowed
> from the Manifold Learning field, that is data are supposed to be sampled
> from smooth manifolds, which are here represented by graphs of proximities of
> the input data. As a consequence, the proposed auto-encoders finds sparse
> data representations that are quite robust w.r.t. perturbations. The model is
> formulated as a non-convex optimization problem. However, it can be
> decomposed into iterative sub-optimization problems that are convex and for
> which well-posed iterative schemes are provided in the context of the Fast
> Iterative Shrinkage-Thresholding (FISTA) framework. Our numerical experiments
> show two main results. Firstly, our graph-based auto-encoders improve the
> classification accuracy by 2% over the auto-encoders without graph structure
> for the popular GTZAN music dataset. Secondly, our model is significantly
> more robust as it is 8% more accurate than the standard model in the presence
> of 10% of perturbations.

## Content

This repository contains the code developed during my master thesis.

Related resources:
* Report: <https://infoscience.epfl.ch/record/218019>
* Slides: <https://deff.ch/dlaudio_slides.pdf>
* Code: <https://github.com/mdeff/dlaudio>
* Experimental results: <http://nbviewer.jupyter.org/github/mdeff/dlaudio_results>
* Latex sources of the report: <https://github.com/mdeff/dlaudio_report>
