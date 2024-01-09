require 'spec_helper'
require_relative '../../lib/formatter'
require_relative '../../lib/page_data'

describe Formatter do
  describe "#consolidated_page_views" do
    it "doesn't have a slash" do
      page_data = [PageData.new("other", "other", "50")]
      formatter = Formatter.new(page_data)
      normalised_data = formatter.consolidated_page_views

      expect(normalised_data).to be_empty
    end

    it "strips out the trailing slash" do
      page_data = [PageData.new("/example/", "example", "50")]
      formatter = Formatter.new(page_data)
      normalised_data = formatter.consolidated_page_views

      expect(normalised_data).to eq({"/example"=>50})
    end

    it "converts an empty string to a slash" do
      page_data = [PageData.new("", "example", "50")]
      formatter = Formatter.new(page_data)
      normalised_data = formatter.consolidated_page_views

      expect(normalised_data).to eq({"/"=>50})
    end

    it "is a smart answer" do
      page_data = [PageData.new("/other/y/other", "smart answer", "10")]
      formatter = Formatter.new(page_data)
      normalised_data = formatter.consolidated_page_views

      expect(normalised_data).to be_empty
    end

    it "starts with a '/' and it is not a smart answer" do
      page_data = [PageData.new("/example", "not a smart answer", "20")]
      formatter = Formatter.new(page_data)
      normalised_data = formatter.consolidated_page_views

      expect(normalised_data).to eq({"/example"=>20})
    end

    it "consolidates page views for duplicated paths" do
      page_data = [
        PageData.new("/example", "not a smart answer", "20"),
        PageData.new("/example", "not a smart answer", "30")
      ]
      formatter = Formatter.new(page_data)
      normalised_data = formatter.consolidated_page_views

      expect(normalised_data).to eq({"/example"=>50})
    end

    it "consolidates page views for duplicated paths with query params" do
      page_data = [
        PageData.new("/example", "not a smart answer", "20"),
        PageData.new("/example?something=something", "not a smart answer", "30")
      ]
      formatter = Formatter.new(page_data)
      normalised_data = formatter.consolidated_page_views

      expect(normalised_data).to eq({"/example"=>50})
    end

    it "ignores pages that have 'Page Not Found - 404 - GOV.UK" do
      page_data = [
        PageData.new("/page-not-found", "Page not found - 404 - GOV.UK", "10"),
        PageData.new("/example", "not a smart answer", "20")
      ]
      formatter = Formatter.new(page_data)
      normalised_data = formatter.consolidated_page_views

      expect(normalised_data).to eq({"/example"=>20})
    end

    it "consolidates more than one URL" do
      page_data = [
        PageData.new("/example", "not a smart answer", "10"),
        PageData.new("/other", "other", "20"),
        PageData.new("/example?something=something", "not a smart answer", "30"),
        PageData.new("/example2", "not a smart answer", "10"),
        PageData.new("/example2?something=something", "not a smart answer", "30")
      ]
      formatter = Formatter.new(page_data)
      normalised_data = formatter.consolidated_page_views

      expect(normalised_data).to eq({"/example"=>40, "/other"=>20, "/example2"=>40})
    end

    it "removes data with the title and path of (other)" do
      page_data = [PageData.new("(other)", "(other)", "50")]
      formatter = Formatter.new(page_data)
      normalised_data = formatter.consolidated_page_views

      expect(normalised_data).to be_empty
    end

    it 'sorts the formatted data by page views (descending)' do
      page_data = [
        PageData.new("/example", "example", "20"),
        PageData.new("/example-two", "example-two", "10"),
        PageData.new("/example-three", "example-three", "30"),
        PageData.new("/example-four", "example-four", "5")
      ]

      formatter = Formatter.new(page_data)

      #Converts consolidated_page_views to an array for the test as RSpec eq doesn't match based on hash order
      expect(formatter.consolidated_page_views.to_a).to eq([["/example-three", 30], ["/example", 20], ["/example-two", 10], ["/example-four", 5]])
    end
  end
end
