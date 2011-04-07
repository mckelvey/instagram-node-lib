
## What It Is

The Instagram Node Lib is a helper library for [node](http://nodejs.org) that makes communicating with the [Instagram API](http://instagram.com/developer/) easy.

## Simple Example

Following is an example that loads the library, sets my CLIENT_ID and CLIENT_SECRET for accessing the API and makes a simple call to get information on the tag `#blue`.

    Instagram = require('instagram');

    Instagram.API.set('client_id', 'YOUR-CLIENT-ID');
    Instagram.API.set('client_secret', 'YOUR-CLIENT-SECRET');

    Instagram.API.tags.info({
      name: 'blue',
      complete: function(data){
        console.log(data);
      }
    });

When successful, the data logged in the console would be a javascript object like `{ media_count: 10863, name: 'blue' }`.

## Installation

    $ npm install instagram

## Setup

To use the library, you'll need to require it and at minimum, set your CLIENT_ID and CLIENT_SECRET given to you by Instagram.

    Instagram = require('instagram');

    Instagram.API.set('client_id', 'YOUR-CLIENT-ID');
    Instagram.API.set('client_secret', 'YOUR-CLIENT-SECRET');

Optionally, if you intend to use the real-time API to manage subscriptions, then you can also set a global callback url. (You may also provide/override the callback url when subscribing.)

    Instagram.API.set('callback_url', 'http://your.callback/path');

## Available Methods

_The methods currently available are limited to those available for non-user-specific interaction (i.e. anything that does not require authentication and an access_token). Look for those in future releases._

All of the methods below follow a similar pattern and stem directly from the API. All methods accept a single javascript object with the needed parameters to complete the API call ([use the API docs for those](http://instagram.com/developer/endpoints/)), plus the addition of a function to execute upon successful completion (i.e. `complete`) or an error function, should it fail (i.e. `error`).

    {
      name: 'blue',
      complete: function(data){
          // data is a javascript object/array/null matching that shipped Instagram
        },
      error: function(errorMessage, errorObject, caller){
          // errorMessage is the raised error message
          // errorObject is either the object that caused the issue, or the nearest neighbor
          // caller is the method in which the error occurred
        }
    }

In the event you do not provide a `complete` or `error` function, the library has fallback functions which simply post results to the console log.

# Tags

The following basic tag methods are available. Required parameters are shown below, see the [Instagram API docs](http://instagram.com/developer/endpoints/tags/) for the optional parameters.

    Instagram.API.tags.info({ name: 'blue' });
      ->  { media_count: 10863, name: 'blue' }

    Instagram.API.tags.recent({ name: 'blue' });
      ->  [ {media object},
            {media object},
            {media object}, ... ]

    Instagram.API.tags.search({ q: 'blue' });
      ->  [ { media_count: 10872, name: 'blue' },
            { media_count: 931, name: 'bluesky' },
            { media_count: 178, name: 'blueeyes' }, ... ]

Subscriptions for tags are also available with the following methods. A `callback_url` is required if not specified globally, and you may also provide a `verify_token` if you want to keep track of which subscription is coming back.

    Instagram.API.tags.subscribe({ object_id: 'blue' });
      -> {}

    Instagram.API.tags.unsubscribe({ subscription_id: 3678 });
      -> null


## Developers

