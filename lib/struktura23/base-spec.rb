module Struktura23
  module ProviderOwner
    def add_provider(*args)
      providers << args
    end

    def add_query_provider(*args)
      query_providers << args
    end

    def providers
      @providers ||= []
    end

    def query_providers
      @query_providers ||= []
    end

    def schemas
      # TODO: this should be like the following:
      # @schemas ||= {}
      @schemas ||= {
        :aws_launch_template => {
          :resource => {}
        },
        :aws_ami => {
          :data => {}
        }
      }
    end
  end

  module Enforceable
    def enforce(attribute, value=nil, &block)
      if block_given?
        # TODO: validate???
        context = Context.new(self, attribute)
        enforcers[attribute] = yield(context)
      elsif value
        enforcers[attribute] = value
      else
        raise "Either value or block should be specified"
      end
    end

    def enforcers
      @enforcers ||= {}
    end

    # TODO: default 'opentofu' value should be specified differently
    def provider
      @provider || "opentofu"
    end

    class Context
      def initialize(enforced_resource, enforced_attr)
        @enforced_resource = enforced_resource
        @enforced_attr = enforced_attr
      end

      def current_var
        # TODO: it is stub
        # "#{@enforced_resource.class}.#{@enforced_attr}"
        PromiseChain.new(@enforced_resource).send(@enforced_attr)
      end

      def current
        # TODO: it is stub
        PromiseChain.new(@enforced_resource)
      end

      def expr(template, input={})
        ExpressionTemplate.new(@enforced_resource.provider, template, input)
      end
    end
  end

  module Node
    class Base
      include Enforceable

      attr_reader :node_type, :label, :data_source, :wrapped_by, :input_enabled, :output_enabled

      def initialize(data_source, node_type, label=:main)
        @node_type = node_type
        @label = label
        @data_source = data_source
        @search_enabled = true
        @search_query = {}
        @input_enabled = true
        @output_enabled = true
        @extra_input_vars = {}
      end


      def disable_input
        @input_enabled = false
      end

      def disable_output
        @output_enabled = false
      end

      def wrap_by(wrapper)
        if wrapper.core.core_type != @node_type
          raise "Wrapper of a #{wrapper.core.core_type} cannot be used to wrap a #{@node_type}"
        end
        @wrapped_by = wrapper
      end

      def wrap
        @wrapped_by = Wrapper.new(of: @node_type, id: nil)
        yield(@wrapped_by)
      end

      def where(predicate)
        if predicate == false
          @search_enabled = false
        else
          @search_query = predicate
          enforcers.merge! predicate
        end
      end

      def add_var(vars_spec)
        @extra_input_vars.merge!(vars_spec)
      end

      def var
        # TODO: it is stub
        {}
      end

      # TODO: continue defining methods
      def method_missing(name, *args, &block)
        puts "I'm #{node_type}.#{label} and I don't care about #{name}"
      end
    end

    class Collection < Base
      def initialize(*args)
        super(*args)
        @identify_by = nil
        @for_each_override = nil
      end

      def identify
        promise_chain = PromiseChain.new(self)
        yield(promise_chain)
        @identify_by = promise_chain
      end

      # TODO: use lazy string interpolation [1]
      def override_for_each
        context = Context.new(self, :for_each)
        @for_each_override = yield(context)
      end


      def at(arg)
        # TODO: it is stub
        PromiseChain.new(self).send(:at, arg)
      end
    end

    class Singular < Base
      def one
        # TODO: it is stub
        PromiseChain.new(self)
      end
    end

    class Optional < Base
      def one
        # TODO: it is stub
        PromiseChain.new(self)
      end

      def flag_to_enable
        # TODO: it is stub
        "var.#{@data_source ? 'data_' : ''}#{@node_type}_#{@label}_enabled"
      end
    end
  end

  module Owner
    def core
    end

    def nodes
      @nodes ||= {}
    end

    def has!(node, &block)
      if block_given?
        if block.arity == 2 and core
          yield(node, core)
        else
          yield(node)
        end
      end

      nodes.merge!({node.node_type => {node.label => node}}) do |_, val1, val2|
        val1.merge val2
      end
    end

    def method_missing(method_name, *args, &block)
      if method_name =~ /^has_(many|one|optional)(_data)?$/
        node = case $1
        when "many"
          Node::Collection.new(!!$2, *args)
        when "one"
          Node::Singular.new(!!$2, *args)
        when "optional"
          Node::Optional.new(!!$2, *args)
        end
        has!(node, &block)
        node
      else
        super(method_name, *args, &block)
      end
    end
  end


  class BaseSpec
    extend ProviderOwner
    extend Owner

    class << self
      def has_wrapper(wrapper_key, options={})
        named_wrappers[wrapper_key] = wrapper = Wrapper.new(options.merge({:id => wrapper_key}))
        yield(wrapper, wrapper.core)
        wrapper
      end

      def named_wrappers
        @named_wrappers ||= {}
      end
    end
  end

  class Wrapper
    include Owner

    attr_reader :core, :id

    def initialize(options)
      @core = WrapperCore.new(options[:of])
      @id = options[:id]
    end
  end


  class WrapperCore
    include Enforceable

    attr_reader :core_type

    def initialize(core_type)
      @core_type = core_type
    end

    def found
      PromiseChain.new(self)
    end
  end

  class PromiseChain
    attr_reader :valid_methods_chain

    def initialize(owner)
      @valid_methods_chain = []
      @owner = owner
    end

    def method_missing(method_name, *args)
      # TODO: validate?
      new_method = [method_name] + args
      @valid_methods_chain << new_method
      self
    end
  end

  class ExpressionTemplate
    attr_reader :expr_provider, :template, :input

    def initialize(expr_provider, template, input)
      _ = "#{template}" % input
      @expr_provider = expr_provider
      @template = template
      @input = input
    end
  end

end