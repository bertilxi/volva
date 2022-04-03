module client

import net.http
import json
import client { MedianizerPrice, get_pair }

struct BudaPayload {
	last_price []string
}

struct BudaResponse {
	ticker BudaPayload
}

pub struct Buda {
	name string = 'buda'
}

pub fn (this Buda) get_price(pair_code string) []MedianizerPrice {
	pair := get_pair(pair_code, '-')

	response := http.get('https://www.buda.com/api/v2/markets/$pair/ticker') or { return [] }

	data := json.decode(BudaResponse, response.text) or { return [] }

	return [
		MedianizerPrice{
			name: this.name
			pair_code: pair_code
			price: if data.ticker.last_price.len > 0 { data.ticker.last_price[0] } else { '' }
		},
	]
}
