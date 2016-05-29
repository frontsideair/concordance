# Concordance
Concordance implementation for my Spring 2016 BIL 674 course (Parallel Computing with GPUs) at Hacettepe University.
(Originally, Phase I of the SICSA MultiCore Challenge)

## How to build
Get dependencies and compile with GHC, then run

```./conc sample.txt 5```

## Performance
On my machine (2.7 GHz Intel Core i5, 8 GB RAM), with [ACM.txt](http://www.macs.hw.ac.uk/~dsg/events/MultiCoreChallenge/inputs/Concordance_inputs/ACM.txt)
it takes about 10 minutes to complete running on a single core. With 4 cores when compiled with `-threaded` flag and run with `+RTS -N4` flags,
it curiously takes twice as long.

## What's next?
I'll make this run on [Accelerate](https://hackage.haskell.org/package/accelerate-0.15.1.0/docs/Data-Array-Accelerate.html) to take advantage of
GPGPU parallelism.
