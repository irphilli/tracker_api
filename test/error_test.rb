require_relative 'minitest_helper'

describe TrackerApi::Error do
  let(:pt_user) { PT_USER_1 }
  let(:client) { TrackerApi::Client.new token: pt_user[:token] }
  let(:options) { { url: nil, headers: nil } }

  it 'raises ClientError for 4xx HTTP status codes' do
    (400..499).each do |status_code|
      mock_faraday_error(status_code)
      assert_raises TrackerApi::Errors::ClientError do
        client.send(:request, :get, options)
      end
    end
  end

  it 'raises ServerError for 5xx HTTP status codes' do
    (500..599).each do |status_code|
      mock_faraday_error(status_code)
      assert_raises TrackerApi::Errors::ServerError do
        client.send(:request, :get, options)
      end
    end
  end

  it 'raises RuntimeError for HTTP status codes < 400 and > 500' do
    [399, 600].each do |status_code|
      mock_faraday_error(status_code)
      assert_raises RuntimeError, "Expected 4xx or 5xx HTTP status code" do
        client.send(:request, :get, options)
      end
    end
  end

  # Simulate the error Faraday will raise with a specific HTTP status code so
  # we can test our rescuing of those errors
  def mock_faraday_error(status_code)
    mocked_error_class = if (500..599).include?(status_code) && Faraday::VERSION.to_f >= 16.0
      Faraday::ServerError
    else
      Faraday::ClientError
    end

    ::Faraday::Connection.any_instance.stubs(:get).
      raises(mocked_error_class.new(nil, { status: status_code}))
  end
end
