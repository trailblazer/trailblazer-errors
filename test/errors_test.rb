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
    schema = Dry::Validation.Contract do
      params do
        required(:id).filled
        required(:type).value(type?: String)#.value(included_in?: %w(sale expense purchase receipt))
      end

      rule(:type) do
        key.failure('must be in the future')
        key.failure('is in the past')
      end
    end

    result = schema.({type: "past"})
    # puts "@@@@@ #{result.errors.inspect}"

# dry errors
    errors = Trailblazer::Errors.new
    # errors.merge_result!(result, backend: schema)
    errors.merge_result!(result)

    # symbol key returns list of error messages.
    assert_equal errors[:id].inspect, %{["is missing"]}
    # string key works, too.
    assert_equal errors["id"].inspect, %{["is missing"]}
    # multiple error messages
    assert_equal errors[:type].inspect, %{["must be in the future", "is in the past"]}
    # non-existant
    assert_equal errors[:nonexistant], []

# adding generic errors
    errors.add(:nonexistant, "Existence is futile")
    errors.add(:nonexistant, "What?")
    errors.add(:nonexistant, ["and", "more!"])

    assert_equal errors[:nonexistant].inspect, %{["Existence is futile", "What?", "and", "more!"]}

    # we can add errors to "native" errors.
    errors.add(:id, "and also not an Int!")
    assert_equal errors[:id].inspect, %{["is missing", "and also not an Int!"]}

  # Errors#messages
    assert_equal errors.messages.inspect, %{{:id=>[\"is missing\", \"and also not an Int!\"], :nonexistant=>[\"Existence is futile\", \"What?\", \"and\", \"more!\"], :type=>[\"must be in the future\", \"is in the past\"]}}

    # TODO: {errors.messages} etc
    # TODO: Errors#add as in Rails, with "type" etc
  end

  def assert_equal(actual, expected)
    super(expected, actual)
  end
end
