# Search Analytics GA4

#TODO add description

# To do

- [ ] Compare the data for 1 day's worth of data outputted from this repo vs the Search Analytics Python repo.

- [x] Add tests for the google_analytics directory.

- [ ] Generate GA4 credentials and ask a PA to add the service account email address to the Google Analytics console. Check if we need different creds per environment. Currently we are using creds from the GOV.UK display screen.

- [ ] Get token limit info for the client library and assess whether we will be able to retrieve all the data that we need (14 days).

- [ ] Compare the data for 14 day's worth of data outputted from this repo vs the Search Analytics Python repo.

- [ ] RFC for re-writing this app in Ruby.

- [ ] Make a Github action to export the page-traffic.dump file to [S3](https://github.com/alphagov/search-api/blob/main/lib/tasks/page_traffic.rake#L9). That file is [read into Search API every night](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-production.yaml#L2156).








## Dependencies

```
bundle install
```

## Run
```
ruby search_analytics.rb
```

## Tests

```
bundle exec rspec
```
