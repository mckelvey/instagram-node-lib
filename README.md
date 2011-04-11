
## What It Is

The Instagram Node Lib is a helper library for [node](http://nodejs.org) that makes communicating with the [Instagram API](http://instagram.com/developer/) easy.

## Simple Example

Following is an example that loads the library, sets my CLIENT_ID and CLIENT_SECRET for accessing the API and makes a simple call to get information on the tag `#blue`.

    Instagram = require('instagram');

    Instagram.set('client_id', 'YOUR-CLIENT-ID');
    Instagram.set('client_secret', 'YOUR-CLIENT-SECRET');

    Instagram.tags.info({
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

    Instagram.set('client_id', 'YOUR-CLIENT-ID');
    Instagram.set('client_secret', 'YOUR-CLIENT-SECRET');

Optionally, if you intend to use the real-time API to manage subscriptions, then you can also set a global callback url. (You may also provide/override the callback url when subscribing.)

    Instagram.set('callback_url', 'http://your.callback/path');

## Available Methods

_The methods currently available are limited to those available for non-user-specific interaction (i.e. anything that does not require authentication and an access_token). Look for those in future releases._

All of the methods below follow a similar pattern. Each accepts a single javascript object with the needed parameters to complete the API call. Required parameters are shown below; refer to [the API docs](http://instagram.com/developer/endpoints/) for the optional parameters. All parameters are passed through to the request, so use the exact terms that the API docs provide.

In addition, the parameters object may include two functions, one of which will be executed at the conclusion of the request (i.e. `complete` and `error`).

    {
      name: 'blue',
      complete: function(data, pagination){
          // data is a javascript object/array/null matching that shipped Instagram
          // when available (mostly /recent), pagination is a javascript object with the pagination information
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

#### Popular

Get the a set of 32 current popular media, each with all it's associated likes and comments.

    Instagram.media.popular();
      ->  [ { media object },
            { media object },
            { media object }, ... ]

#### Info

Get the metadata for a single media item by media id.

    Instagram.media.info({ media_id: 3 });
      ->  { media object }

#### Search

With a latitude and longitude (and an optional distance), find nearby media by geography.

    Instagram.media.search({ lat: 48.858844300000001, lng: 2.2943506 });
      ->  [ { media object },
            { media object },
            { media object }, ... ]

#### Likes

Akin to an info request, this method only returns an array of likers for the media.

    Instagram.media.likes({ media_id: 3 });
      ->  [ { username: 'krisrak',
              profile_picture: 'http://profile/path.jpg',
              id: '#',
              full_name: 'Rak Kris' },
            { username: 'mikeyk',
              profile_picture: 'http://profile/path.jpg',
              id: '#',
              full_name: 'Mike Krieger' } ]

#### Comments

Akin to an info request, this method only returns an array of comments on the media.

    Instagram.media.comments({ media_id: 3 });
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

#### Subscriptions

Geography subscriptions for media are also available with the following methods. A `callback_url` is required if not specified globally, and you may also provide a `verify_token` if you want to keep track of which subscription is coming back. Note that while `unsubscribe` is identical to the generic subscriptions method below, here, `unsubscribe_all` only removes geography subscriptions.

    Instagram.media.subscribe({ lat: 48.858844300000001, lng: 2.2943506, radius: 1000 });
      ->  { object: 'geography',
            object_id: '#',
            aspect: 'media',
            callback_url: 'http://your.callback/path',
            type: 'subscription',
            id: '#' }

    Instagram.media.unsubscribe({ id: # });
      ->  null // null is success, an error is failure

    Instagram.media.unsubscribe_all();
      ->  null // null is success, an error is failure

### Tags

The following tag methods are available. Required parameters are shown below, see the [Instagram API docs](http://instagram.com/developer/endpoints/tags/) for the optional parameters.

#### Info

Get the metadata for a single tag by name.

    Instagram.tags.info({ name: 'blue' });
      ->  { media_count: 10863, name: 'blue' }

#### Recent

Get an array of media that have been tagged with the tag recently. 

    Instagram.tags.recent({ name: 'blue' });
      ->  [ { media object },
            { media object },
            { media object }, ... ]

#### Search

Search for matching tags by name (q).

    Instagram.tags.search({ q: 'blue' });
      ->  [ { media_count: 10872, name: 'blue' },
            { media_count: 931, name: 'bluesky' },
            { media_count: 178, name: 'blueeyes' }, ... ]

#### Subscriptions

Tag subscriptions are also available with the following methods. A `callback_url` is required if not specified globally, and you may also provide a `verify_token` if you want to keep track of which subscription is coming back. Note that while `unsubscribe` is identical to the generic subscriptions method below, here, `unsubscribe_all` only removes tag subscriptions.

    Instagram.tags.subscribe({ object_id: 'blue' });
      ->  { object: 'tag',
            object_id: 'blue',
            aspect: 'media',
            callback_url: 'http://your.callback/path',
            type: 'subscription',
            id: '#' }

    Instagram.tags.unsubscribe({ id: # });
      ->  null // null is success, an error is failure

    Instagram.tags.unsubscribe_all();
      ->  null // null is success, an error is failure

### Locations

The following location methods are available. Required parameters are shown below, see the [Instagram API docs](http://instagram.com/developer/endpoints/locations/) for the optional parameters.

#### Info

Get the metadata for a single location by location id.

    Instagram.locations.info({ location_id: 1 });
      ->  { latitude: 37.78265474565738,
            id: '1',
            longitude: -122.387866973877,
            name: 'Dogpatch Labs' }

#### Recent

Get an array of media that have been located with the matching location (by id) recently.

    Instagram.locations.recent({ location_id: 1 });
      ->  [ { media object },
            { media object },
            { media object }, ... ]

#### Search

With a latitude and longitude (and an optional distance), find nearby locations by geography.

    Instagram.locations.search({ lat: 48.858844300000001, lng: 2.2943506 });
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

#### Subscriptions

Location subscriptions are also available with the following methods. A `callback_url` is required when subscribing if not specified globally, and you may also provide a `verify_token` if you want to keep track of which subscription is coming back. Note that while `unsubscribe` is identical to the generic subscriptions method below, here, `unsubscribe_all` only removes location subscriptions.

    Instagram.locations.subscribe({ object_id: '1257285' });
      ->  { object: 'location',
            object_id: '1257285',
            aspect: 'media',
            callback_url: 'http://your.callback/path',
            type: 'subscription',
            id: '#' }

    Instagram.locations.unsubscribe({ id: # });
      ->  null // null is success, an error is failure

    Instagram.locations.unsubscribe_all();
      ->  null // null is success, an error is failure

### Users

The following user methods are available. Required parameters are shown below, see the [Instagram API docs](http://instagram.com/developer/endpoints/users/) for the optional parameters.

#### Info

Get the metadata for a single user by user id.

    Instagram.users.info({ user_id: 291024 });
      ->  { username: 'mckelvey',
            counts: { media: 526, followed_by: 293, follows: 265 },
            profile_picture: 'http://profile/path.jpg',
            id: '291024',
            full_name: 'David McKelvey' }

#### Search

Search for matching users by name (q).

    Instagram.users.search({ q: 'mckelvey' });
      ->  [ { username: 'mckelvey',
              profile_picture: 'http://profile/path.jpg',
              id: '291024',
              full_name: 'David McKelvey' }, ... ]

### Real-time Subscriptions

In addition to the above subscription methods within tags, locations and media, you can also interact with any subscription directly with the methods below. As with the others, it will be helpful to review the [Instagram API docs](http://instagram.com/developer/realtime/) for additional information.

#### Subscribe

The subscription request differs here in that it will not know what kind of object (tag, location, geography) to which you want to subscribe, so be sure to specify it. A `callback_url` is required when subscribing if not specified globally, and you may also provide a `verify_token` if you want to keep track of which subscription is coming back.

    Instagram.subscribe({ object: 'tag', object_id: 'blue' });
      ->  { object: 'tag',
            object_id: 'blue',
            aspect: 'media',
            callback_url: 'http://your.callback/path',
            type: 'subscription',
            id: '#' }

#### Subscriptions

Retrieve a list of all your subscriptions.

    Instagram.subscriptions();
      ->  [ { object: 'tag',
              object_id: 'blue',
              aspect: 'media',
              callback_url: 'http://your.callback/path',
              type: 'subscription',
              id: '#' }, ... ]

#### Unsubscribe

To unsubscribe from a single subscription, you must provide the subscription id.

    Instagram.unsubscribe({ id: # });
      ->  null // null is success, an error is failure

#### Unsubscribe All

Unsubscribe from all subscriptions of all kinds.

    Instagram.unsubscribe_all();
      ->  null // null is success, an error is failure

## Developers

Hey, this is my first Node.js project, my first NPM package, and my first public repo (and happy to finally be giving back for all the code I've enjoyed over the years). If you have suggestions please email me, register an issue, fork and branch, etc. (You know the routine probably better than I.)

If you add additional functionality, your pull request must have corresponding additional tests and supporting documentation.

I've used [CoffeeScript](http://jashkenas.github.com/coffee-script) to write this library. If you haven't tried it, I highly recommend it. CoffeeScript takes some of the work out of javascript structures, with only an occasional mis-understanding. (Definitely check your compiled code when getting an error.) Refer to the CoffeeScript docs for installation and usage. 

### Tests

There is a test suite in the /tests folder with the tests I used to ensure the library functions as intended. If you're adding or changing functionality, please add to or update the corresponding tests before issuing a pull request. The tests require [Express](https://github.com/visionmedia/express), [Expresso](https://github.com/visionmedia/expresso) and [Should](https://github.com/visionmedia/should.js):

    npm install express
    npm install expresso
    npm install should

In addition, either export or add to your shell profile your CLIENT_ID, CLIENT_SECRET, and CALLBACK_URL so that they are available during testing via process.env.
