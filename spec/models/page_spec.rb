require 'spec_helper'

describe Spree::Page do
  before(:each) do
    @page = Spree::Page.create(
    :title => 'test page',
    :slug => 'test-page',
    :body => 'this is a test page'
    )
  end

  it "should be valid" do
    @page.should be_valid
  end

  it "should ensure that slug starts with a slash" do
    @page.slug.should == '/test-page'

    @page.slug = 'test-page-updated'
    @page.save!
    @page.slug.should == '/test-page-updated'
  end

  it "should #find_by_slug with or without a slash prefix" do
    Spree::Page.find_by_slug('/test-page').should == @page
    Spree::Page.find_by_slug('test-page').should == @page
  end

  it "should #find_by_slug! with or without a slash prefix" do
    Spree::Page.find_by_slug!('/test-page').should == @page
    Spree::Page.find_by_slug!('test-page').should == @page
  end
end
