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

request example: https://nominatim.openstreetmap.org/search?q=Texas&format=json

link for api documentation: https://nominatim.org/release-docs/develop/api/Overview/

### Meteomatics

Service that provides weather data

request example: https://api.meteomatics.com/2022-10-08T00:00:00Z/t_2m:C/52.520551,13.461804/json

link for api documentation: https://www.meteomatics.com/en/api/getting-started/

### Redis

Install redis before run application and set connection url into config

## App tests run

## App configuration
### Env parameters

| Parameter                |     Values      | Usage                                                         |
|:-------------------------|:---------------:|:--------------------------------------------------------------|
| LOCATION_SERVICE_API     |   string, url   | Url for the third party service that provides location search |
| WEATHER_SERVICE_API      |   string, url   | Url for the third party service that provides weather data    |
| WEATHER_SERVICE_USERNAME |     string      | Username for login into weather data provider                 |
| WEATHER_SERVICE_PASSWORD |     string      | Password for login into weather data provider                 |
| REDIS_URL                |   string, url   | Url for connection to Redis                                   |
