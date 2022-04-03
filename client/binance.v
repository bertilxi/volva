module client

import net.http
import json
import client { MedianizerPrice, get_pair }

struct BinanceResponse {
	price string
}

pub struct Binance {
	name string = 'binance'
}

pub fn (this Binance) get_price(pair_code string) []MedianizerPrice {
	pair := get_pair(pair_code, '')

	response := http.get('https://api.binance.com/api/v3/ticker/price?symbol=$pair') or {
		return []
	}

	data := json.decode(BinanceResponse, response.text) or { return [] }

	return [
		MedianizerPrice{
			name: this.name
			pair_code: pair_code
			price: data.price
		},
	]
}
