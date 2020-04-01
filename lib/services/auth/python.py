import requests

headers = {
	'apikey': '60a7d670-5bba-11ea-a0f1-83daa96a75d6',
}

params = (
	('league', 'soccer-england-premier-league')
)

response = requests.get('https://app.oddsapi.io/api/v1/odds', headers=headers, params=params)

print(response.json())