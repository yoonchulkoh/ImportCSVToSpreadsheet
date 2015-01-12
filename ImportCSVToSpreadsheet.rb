require "rubygems"
require "google/api_client"
require "google_drive"
require "csv"

csv_file_path = ARGV[0]
if csv_file_path.nil?
  puts 'csv file path is not.'
  exit
end
unless File.exist?(csv_file_path)
  puts 'csv file is not found.'
  exit
end

config = YAML.load_file('config.yml')

# check
['client_id', 'client_secret', 'spreadsheet_id'].each do |key|
  if config[key].nil? || config[key].empty?
    puts "#{key} is not found in config file."
    exit
  end
end

# Authorizes with OAuth and gets an access token.
client = Google::APIClient.new
auth = client.authorization
auth.client_id = config['client_id']
auth.client_secret = config['client_secret']
auth.scope =
    "https://www.googleapis.com/auth/drive " +
    "https://spreadsheets.google.com/feeds/"
auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
auth.refresh_token = config['refresh_token']

begin
  auth.fetch_access_token!
rescue
  print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
  print("2. Enter the authorization code shown in the page: ")
  auth.code = $stdin.gets.chomp
  auth.fetch_access_token!
  access_token = auth.access_token
  refresh_token = auth.refresh_token

  puts "your refresh_token is:\n#{refresh_token}"
  puts "please write to config.yml."
  puts "----"

  exit
end

# login
session = GoogleDrive.login_with_oauth(client)

# generate ws instance
begin
  ws = session.spreadsheet_by_key(config['spreadsheet_id']).worksheet_by_gid(config['gid'])
rescue
  ws = session.spreadsheet_by_key(config['spreadsheet_id']).worksheets[0]
end

# all clear
for row in 1..ws.num_rows
  for col in 1..ws.num_cols
    ws[row, col] = nil
  end
end

# csv upload
csv = CSV.read(csv_file_path)
csv.each_with_index do |row, i|
    row.each_with_index do |value, j|
        ws[i+1, j+1] = value
    end
end

ws.save