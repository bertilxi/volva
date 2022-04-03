module client

import net.http
import json
import client { MedianizerPrice }

struct GateioResponse {
	lowest_ask string
}

pub struct Gateio {
	name string = 'gate.io'
}

pub fn (this Gateio) get_price(pair_code string) []MedianizerPrice {
	pair := get_pair(pair_code, '_')

	response := http.get('https://api.gateio.ws/api/v4/spot/tickers?currency_pair=$pair') or {
		return []
	}

	data := json.decode([]GateioResponse, response.text) or { return [] }

	return [
		MedianizerPrice{
			name: this.name
			pair_code: pair_code
			price: if data.len > 0 { data[0].lowest_ask } else { '' }
		},
	]
}
