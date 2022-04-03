module client

import net.http
import json
import client { MedianizerPrice }

struct RipioResponse {
	last_price string
}

pub struct Ripio {
	name string = 'ripio'
}

pub fn (this Ripio) get_price(pair_code string) []MedianizerPrice {
	pair := get_pair(pair_code, '_')

	response := http.get('https://api.exchange.ripio.com/api/v1/rate/$pair') or { return [] }

	data := json.decode(RipioResponse, response.text) or { return [] }

	return [
		MedianizerPrice{
			name: this.name
			pair_code: pair_code
			price: data.last_price
		},
	]
}
