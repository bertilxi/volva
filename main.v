import arrays
import json
import client {
	Binance,
	Bitso,
	Buda,
	Coinbase,
	CriptoYa,
	CryptoMkt,
	Cryptocom,
	Ftx,
	Gateio,
	Huobi,
	Kucoin,
	MedianizerClient,
	MedianizerPrice,
	MedianizerResult,
	Okx,
	Ripio,
}

fn get_price(pair_code string) MedianizerResult {
	mut providers := []MedianizerClient{}
	providers << Binance{}
	providers << Bitso{}
	providers << Buda{}
	providers << Coinbase{}
	providers << CriptoYa{}
	providers << Cryptocom{}
	providers << CryptoMkt{}
	providers << Ftx{}
	providers << Gateio{}
	providers << Huobi{}
	providers << Kucoin{}
	providers << Ripio{}
	providers << Okx{}

	mut threads := []thread []MedianizerPrice{}

	for provider in providers {
		threads << go provider.get_price(pair_code)
	}

	mut prices := arrays.flatten<MedianizerPrice>(threads.wait()).filter(it.price.len > 0
		&& it.price != '0')

	prices.sort_with_compare(fn (a &MedianizerPrice, b &MedianizerPrice) int {
		return int(a.price.f64() - b.price.f64())
	})

	middle := int(((prices.len - 1) / 2))

	return MedianizerResult{
		prices: prices
		pair_code: pair_code
		price: if prices.len > 0 { prices[middle] } else { MedianizerPrice{} }
	}
}

fn main() {
	pairs := [
		'ETH/ARS',
		'BTC/ARS',
		'USDT/ARS',
		'DAI/ARS',
		'USDC/ARS',
		'ETH/BTC',
		'BTC/DAI',
		'BTC/USDT',
		'BTC/USDC',
		'ETH/DAI',
		'ETH/USDT',
		'ETH/USDC',
		'DAI/USDT',
		'DAI/USDC',
		'USDC/USDT',
	]

	mut threads := []thread MedianizerResult{}

	for pair in pairs {
		threads << go get_price(pair)
	}

	prices := threads.wait()

	print(json.encode(prices))
}
