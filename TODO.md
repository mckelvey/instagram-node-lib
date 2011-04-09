
## Todo

1. Unsubscribe all may fail, check sub-unsubscribe, add new tests.

2. Add new tests for variations of requests (optional parameters).

3. Callback url set globally fails to be available when not specified during the request.

4. Is it possible to drop the .API in every single call by doing module.exports= rather than exports.API= (akin to the tests).

5. Make tests only need callback_url; extract host and port from the callback.

6. Remove subscriptions list from tags, locations, media since it's not specific to those yet.

7. Make object.subscriptions list only those with a matching object.

8. Add /v1/geographies to the lib. See if info or search methods exist too.
