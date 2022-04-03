module client

import net.http
import json
import client { MedianizerPrice }

struct KucoinData {
	price string
}

struct KucoinResponse {
	data KucoinData
}

pub struct Kucoin {
	name string = 'kucoin'
}

pub fn (this Kucoin) get_price(pair_code string) []MedianizerPrice {
	pair := get_pair(pair_code, '-')

	response := http.get('https://api.kucoin.com/api/v1/market/orderbook/level1?symbol=$pair') or {
		return []
	}

	data := json.decode(KucoinResponse, response.text) or { return [] }

	return [
		MedianizerPrice{
			name: this.name
			pair_code: pair_code
			price: data.data.price
		},
	]
}
