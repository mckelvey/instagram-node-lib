
## Todo

1. Add new tests for variations of requests (optional parameters).

2. Create object.subscriptions list method that lists only subscriptions with a matching object.

3. Add /v1/geographies to the lib. Test if info or search methods exist too.

4. Add next page where available.

    {
        "meta": {
            "code": 200
        },
        "data": {
            ...
        },
        "pagination": {
            "next_url": "...",
            "next_max_id": "13872296"
        }
    }
