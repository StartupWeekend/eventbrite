require 'helper'

describe Eventbrite::REST::UserOrganizers do
  let(:client) { Eventbrite::REST::Client.new(oauth_token:"TOKEN")}

  let(:params) do
    {
      "organizer.name" => "Event Action Team",
      "organizer.description.html" => "A guy, a girl, and an event planner"
    }
  end

  describe '.create_user_organizer' do
    subject { client.create_user_organizer(params) }

    before do
      stub_post('/v3/organizers/').
        with(params).
        to_return(
          body: fixture('user_organizer.json'),
          headers: {content_type: 'application/json; charset=utf-8'}
        )
    end

    it { should be_kind_of(Eventbrite::Organizer) }
    it { subject; expect(a_post('/v3/organizers/').with(params)).to have_been_made }
  end

  describe '.update_user_organizer' do
    subject { client.update_user_organizer(organizer_id, params) }

    before do
      stub_post("/v3/organizers/#{organizer_id}/").
       with(params).
       to_return(
          body: fixture('user_organizer.json'),
          headers: {content_type: 'application/json; charset=utf-8'}
       )
    end

    let(:organizer_id) { rand(100) }

    it { should be_kind_of(Eventbrite::Organizer) }
    it { subject; expect(a_post("/v3/organizers/#{organizer_id}/").with(params)).to have_been_made }
  end

  describe '.list_user_organizers' do
    subject { client.list_user_organizers }

    before do
      stub_get('/v3/users/me/organizers/').
        with(:query => {page:1}).
        to_return(
          body: fixture('user_organizers.json'),
          headers: {content_type: 'application/json; charset=utf-8'}
        )
    end

    it_behaves_like 'a cursor'
    it { subject; expect(a_get('/v3/users/me/organizers/').with(:query => {page:1})).to have_been_made }
    its(:first) { should be_a_kind_of(Eventbrite::Organizer) }
  end
end