require 'spec_helper'

describe Bot::ReviewBot do
  def app
    Bot::ReviewBot.instance
  end

  subject { app }

  context "transparently add reviews" do
    before do
      @testcase = ENV['REVIEW_MATCHER_TEST_URL']
      @answer = Bot::ReviewBot.review_matcher.match(@testcase)[0]
      @message  = "@here please check out #{@testcase} please"
      @response = "<@user>, I'm tracking #{@answer}"
    end

    it 'sees reviews' do
      expect(channel: "channel", message: @message).to respond_with_slack_message(@response)
    end

    it 'adds reviews' do
      expect(channel: "channel", message: @message).to respond_with_slack_message(@response)
      expect(Bot::ReviewBot.reviews.last).to eq(@answer)
    end

    it 'does not add two reviews' do
      expect(channel: "channel", message: @message).to respond_with_slack_message(@response)
      expect(channel: "channel", message: @message).to respond_with_slack_message(@response)
      expect(Bot::ReviewBot.reviews.size).to eq(1)
    end

    it 'prints out the reviews' do
      message = "#{SlackRubyBot.config.user} list"
      response = "Sure <@user>, here are the reviews which are outstanding:\n #{@answer}"
      expect(channel: "channel", message: @message).to respond_with_slack_message(@response)
      expect(channel: "channel", message: message).to respond_with_slack_message(response)
    end
  end

  context "directly add a review" do
    it "adds a review" do
      url = "http://foo.bar.baz/123"
      message = "#{SlackRubyBot.config.user} add #{url}"
      response = "<@user>, I'm tracking #{url}"
      expect(channel: "channel", message: message).to respond_with_slack_message(response)

      expect(Bot::ReviewBot.reviews.last).to eq(url)
    end
  end

  context "directly removes a review" do
    it "removes a review" do
      url = "http://foo.bar.baz/123"
      Bot::ReviewBot.reviews << url

      message = "#{SlackRubyBot.config.user} remove #{url}"
      response = "<@user>, I removed #{url}"
      expect(channel: "channel", message: message).to respond_with_slack_message(response)

      expect(Bot::ReviewBot.reviews.last).to_not eq(url)
    end
  end

  it 'does not see non reviews' do
    message = "@here please check out this cat picture http://cheezburger.com/9046256128"

    expect(message: message).to not_respond
  end

  it_behaves_like 'a slack ruby bot'
end

