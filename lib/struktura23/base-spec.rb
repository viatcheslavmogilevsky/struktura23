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
      @schemas ||= [
        OpentofuSchema::Resource.new(:aws_launch_template)
          .with(:name, :computed, :optional, :force_new, conflicts_with: [:name_prefix])
          .with(:name_prefix, :computed, :optional, :force_new, conflicts_with: [:name])
          .with(:ebs_optimized, :optional, :NullableBool)
          .with(:image_id, :optional, :String)
          .with(:instance_type, :optional, :String)
          .with(:key_name, :optional, :String)
          .with(:vpc_security_group_ids, :optional, Set: :String, conflicts_with: [:security_group_names])
          .with(:security_group_names, :optional, Set: :String, conflicts_with: [:vpc_security_group_ids])
          .with(:tag_specifications, :optional, List: OpentofuSchema::Base.new
            .with(:resource_type, :optional)
            .with(:tags, :optional, Map: :String)
          )
          .with(:user_data, :optional, :String),
        OpentofuSchema::Datasource.new(:aws_ami)
          .with_list(
            [
              :architecture,
              :arn,
              :boot_mode,
              :creation_date,
              :deprecation_time,
              :description,
              :hypervisor,
              :image_id,
              :image_location,
              :image_owner_alias,
              :image_type,
              :imds_support,
              :kernel_id,
              :name,
              :owner_id,
              :platform,
              :platform_details,
              :ramdisk_id,
              :root_device_name,
              :root_device_type,
              :root_snapshot_id,
              :sriov_net_support,
              :state,
              :tpm_support,
              :usage_operation,
              :virtualization_type
            ],
            :computed, :String
          )
          .with_list(
            [
              :ena_support,
              :public
            ],
            :computed, :Bool
          )
          .with(:block_device_mappings,
            :computed,
            Set: OpentofuSchema::Base.new(:computed)
              .with(:device_name, :String)
              .with(:ebs, Map: :String)
              .with(:no_device, :String)
              .with(:virtual_name, :String)
          )
          .with(:product_codes,
            :computed,
            Set: OpentofuSchema::Base.new(:computed, :String)
              .with(:product_code_id)
              .with(:product_code_type)
          )
          .with(:state_reason, :computed, Map: :String)
          .with(:tags, :computed, :optional, Map: :String)
          .with(:executable_users, :optional, List: :String)
          .with(:filter,
            :optional,
            Set: OpentofuSchema::Base.new(:required)
              .with(:name, :String)
              .with(:vales, List: :String)
          )
          .with_list(
            [
              :include_deprecated,
              :most_recent
            ],
            :optional, :Bool, default: false
          )
          .with(:name_regex, :optional, :String)
          .with(:owners, :optional, List: {type: :String, min_items: 1}),
        OpentofuSchema::Resource.new(:aws_eks_cluster)
          .with(:id, :computed)
          .with(:name)
          .with(:tag, :optional),
        OpentofuSchema::Datasource.new(:tls_certificate)
          .with(:id, :computed)
          .with(:name)
          .with(:tag, :optional),
        OpentofuSchema::Resource.new(:aws_iam_openid_connect_provider)
          .with(:id, :computed)
          .with(:name)
          .with(:tag, :optional),
        OpentofuSchema::Resource.new(:aws_eks_addon)
          .with(:id, :computed)
          .with(:name)
          .with(:tag, :optional),
        OpentofuSchema::Resource.new(:aws_eks_node_group)
          .with(:id, :computed)
          .with(:name)
          .with(:tag, :optional)
      ]
    end
  end

  module OpentofuSchema
    class Base
      attr_reader :definition

      def initialize(*flags)
        @flags = flags || []
        @definition = {}
      end

      def with(name, *args)
        @definition[name] = (args + @flags).uniq.inject({}) do |res, arg|
          if arg.is_a?(Hash)
            res.merge(arg)
          elsif arg.is_a?(Symbol)
            res.merge(arg => true)
          end
        end
        self
      end

      def with_list(names, *flags)
        names.each do |n|
          with(n, *flags)
        end
        self
      end
    end

    class NamedSchema < Base
      attr_reader :name, :group_name

      def initialize(name)
        @name = name
        super()
      end

      def input_definition
        @definition.select {|k,v| v[:optional] || v[:required]}
      end

      # this is example of how to customize inspect for all instances of all class' descendants
      # TODO: what about modes of printing staff
      class << self
        def suppress_definition
          define_method(:inspect) do
            "<#{self.class.to_s}>"
          end
        end
      end
    end

    class Resource < NamedSchema
      def initialize(*args)
        super(*args)
        @group_name = :resource
      end
    end

    class Datasource < NamedSchema
      def initialize(*args)
        super(*args)
        @group_name = :data
      end
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

    class Context
      def initialize(enforced_node, enforced_attr)
        @enforced_node = enforced_node
        @enforced_attr = enforced_attr
      end

      def current_var
        # TODO: it is stub
        # "#{@enforced_node.class}.#{@enforced_attr}"
        PromiseChain.new(@enforced_node).send(@enforced_attr)
      end

      def current
        # TODO: it is stub
        PromiseChain.new(@enforced_node)
      end

      def expr(template, input={})
        ExpressionTemplate.new(template, input)
      end
    end
  end

  module Node
    class Base
      include Enforceable

      attr_reader :schema, :label, :wrapped_by, :input_enabled, :output_enabled
      attr_writer :schema_provider

      def initialize(schema, label=:main)
        @schema = schema
        @label = label
        @search_enabled = true
        @search_query = {}
        @input_enabled = true
        @output_enabled = true
        @extra_input_vars = {}
        @input_prefix = nil
      end


      def disable_input
        @input_enabled = false
      end

      def disable_output
        @output_enabled = false
      end

      def wrap_by(wrapper)
        if wrapper.core.schema != @schema
          raise "Wrapper of a #{wrapper.core.schema} cannot be used to wrap a #{@schema}"
        end
        @wrapped_by = wrapper
      end

      def wrap
        @wrapped_by = Wrapper.new(core_schema: @schema, schema_provider: @schema_provider)
        yield(@wrapped_by)
      end

      def where(predicate)
        if predicate == false
          @search_enabled = false
        else
          @search_query = predicate
        end
      end

      def add_var(vars_spec)
        @extra_input_vars.merge!(vars_spec)
      end

      def var
        # TODO: it is stub
        {}
      end

      def input
        return {} if !@input_enabled
        @schema.input_definition.select {|k,_| !enforcers[k]}
      end

      def output
        return {} if !@output_enabled
        @schema.definition
      end

      def datasource?
        schema.group_name == :data
      end

      def wrapper_content
        if !!@wrapped_by
          @wrapper_content ||= @wrapped_by.to_opentofu
        else
          {}
        end
      end

      def outside_variables
        vars = {}
        input.each_pair do |k,v|
          vars["#{schema.name}_#{label}_#{k}"] = v
        end
        wrapper_content["variables"]&.each_pair do |k,v|
          vars["#{schema.name}_#{label}_#{k}"] = v
        end
        vars
      end

      def outside_outputs
        outs = {}
        output.keys.each do |k|
          outs["#{schema.name}_#{label}_#{k}"] = {
            :value => if !wrapper_content.empty?
              "${module.#{schema.name}_#{label}.#{k}}"
            else
              data_prefix = datasource? ? "data." : ""
              "${#{data_prefix}#{schema.name}.#{label}.#{k}}"
            end
          }
        end
        wrapper_content["output"]&.keys&.each do |k|
          outs["#{schema.name}_#{label}_#{k}"] = {
            :value => "${module.#{schema.name}_#{label}.#{k}}"
          }
        end
        outs
      end

      def outside_block
        out_blk = {}
        input.keys.each do |k|
          key = if !wrapper_content.empty? and [:source, :version].include?(k)
            "#{schema.name}_#{k}"
          else
            k
          end
          out_blk[key] = "var.#{schema.name}_#{label}_#{k}"
        end
        enforcers.each_pair do |k, v|
          key = if !wrapper_content.empty? and [:source, :version].include?(k)
            "#{schema.name}_#{k}"
          else
            k
          end
          out_blk[key] = v
        end
        wrapper_content["variables"]&.keys&.each do |k|
          out_blk[k] = "var.#{schema.name}_#{label}_#{k}"
        end
        out_blk
      end

      # TODO: how to add "flag to enabled" to it - some small refactoring needed
      def to_opentofu
        resources = {}
        datasources = {}
        modules = {}

        # tf block: begin
        if !wrapper_content.empty?
          core_content = {}
          core_block = {}
          core_variables = {}
          core_output = {}

          @schema.input_definition.each do |k, v|
            var_name = if [:source, :version].include?(k)
              "#{schema.name}_#{k}"
            else
              k
            end

            core_block[k] = "var.#{var_name}"
            core_variables[var_name] = v
          end

          output.keys.each do |k|
            data_prefix = datasource? ? "data." : ""
            core_output[k] = {
              :value => "${#{data_prefix}#{schema.name}.core.#{k}}"
            }
          end

          core_block.merge!(@wrapped_by.core&.enforcers || {})
          core_content[datasource? ? "data" : "resource"] = {
            "#{schema.name}" => {
              "core" => core_block
            }
          }

          modules["#{schema.name}_#{label}"] = outside_block.merge({
            "contents" => wrapper_content.merge(core_content) do |_, by_kind, one_kind|
              by_kind.merge(one_kind) {|_, by_schema, one_schema|  by_schema.merge(one_schema)}
            end
            .merge({"variables" => core_variables}) {|_, w_vars, n_vars| w_vars.merge(n_vars)}
            .merge({"output" => core_output}) {|_, w_output, n_output| w_output.merge(n_output)}
          })
        elsif datasource?
          datasources[schema.name] = {label => outside_block}
        else
          resources[schema.name] = {label => outside_block}
        end
        # tf block: end


        {
          "variables" => outside_variables,
          "resource" => resources,
          "data" => datasources,
          "output" => outside_outputs,
          "module" => modules
        }
      end
    end

    class Collection < Base
      def initialize(*args)
        super(*args)
        @identify_by = nil
      end

      def identify
        promise_chain = PromiseChain.new(self)
        yield(promise_chain)
        @identify_by = promise_chain
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

      def var_name_to_enable
        "enable_#{@schema.name}_#{@label}"
      end

      def flag_to_enable
        # TODO: it is stub
        "var.#{var_name_to_enable}"
      end
    end
  end

  module Owner
    def core
    end

    def schema_provider
    end

    def schemas
      schema_provider&.schemas || []
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

      nodes.merge!({node.schema.name => {node.label => node}}) do |_, val1, val2|
        val1.merge val2
      end
    end

    def iterate_nodes
      nodes.each_pair do |schema_name, labels|
        labels.each_pair do |label, node|
          yield(node)
        end
      end
    end

    def method_missing(method_name, *args, &block)
      if method_name =~ /^has_(many|one|optional)(_data)?$/
        is_data = !!$2
        schema = schemas.find do |s|
          ((is_data && s.group_name == :data) || (!is_data && s.group_name == :resource)) && s.name == args[0]
        end

        raise "Cannot find schema for #{is_data ? 'data' : 'resource'} #{args[0]} from #{schemas.map(&:name)}" unless schema

        node = case $1
        when "many"
          Node::Collection.new(schema, *args[1..-1])
        when "one"
          Node::Singular.new(schema, *args[1..-1])
        when "optional"
          Node::Optional.new(schema, *args[1..-1])
        end
        node.schema_provider = schema_provider
        has!(node, &block)
        node
      else
        super(method_name, *args, &block)
      end
    end

    def to_opentofu
      variables = {}
      output = {}
      resource = {}
      data = {}
      modules = {}

      iterate_nodes do |node|
        node_opentofu = node.to_opentofu
        variables.merge!(node_opentofu["variables"] || {})
        output.merge!(node_opentofu["output"] || {})

        modules.merge!(node_opentofu["module"] || {}) do |_, val1, val2|
          val1.merge(val2)
        end
        resource.merge!(node_opentofu["resource"] || {}) do |_, val1, val2|
          val1.merge(val2)
        end
        data.merge!(node_opentofu["data"] || {}) do |_, val1, val2|
          val1.merge(val2)
        end
      end
      {
        "//": "This is not ready yet!",
        "variables" => variables,
        "resource" => resource,
        "data" => data,
        "output" => output,
        "module" => modules,
        # TODO: to be continued
        "provider" => {},
        "locals" => {},
        "terraform" => {}
      }
    end

    def has_wrapper(wrapper_key, options={})
      schema = if options[:of]
        schemas.find {|s| s.group_name == :resource && s.name == options[:of]}
      elsif options[:of_data]
        schemas.find {|s| s.group_name == :data && s.name == options[:of_data]}
      end

      named_wrappers[wrapper_key] = wrapper = Wrapper.new(id: wrapper_key, core_schema: schema, schema_provider: schema_provider)
      yield(wrapper, wrapper.core)
      wrapper
    end

    def named_wrappers
      @named_wrappers ||= {}
    end
  end

  class BaseSpec
    extend Owner
    extend ProviderOwner

    def self.schema_provider
      self
    end
  end

  class Wrapper
    include Owner

    attr_reader :core, :id, :schema_provider

    def initialize(id: nil, core_schema:, schema_provider:)
      @core = WrapperCore.new(core_schema)
      @id = id
      @schema_provider = schema_provider
    end
  end

  # TODO: this should be united with Node::Base
  class WrapperCore
    include Enforceable

    attr_reader :schema

    def initialize(schema)
      @schema = schema
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
    attr_reader :template, :input

    def initialize(template, input)
      _ = "#{template}" % input
      @template = template
      @input = input
    end
  end
end