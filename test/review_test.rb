require_relative 'minitest_helper'

describe TrackerApi::Resources::Review do
  let(:pt_user) { PT_USER_1 }
  let(:client) { TrackerApi::Client.new token: pt_user[:token] }
  let(:story) do
    TrackerApi::Resources::Story.new(
      client: client,
      project_id: pt_user[:project_id],
      id: '66728004'
    )
  end
  let(:reviews) { VCR.use_cassette('get story reviews') { story.reviews } }
  let(:existing_review) { reviews.first }

  it 'can update an existing review' do
    new_state = 'pass'
    existing_review.status = new_state

    VCR.use_cassette('save review', record: :new_episodes) do
      existing_review.save
    end

    _(existing_review.status).must_equal new_state
    _(existing_review.clean?).must_equal true
  end
end
