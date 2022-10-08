# README

This README would normally document whatever steps are necessary to get the
application up and running.

## App execute
- run `bundle install`
- run `rails s`

Application will be accessible via url:

* Listening on http://127.0.0.1:3000
* Listening on http://[::1]:3000

## App dependency
### Open Street Map
Service that provides location search by address.

base request looks like: `https://nominatim.openstreetmap.org/search?q=[address]&format=[response format]`

link for api documentation: https://nominatim.org/release-docs/develop/api/Overview/

## App tests run

## App configuration
### Env parameters

|       Parameter       |   Values    |                             Usage                             |
|:---------------------:|:-----------:|:-------------------------------------------------------------:|
| LOCATION_SERVICE_API  | string, url | Url for the third party service that provides location search |