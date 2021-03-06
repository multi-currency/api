require_relative './spec_helper.rb'

describe 'MultiCurrency', type: :controller do
  let(:index) {
    {
      success: 1,
      message: '',
      data: JSON.parse(File.read("#{File.dirname(__FILE__)}/../assets/description.json")),
    }
  }

  let(:currency) {
    {
      success: 1,
      message: '',
      data: JSON.parse(File.read("#{File.dirname(__FILE__)}/../assets/currency.json")).sort.to_h,
    }
  }

  let(:plugins) {
    {
      success: 1,
      message: '',
      data: JSON.parse(File.read("#{File.dirname(__FILE__)}/../assets/plugins.json")),
    }
  }

  let(:converted) { JSON.parse File.read("#{File.dirname(__FILE__)}/fixtures/converted.json") }
  let(:converted_error) { JSON.parse File.read("#{File.dirname(__FILE__)}/fixtures/converted_error.json") }
  let(:converted_error_not_numeric) { JSON.parse File.read("#{File.dirname(__FILE__)}/fixtures/converted_error_not_numeric.json") }
  let(:converted_error_lower_than_zero) { JSON.parse File.read("#{File.dirname(__FILE__)}/fixtures/converted_error_lower_than_zero.json") }

  it 'index should show api description' do
    get '/'
    expect(last_response.body).to eq(index.to_json)
  end

  it 'currency should show all available currency with description' do
    get '/currency'
    expect(last_response.body).to eq(currency.to_json)
  end

  it 'plugins should show all available plugins' do
    get '/plugins'
    expect(last_response.body).to eq(plugins.to_json)
  end

  it 'convert 55 USD to USD should show same value' do
    get '/convert/55?from=USD&to=USD'
    expect(last_response.body).to eq(converted.to_json)
  end

  it 'convert not numeric value' do
    get '/convert/abc?from=USD&to=USD'
    expect(last_response.body).to eq(converted_error_not_numeric.to_json)
  end

  it 'convert value zero' do
    get '/convert/0?from=USD&to=USD'
    expect(last_response.body).to eq(converted_error_lower_than_zero.to_json)
  end

  it 'convert using currency_layer from currency different than USD should not work' do
    get '/convert/55?from=BRL&to=USD&use=currency_layer'
    expect(last_response.body).to eq(converted_error.to_json)
  end
end
