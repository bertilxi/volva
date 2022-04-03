module client

import net.http
import json
import client { MedianizerPrice }

struct OkxData {
	last string
}

struct OkxResponse {
	data []OkxData
}

pub struct Okx {
	name string = 'okx'
}

pub fn (this Okx) get_price(pair_code string) []MedianizerPrice {
	pair := get_pair(pair_code, '-')

	response := http.get('https://www.okx.com/api/v5/market/ticker?instId=$pair') or { return [] }

	data := json.decode(OkxResponse, response.text) or { return [] }

	return [
		MedianizerPrice{
			name: this.name
			pair_code: pair_code
			price: if data.data.len > 0 { data.data[0].last } else { '' }
		},
	]
}
