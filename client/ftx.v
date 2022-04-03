module client

import net.http
import json
import client { MedianizerPrice }

struct FtxResult {
	price f64
}

struct FtxResponse {
	result FtxResult
}

pub struct Ftx {
	name string = 'ftx'
}

pub fn (this Ftx) get_price(pair_code string) []MedianizerPrice {
	response := http.get('https://ftx.com/api/markets/$pair_code') or { return [] }

	data := json.decode(FtxResponse, response.text) or { return [] }

	return [
		MedianizerPrice{
			name: this.name
			pair_code: pair_code
			price: data.result.price.str()
		},
	]
}
