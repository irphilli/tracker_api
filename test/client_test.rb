require_relative 'minitest_helper'

describe TrackerApi do
  it 'has a version' do
    ::TrackerApi::VERSION.wont_be_nil
  end
end

describe TrackerApi::Client do
  it 'can be configured' do
    client = TrackerApi::Client.new(url:         'http://test.com',
                                    api_version: '/foo-bar/1',
                                    token:       '12345')

    client.url.must_equal 'http://test.com'
    client.api_version.must_equal '/foo-bar/1'
    client.token.must_equal '12345'
  end
end
