module client

import net.http
import json
import client { MedianizerPrice }

struct CriptoYaResponse {
	ask f64
}

pub struct CriptoYa {
	name string = 'criptoya'
}

fn fetch(endpoint string) CriptoYaResponse {
	response := http.get(endpoint) or { return CriptoYaResponse{
		ask: 0
	} }

	data := json.decode(CriptoYaResponse, response.text) or {
		CriptoYaResponse{
			ask: 0
		}
	}

	return data
}

pub fn (this CriptoYa) get_price(pair_code string) []MedianizerPrice {
	pair := pair_code.to_lower()

	endpoints := [
		'https://criptoya.com/api/latamex/$pair',
		'https://criptoya.com/api/bitex/$pair',
		'https://criptoya.com/api/letsbit/$pair',
		'https://criptoya.com/api/decrypto/$pair',
		'https://criptoya.com/api/cryptomkt/$pair',
		'https://criptoya.com/api/bitso/$pair',
	]
	mut threads := []thread CriptoYaResponse{}

	for endpoint in endpoints {
		threads << go fetch(endpoint)
	}

	responses := threads.wait()

	mut result := []MedianizerPrice{}

	for response in responses {
		if response.ask == 0 {
			continue
		}

		result << MedianizerPrice{
			name: this.name
			pair_code: pair_code
			price: response.ask.str()
		}
	}

	return result
}
