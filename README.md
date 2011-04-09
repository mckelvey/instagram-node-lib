
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

All of the methods below follow a similar pattern. Each accepts a single javascript object with the needed parameters to complete the API call. Required parameters are shown below; refer to [the API docs](http://instagram.com/developer/endpoints/) for the optional parameters. In addition, the parameters object may include two functions, one of which will be executed at the conclusion of the request (i.e. `complete` and `error`).

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

In the event you do not provide a `complete` or `error` function, the library has fallback functions which post results to the console log.

### Media

The following media methods are available. Required parameters are shown below, see the [Instagram API docs](http://instagram.com/developer/endpoints/media/) for the optional parameters.

    Instagram.API.media.info({ media_id: 3 });
      ->  { media object }

    Instagram.API.media.search({ lat: 48.858844300000001, lng: 2.2943506 });
      ->  [ { media object },
            { media object },
            { media object }, ... ]

    Instagram.API.media.popular();
      ->  [ { media object },
            { media object },
            { media object }, ... ]

    Instagram.API.media.likes({ media_id: 3 });
      ->  [ { username: 'krisrak',
              profile_picture: 'http://profile/path.jpg',
              id: '#',
              full_name: 'Rak Kris' },
            { username: 'mikeyk',
              profile_picture: 'http://profile/path.jpg',
              id: '#',
              full_name: 'Mike Krieger' } ]

    Instagram.API.media.comments({ media_id: 3 });
      ->  [ { created_time: '1279306830',
              text: 'Love the sign here',
              from: 
               { username: 'mikeyk',
                 profile_picture: 'http://profile/path.jpg',
                 id: '#',
                 full_name: 'Mike Krieger' },
              id: '8' },
            { created_time: '1279315804',
              text: 'Chilako taco',
              from: 
               { username: 'kevin',
                 profile_picture: 'http://profile/path.jpg',
                 id: '#',
                 full_name: 'Kevin Systrom' },
              id: '3' } ]

Geography subscriptions for media are also available with the following methods. A `callback_url` is required if not specified globally, and you may also provide a `verify_token` if you want to keep track of which subscription is coming back.

    Instagram.API.media.subscribe({ lat: 48.858844300000001, lng: 2.2943506, radius: 1000 });
      ->  { object: 'geography',
            object_id: '#',
            aspect: 'media',
            callback_url: 'http://your.callback/path',
            type: 'subscription',
            id: '#' }

    Instagram.API.tags.unsubscribe({ id: # });
      ->  null // null is success, an error is failure

    Instagram.API.tags.unsubscribe_all();
      ->  

### Tags

The following tag methods are available. Required parameters are shown below, see the [Instagram API docs](http://instagram.com/developer/endpoints/tags/) for the optional parameters.

    Instagram.API.tags.info({ name: 'blue' });
      ->  { media_count: 10863, name: 'blue' }

    Instagram.API.tags.recent({ name: 'blue' });
      ->  [ { media object },
            { media object },
            { media object }, ... ]

    Instagram.API.tags.search({ q: 'blue' });
      ->  [ { media_count: 10872, name: 'blue' },
            { media_count: 931, name: 'bluesky' },
            { media_count: 178, name: 'blueeyes' }, ... ]

Tag subscriptions are also available with the following methods. A `callback_url` is required if not specified globally, and you may also provide a `verify_token` if you want to keep track of which subscription is coming back.

    Instagram.API.tags.subscribe({ object_id: 'blue' });
      ->  { object: 'tag',
            object_id: 'blue',
            aspect: 'media',
            callback_url: 'http://your.callback/path',
            type: 'subscription',
            id: '#' }

    Instagram.API.tags.unsubscribe({ id: # });
      ->  null // null is success, an error is failure

    Instagram.API.tags.unsubscribe_all();
      ->  

### Locations

The following location methods are available. Required parameters are shown below, see the [Instagram API docs](http://instagram.com/developer/endpoints/locations/) for the optional parameters.

    Instagram.API.locations.info({ location_id: 1 });
      ->  { latitude: 37.78265474565738,
            id: '1',
            longitude: -122.387866973877,
            name: 'Dogpatch Labs' }

    Instagram.API.locations.recent({ location_id: 1 });
      ->  [ { media object },
            { media object },
            { media object }, ... ]

    Instagram.API.locations.search({ lat: 48.858844300000001, lng: 2.2943506 });
      ->  [ { latitude: 48.8588443,
              id: '723695',
              longitude: 2.2943506,
              name: 'Restaurant Jules Verne' },
            { latitude: 48.8588443,
              id: '788029',
              longitude: 2.2943506,
              name: 'Eiffel Tower, Paris' },
            { latitude: 48.858543,
              id: '1894075',
              longitude: 2.2938285,
              name: 'CafŽ de l\'homme' }, ... ]

Location subscriptions are also available with the following methods. A `callback_url` is required if not specified globally, and you may also provide a `verify_token` if you want to keep track of which subscription is coming back.

    Instagram.API.locations.subscribe({ object_id: '1257285' });
      ->  { object: 'location',
            object_id: '1257285',
            aspect: 'media',
            callback_url: 'http://your.callback/path',
            type: 'subscription',
            id: '#' }

    Instagram.API.locations.unsubscribe({ id: # });
      ->  null // null is success, an error is failure

    Instagram.API.locations.unsubscribe_all();
      ->  

### Users

The following user methods are available. Required parameters are shown below, see the [Instagram API docs](http://instagram.com/developer/endpoints/users/) for the optional parameters.

    Instagram.API.users.info({ user_id: 291024 });
      ->  { username: 'mckelvey',
            counts: { media: 526, followed_by: 293, follows: 265 },
            profile_picture: 'http://profile/path.jpg',
            id: '291024',
            full_name: 'David McKelvey' }

    Instagram.API.users.search({ q: 'mckelvey' });
      ->  [ { username: 'mckelvey',
              profile_picture: 'http://profile/path.jpg',
              id: '291024',
              full_name: 'David McKelvey' }, ... ]

### Real-time Subscriptions



    Instagram.API.subscriptions


## Developers

