Rails concurrent SSE test with Passenger and Puma
===

Example app. Trying to get Passenger to process requests to ActionController::Live endpoint concurrently, like Puma.


UPDATE
----

This question has been answered. To make ActionController::SSE run concurrently with Passenger, you need Enterprise -- see answer in the Google Group:
https://groups.google.com/forum/#!topic/phusion-passenger/JtUOv4M2RzM


To Run tests
---

Test with Puma:

    puma -p 3000

Test with Passenger:

    bundle exec passenger start --force-max-concurrent-requests-per-process 0

Test via curl in multiple terminal windows:

    curl localhost:3000/sse


Results
---
When running Puma, multiple requests will receive responses simultanelously, 
but with Passenger, the second request will wait until the first request has finished.

Puma log output:

```
Request started at 2017-01-18 11:41:21 -0600 in #<Thread:0x007fa74dc9d898>
sse 0
sse 1
sse 2
sse 3
Request started at 2017-01-18 11:41:24 -0600 in #<Thread:0x007fa74c6aef50>
sse 0
sse 4
sse 1
sse 5
sse 2
sse 6
sse 3
sse 7
sse 4
sse 8
sse 5
sse 9
sse 6
sse 7
sse 8
sse 9
```

Passenger log output:

```
Started GET "/sse" for 127.0.0.1 at 2017-01-18 11:43:08 -0600
Processing by SseController#sse as */*
App 82915 stdout: Request started at 2017-01-18 11:43:08 -0600 in #<Thread:0x007fede3a48980>
App 82915 stdout: sse 0
App 82915 stdout: sse 1
App 82915 stdout: 
App 82915 stdout: sse 2
App 82915 stdout: 
App 82915 stdout: sse 3
App 82915 stdout: 
App 82915 stdout: sse 4
App 82915 stdout: 
App 82915 stdout: sse 5
App 82915 stdout: 
App 82915 stdout: sse 6
App 82915 stdout: 
App 82915 stdout: sse 7
App 82915 stdout: 
App 82915 stdout: sse 8
App 82915 stdout: 
App 82915 stdout: sse 9
App 82915 stdout: 
Completed 200 OK in 10033ms (ActiveRecord: 0.0ms)


Started GET "/sse" for 127.0.0.1 at 2017-01-18 11:43:18 -0600
Processing by SseController#sse as */*
App 82915 stdout: Request started at 2017-01-18 11:43:18 -0600 in #<Thread:0x007fede9807378>
App 82915 stdout: sse 0
App 82915 stdout: 
App 82915 stdout: sse 1
App 82915 stdout: 
App 82915 stdout: sse 2
App 82915 stdout: 
App 82915 stdout: sse 3
App 82915 stdout: 
App 82915 stdout: sse 4
App 82915 stdout: 
App 82915 stdout: sse 5
App 82915 stdout: 
App 82915 stdout: sse 6
App 82915 stdout: 
App 82915 stdout: sse 7
App 82915 stdout: 
App 82915 stdout: sse 8
App 82915 stdout: 
App 82915 stdout: sse 9
App 82915 stdout: 
Completed 200 OK in 10034ms (ActiveRecord: 0.0ms)
```


What do I need to set on Passenger and/or in the app to get this to work?
