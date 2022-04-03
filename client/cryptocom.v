module client

import net.http
import json
import client { MedianizerPrice, get_pair }

struct CryptocomDataNumber {
	k f64
}

struct CryptocomData {
	data CryptocomDataNumber
}

struct CryptocomResponse {
	result CryptocomData
}

pub struct Cryptocom {
	name string = 'crypto.com'
}

pub fn (this Cryptocom) get_price(pair_code string) []MedianizerPrice {
	pair := get_pair(pair_code, '_')

	response := http.get('https://api.crypto.com/v2/public/get-ticker?instrument_name=$pair') or {
		return []
	}

	data := json.decode(CryptocomResponse, response.text) or { return [] }

	return [
		MedianizerPrice{
			name: this.name
			pair_code: pair_code
			price: data.result.data.k.str()
		},
	]
}
