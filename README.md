# cloudRunR
Running R on Cloud Run.  Cloud Run lets you run any code within a Docker container, and will scale to billions of hits and down to 0, so you only pay for what you need. 

A demo app that copies the "Hello World" examples from plumber (  https://www.rplumber.io/ ) is available at these Cloud Run URLs:

* https://cloudrunr-ewjogewawq-uc.a.run.app/hello
* https://cloudrunr-ewjogewawq-uc.a.run.app/echo?msg=my%20message
* https://cloudrunr-ewjogewawq-uc.a.run.app/plot
* https://cloudrunr-ewjogewawq-uc.a.run.app/plot?spec=setosa

## Quickstart: Build and Deploy for R

The procedure below follows the examples for other languages given [here](https://cloud.google.com/run/docs/quickstarts/build-and-deploy) but modifies it to run R workloads. In this example an R API created by the wonderful `library(plumber)` -

### PORT

You need to run the plumber script on a port defined by the system environment variable, `PORT`, reachable in R via `Sys.getenv('PORT')`  The key line in the Dockerfile that achieves this for plumber is this one:

```
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT')))"]
```

Note the `pr$run` must have a numeric value passed to it for the port.

### Concurrency

R by default is single-threaded (like Python), so only 1 hit per container will be immediatly served, other hits will queue until the previous hit has completed.  For multi-threading, use `library(future)` to serve up to 80 threads (Python uses gunicorn).  A demo of that is [here](https://github.com/FvD/futureplumber/blob/master/multiprocess/future.R)

The effect of concurrency on scalability of the Cloud Run app is [here](https://cloud.google.com/run/docs/about-concurrency)

### Cloud Build

Set up [Google Cloud Build Trigger](https://console.cloud.google.com/cloud-build/triggers) to turn the Dockerfile into a Docker image to call.

1. Connect GitHub to Cloud Build
2. Configure a trigger to point to the Dockerfile

### Cloud Run deploy

Once the Cloud Build has finished it will give you a Docker URI such as `gcr.io/mark-edmondson-gde/cloudrunr:939c04dfe80a1eefed28f9dd59aae5dff5dc1e1e`.  

Put that in the Cloud Run field. 

Select public endpoint, and limit concurrency to what your app is configured to handle per instance (I chose 8)

And thats it.  A deployed R API. 

### Use the API

You will then get a URL for the API you can use.  For this demo app the endpoints are `/hello`, `/echo?msg="my message"` and `/plot` (or filter the plot via `/plot?spec=setosa`)


