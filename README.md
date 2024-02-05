# Search Analytics GA4

## Overview

This application re-engineers the [Search Analytics](https://github.com/alphagov/search-analytics) repo in Ruby and upgrades it to GA4. GA4 is the most recent version of Google Analytics. Universal Analytics is being turned off in July 2024.

Search Analytics is used to extract page view data from Google Analytics. The output of running the Search Analytics code is a file that contains each GOV.UK page path along with the number of page views, popularity ranking (1 = most popular GOV.UK page, 2 is second most popular etc) and a popularity score.

Search Analytics is run each night using a Github action. This file is then imported into the Search API. This ‘popularity data’ is used to calculate the relevancy of search results along with other data such as ‘best bets’ and ‘recency’. These results are then re-ranked using a machine learning model called ‘Learn to Rank’.

## Documentation
[This RFC extensively documents this project](https://docs.google.com/document/d/14nyE7w6uHJR-s6ywHHNsWwGZtBmmaX2mubuk5IPxNf8/edit?usp=sharing). Please refer to it for further information.

It highlights that there are data discrepancies between UA and GA4, so it will be impossible to exactly match the data from the Python application. However, it should provide Search API with accurate popularity data.

## Usage

It  has been decided that the K&C Search team will convert finders which sort by ‘most viewed’ popularity data to utilise Search V2. Please see the 'Outcome' section of the [RFC](https://docs.google.com/document/d/14nyE7w6uHJR-s6ywHHNsWwGZtBmmaX2mubuk5IPxNf8/edit?usp=sharing) doc for further information.

Therefore, this repo is a backup in case this does not get completed before the UA/GA4 switchover deadline in July 2024.


## Dependencies

```
bundle install
```

## Run

### Generate credentials for GA4

API access to GOV.UK’s Google Analytics data involves creating a service account within Google Cloud Platform and generating credentials. These credentials are added to a `.env` file, to be used by the client. The service account email address must be added as a user to the correct Google Analytics property/view by a Performance Analyst. See the [Client authentication](https://docs.google.com/document/d/14nyE7w6uHJR-s6ywHHNsWwGZtBmmaX2mubuk5IPxNf8/edit?usp=sharing) section for more information.

For initial testing, it is possible to use the GA4 credentials from the [GOV.UK Display Screen project](https://github.com/alphagov/govuk-display-screen) which runs on Heroku. It is authenticated for the GA4 property that this application will use.

Set these within a `.env` file:

```
GOOGLE_ACCOUNT_TYPE=
PROJECT_ID=
GOOGLE_PRIVATE_KEY_ID=
GOOGLE_CLIENT_EMAIL=
GOOGLE_CLIENT_ID=
GOOGLE_AUTH_URI=
GOOGLE_TOKEN_URI=
GOOGLE_AUTH_PROVIDER_X509_CERT_URL=
GOOGLE_CLIENT_X509_CERT_URL=
```

### Run the app

```
ruby search_analytics.rb
```

## Tests

```
bundle exec rspec
```

### Additional work that needs to be done

- At the moment only the previous days worth of data is requested. Within the Python application, a caching mechanism (writing data to a file) stores data for a duration of 14 days, allowing the retrieval of only a single day's dataset per day. We spoke with a PA on the Analytics team to explore the possibility of simplifying this process by relying solely on a daily dataset. The rationale behind this stemmed from the notion that data spanning a 14-day period might not adequately capture current trends in popularity. The PA agreed that this seemed viable, but it would be useful to speak to the Search team in an attempt to uncover why 14 days worth of data was used to begin with.

- A plan needs to be put in place for manually testing the accuracy with Performance Analysts.

## How to test on integration

A proposed approach to testing Search results manually is as follows:

-  Add a rake task in Search API to important data from an alternative file name.
- Generate a file with the alternative name using the Github action in the Ruby app.
- Change the cron job in GOV.UKs integration environment to run the new Search API rake task.
- Test out the search results manually in integration with the help of a performance analyst.

[A branch with a Github action for running Search Analytics can be found here](https://github.com/alphagov/search-analytics-ga4/tree/add-github-action).

Please see the [Testing section of the RFC](https://docs.google.com/document/d/14nyE7w6uHJR-s6ywHHNsWwGZtBmmaX2mubuk5IPxNf8/edit?usp=sharing) for further details.
