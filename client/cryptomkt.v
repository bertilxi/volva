module client

import net.http
import json
import client { MedianizerPrice, get_pair }

struct CryptoMktResponse {
	last string
}

pub struct CryptoMkt {
	name string = 'cryptomkt'
}

pub fn (this CryptoMkt) get_price(pair_code string) []MedianizerPrice {
	pair := get_pair(pair_code, '')

	response := http.get('https://api.exchange.cryptomkt.com/api/3/public/ticker?symbols[]=$pair') or {
		return []
	}

	data := json.decode(map[string]CryptoMktResponse, response.text) or { return [] }

	return [
		MedianizerPrice{
			name: this.name
			pair_code: pair_code
			price: data[pair].last
		},
	]
}
