module client

import net.http
import json
import client { MedianizerPrice }

struct HuobiTick {
	ask []f64
}

struct HuobiResponse {
	tick HuobiTick
}

pub struct Huobi {
	name string = 'huobi'
}

pub fn (this Huobi) get_price(pair_code string) []MedianizerPrice {
	pair := get_pair(pair_code, '').to_lower()

	response := http.get('https://api.huobi.pro/market/detail/merged?symbol=$pair') or { return [] }

	data := json.decode(HuobiResponse, response.text) or { return [] }

	return [
		MedianizerPrice{
			name: this.name
			pair_code: pair_code
			price: if data.tick.ask.len > 0 { data.tick.ask[0].str() } else { '' }
		},
	]
}
