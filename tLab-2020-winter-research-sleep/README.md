# Sleep Scoring by a Data-driven Method 

July 2020 @[tLab](https://sites.google.com/monash.edu/tlab/home) under the supervision of Naotsugu Tsuchiya, Thomas Andrillon and Angus Leung. 



## Introduction 

Use HCTSA and its subset catch22 for automated sleep stage scoring in a data-driven method. 

## Assumption 
We want to find a neural index that is relevant to the electrical signals of the human brain. It should not be time-relevant. 

## Method 
- Fixed size epoch 
	- 10s, 30s....
- [HCTSA](https://github.com/benfulcher/hctsa) and [catch22](https://github.com/chlubba/catch22)
	- [Multi-taper Spectrogram](https://prerau.bwh.harvard.edu/multitaper/) (for comparisons)
	- <https://doi.org/10.1152/physiol.00062.2015>
	- [Sleep EEG Multitaper Tutorial: An Introduction to Spectral Analysis (Part 1 of 3)](https://www.youtube.com/watch?v=OVsZJLtzNsw)
- K-medoids Clustering 
- Principle Component Analysis (can be [Robust Component Analysis](https://www.youtube.com/watch?v=yDpz0PqULXQ) in the future)



## Result

In classical sleep scoring method, an epoch is usually fixed to 30 second (N1, N2, N3....). Each point in the following figures represent an epoch. It is clear that some clusters tend to appear in some sleep periods. 



### Sleep Periods - Sleep Onset 

![image-20210205142640664](image-20210205142640664.png)

### Sleep Periods - During sleep

![image-20210205142724021](image-20210205142724021.png)

### Sleep Periods - Near Wake

![image-20210205142829504](image-20210205142829504.png)



### Spectrogram and Catch22+K-medoids Clustering 

The comparison between the spectrogram and catch22.  

<img src="image-20210205143001419.png" alt="image-20210205143001419" style="zoom: 95%;" />

![image-20210205143056200](image-20210205143056200.png)

## Conclusion 

Cath22 can extract useful information from EEG time series. 

This simple method can be used for automated sleep scoring from a new point of view (other than spectrogram or RNN). 

In the future, 

- Noise Filtering : power line noise and its harmonics, bandpass filter (0.5~100Hz)
- FFT Window :hamming, welch, blackman.... 
- Supervised Learning: as K-mean clustering does not specify which cluster corresponds to which sleep stage, some supervised learning may be needed to distinguish them.  
- can CSSR achieve the same result?
