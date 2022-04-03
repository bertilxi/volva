module client

import net.http
import json
import client { MedianizerPrice, get_pair }

struct CoinbaseResponse {
	price string
}

pub struct Coinbase {
	name string = 'coinbase'
}

pub fn (this Coinbase) get_price(pair_code string) []MedianizerPrice {
	pair := get_pair(pair_code, '-')

	response := http.get('https://api.exchange.coinbase.com/products/$pair/ticker') or { return [] }

	data := json.decode(CoinbaseResponse, response.text) or { return [] }

	return [
		MedianizerPrice{
			name: this.name
			pair_code: pair_code
			price: data.price
		},
	]
}
