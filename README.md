# ImportCSVToSpreadsheet
Import csv to Google Spreadsheet

Using [google-drive-ruby](https://github.com/gimite/google-drive-ruby).

# How to use
```
$ bundle install --path vendor/bundle
$ cp config_sample.yml config.yml
```

Set up your client_id and client_secret.
“Create a client ID and client secret” in [this page](https://developers.google.com/drive/web/auth/web-server) to get a client ID and client secret for OAuth.

Set up spreadsheet_id.
A spreadsheet is prepared beforehand.
spreadsheet_id is located between "d" and "edit" in the URL.

Run.
```
$ bundle exec ruby ImportCSVToSpreadsheet.rb [csv file name]
```

Set up authorization.
```
1. Open this page:
https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&scope=https://www.googleapis.com/auth/drive%20https://spreadsheets.google.com/feeds/

2. Enter the authorization code shown in the page:
```

Set up refresh_token to config.yml.
```
your refresh_token is:
1/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
please write to config.yml.
----

```

Rerun.
```
$ bundle exec ruby ImportCSVToSpreadsheet.rb [csv file name]
```
