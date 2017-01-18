Rails concurrent SSE test with Passenger and Puma
===

Example app. Trying to get Passenger to process requests to ActionController::Live endpoint concurrently, like Puma.


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


What do I need to set on Passenger and/or in the app to get this to work?
