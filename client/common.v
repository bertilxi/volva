module client

pub struct MedianizerPrice {
pub:
	pair_code string
	price     string
	name      string
}

pub struct MedianizerResult {
pub:
	pair_code string
	prices    []MedianizerPrice
	price     MedianizerPrice
}

pub interface MedianizerClient {
	get_price(pair_code string) []MedianizerPrice
}

pub fn get_pair(pair_code string, separator string) string {
	assets := pair_code.split('/')
	asset1 := assets[0]
	asset2 := assets[1]

	return '$asset1$separator$asset2'
}
