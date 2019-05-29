# cloudRunR
Running R on Cloud Run

## Quickstart: Build and Deploy for R

This follows the examples given [here](https://cloud.google.com/run/docs/quickstarts/build-and-deploy) but modifies it to run R workloads, in this example an R API created by `plumber`. 

## PORT

You need to run the plumber script on a port defined by the system environment variable, `PORT`, reachable in R via `Sys.getenv('PORT')`

## Concurrency

R by default is single-threaded (like Python), so only 1 hit per container will be immediatly served, other hits will queue until the previous hit has completed.  For multi-threading, use `library(future)` to serve up to 80 threads (Python uses gunicorn).  A demo of that is [here](https://github.com/FvD/futureplumber/blob/master/multiprocess/future.R)

The effect of concurrency on scalability of the Cloud Run app is [here](https://cloud.google.com/run/docs/about-concurrency)

## Cloud Build

Set up Google Cloud Build and link it to the GitHub repo with the R plumber script and Dockerfile.  

## Cloud Run deploy

Once the Cloud Build has finished it will give you a Docker URI such as `gcr.io/mark-edmondson-gde/cloudrunr:b582dc99f609a43759effdac6288b1cb03f865cb`.  Put that in the Cloud Run field. Select public endpoint, and limit concurrency to what your app is configured to handle per instance. 
