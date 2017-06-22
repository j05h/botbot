module Bot
  class ReviewBot < SlackRubyBot::Bot
    # REVIEW_MATCHER is defined in .env file
    # should be a regex that matches what your review URLS look like

    class << self
      attr_accessor :reviews
    end

    @reviews = []

    def self.review_matcher
      /#{ENV['REVIEW_MATCHER']}/
    end

    help do
      title "Review Tracker"
      desc  "This bot keeps track of outstanding code reviews"

      command "list" do
        desc "Shows you the current list of reviews being tracked"
      end

      command "add <url>" do
        desc "Adds a review URL to track"
      end

      command "remove <url>" do
        desc "Removes a URL from tracking"
      end
    end

    command 'list' do |client, data, match|
      response = if reviews.size > 0
                   "Sure <@#{data.user}>, here are the reviews which are outstanding:\n #{reviews.join(',')}"
                 else
                   "There are no currently tracked reviews, huzzah!"
                 end
      client.say(text: response, channel: data.channel)
    end

    match ReviewBot.review_matcher do |client, data, match|
      track_review client, data, match[0]
    end

    match /add (http.*)/ do |client, data, match|
      track_review client, data, match[1]
    end

    def self.track_review client, data, review
      response = "<@#{data.user}>, I'm tracking #{review}"
      client.say(text: response, channel: data.channel)

      reviews << review
      reviews.uniq!
    end

    match /remove (http.*)/ do |client, data, match|
      response = "<@#{data.user}>, I removed #{match[1]}"
      client.say(text: response, channel: data.channel)

      reviews.reject!{|item| item == match[1]}
      reviews.uniq!
    end

    match /hello/ do |client, data, match|
      client.say(channel: data.channel, text: "Hi back to yourself.")
    end

  end
end
