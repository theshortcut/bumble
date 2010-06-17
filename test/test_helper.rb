ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic/test_case'

class ActiveSupport::TestCase

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all


  # Add more helper methods to be used by all tests here...
  def self.should_have_timestamps
    should have_db_column(:created_at).of_type(:datetime)
    should have_db_column(:updated_at).of_type(:datetime)
  end

  def self.should_accept_nested_attributes_for(*attr_names)
    klass = self.name.gsub(/Test$/, '').constantize

    context "#{klass}" do
      attr_names.each do |association_name|
        should "accept nested attrs for #{association_name}" do
          meth = "#{association_name}_attributes="
          assert  ([meth,meth.to_sym].any?{ |m| klass.instance_methods.include?(m) }),
                  "#{klass} does not accept nested attributes for #{association_name}"
        end
      end
    end
  end

  def self.should_have_attached_file(attachment)
    klass = self.name.gsub(/Test$/, '').constantize

    context "To support a paperclip attachment named #{attachment}, #{klass}" do
      should have_db_column("#{attachment}_file_name".to_sym).of_type(:string)
      should have_db_column("#{attachment}_content_type".to_sym).of_type(:string)
      should have_db_column("#{attachment}_file_size".to_sym).of_type(:integer)
    end

    should "have a paperclip attachment named ##{attachment}" do
      assert klass.new.respond_to?(attachment.to_sym), "@#{klass.name.underscore} doesn't have a paperclip field named #{attachment}"
      assert_equal Paperclip::Attachment, klass.new.send(attachment.to_sym).class
    end
  end

  #def self.should_be_paranoid
    #klass = self.name.gsub(/Test$/, '').constantize
    #should have_db_column(:deleted_at)

    #should "be paranoid (it will not be deleted from the database)" do
      ## Removed so that it tests the model has declared is_paranoid
      ## assert klass.is_paranoid
      #assert klass.included_modules.include?(IsParanoid::InstanceMethods)
    #end

    #should "not have a value for deleted_at" do
      #assert object = klass.find(:first)
      #assert_nil object.deleted_at
    #end

    #context "when destroyed" do
      #setup do
        #assert object = klass.find(:first), "This context requires there to be an existing #{klass}"
        #@deleted_id = object.id
        #object.destroy
      #end

      #should "not be found" do
        #assert_raise(ActiveRecord::RecordNotFound) { klass.find(@deleted_id) }
      #end

      #should "still exist in the database" do
        #deleted_object = klass.find_with_destroyed(@deleted_id)
        #assert_not_nil deleted_object.deleted_at
      #end
    #end
  #end

  def self.should_be_denied_access(message = 'You must be logged in to do that!')
    should_set_the_flash_to message
    should_redirect_to('the login page') { login_url}
  end

  def dom_id(object)
    "#{object.class.to_s.downcase}_#{object.id}"
  end

end
