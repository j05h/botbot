require 'spec_helper'

describe Regexp do
  it 'matches reviews' do
    matcher = /#{ENV['REVIEW_MATCHER']}/
    testcase = ENV['REVIEW_MATCHER_TEST_URL']
    expect(testcase).to match(matcher)
  end
end
