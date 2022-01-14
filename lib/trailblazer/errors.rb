require_relative "errors/version"

module Trailblazer
  class Errors
    def initialize(errors={}) # name2errors
      @name2errors = errors
    end

    def merge_result!(result, backend: nil)

      return merge_dry_result!(result) if result.kind_of?(Dry::Validation::Result)
      raise # TODO: test me.
    end


    def [](name)
      name    = name.to_sym
      errors  = @name2errors[name] or return [] # FIXME: to_sym

      errors.collect { |msg| msg.text }
    end

    def add(name, messages)
      errors = Array(messages).collect { |msg| Error.new(name, msg) }

      merge_for!([[name, errors]])
    end

    def messages
      @name2errors.sort.collect { |name, errors| [name, errors.collect { |err| err.text }] }.to_h
    end

  private

    # Add messages to their respective error "fields", append if already existing.
    # {errors} is [[:id, [errors], [:title, ...]]]
    def merge_for!(errors)
      errors.each do |name, msg|
        existing_msgs = @name2errors[name] || []

        @name2errors[name] = existing_msgs + msg
      end

      self# TODO: test me.
    end

    def merge_dry_result!(result)
      # DISCUSS: keep result somewhere?

      # result.errors.to_h
      errors = result.errors.messages.collect do |msg|
        Error::Dry.Build(msg)
      end

      merge_for!(errors)
    end

    class Error < Struct.new(:name, :text)
      class Dry
        def self.Build(msg)
          return msg.path[0].to_sym, [Error::Dry.new(msg)]
        end

        def initialize(message)
          @message = message
        end

        def text
          @message.text
        end
      end
    end
  end
end
