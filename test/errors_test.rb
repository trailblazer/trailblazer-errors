require "test_helper"

# ## Goals
# * allow "adding" errors in contract/Reform validations
# * allow "adding" errors in user validations, e.g. steps
# * expose API {form_for}, {assert_fail} etc can deal with
#
# ## API
# * we need {add}, but we also need wrapping of existing "native" errors object, e.g. from AMV or Dry-validation
#
# ## TODO
# * nested errors, paths, dotted errors (do we need that?)
#
# ## References
#
# Rails 6.1+ errors: https://api.rubyonrails.org/classes/ActiveModel/Errors.html

class ErrorsTest < Minitest::Spec
  it "prototyping" do
    require "dry-validation"
    Schema = Dry::Validation.Contract do
      params do
        required(:id).filled
        required(:title).filled
      end
    end

    result = Schema.({})
    puts "@@@@@ #{result.errors.inspect}"

# dry errors
    errors = Trailblazer::Errors.new
    errors.merge!(result, backend: :dry)


    assert_equal errors[:id].inspect, "["
    assert_equal errors[:title].inspect, "["
    # non-existant
    assert_equal errors[:nonexistant].inspect, "["
    # TODO: {errors.messages} etc
  end

  def assert_equal(actual, expected)
    super(expected, actual)
  end
end
