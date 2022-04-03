module client

import net.http
import json
import client { MedianizerPrice, get_pair }

struct BitsoPayload {
	ask string
}

struct BitsoResponse {
	payload BitsoPayload
}

pub struct Bitso {
	name string = 'bitso'
}

pub fn (this Bitso) get_price(pair_code string) []MedianizerPrice {
	pair := get_pair(pair_code, '_').to_lower()

	response := http.get('https://api.bitso.com/v3/ticker?book=$pair') or { return [] }

	data := json.decode(BitsoResponse, response.text) or { return [] }

	return [
		MedianizerPrice{
			name: this.name
			pair_code: pair_code
			price: data.payload.ask
		},
	]
}
