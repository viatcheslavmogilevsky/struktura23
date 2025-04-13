module Struktura23
  class ModuleSpec
    def self.module_itself
      raise "Root node is already specified" if !!@root
      @root = Node::Base.new(nil, Connection::Plural.new(nil))
    end

    def self.nodes
      @root.all_connected_nodes
    end

    # Stub
    def self.hcl_blocks
      []
    end

    def self.init_config
      @config ||= {}
      @config[:required_providers] ||= {}
      @config
    end

    def self.require_provider(_, name, requirement_config)
      config = init_config
      config[name] = requirement_config
      StubTools::Chain.new(config[name])
    end

    def self.render
      {}
    end

    # IAMHERE:
    # Internal structure -> Blocks/experessions instances -> opentofu string

    # def self.render_tf
    #   {
    #     "required_versions.tf" => <<~EOF
    #       terraform {
    #         required_version = ">= 1.8.2"

    #         required_providers {
    #           aws = {
    #             source  = "hashicorp/aws"
    #             version = ">= 5.68.0"
    #           }
    #           tls = {
    #             source  = "hashicorp/tls"
    #             version = ">= 4.0.6"
    #           }
    #         }
    #       }
    #     EOF
    #   }
    # end

    # def self.render_required_providers
    #   required_providers = init_config[:required_providers]
    #   result = ""

    #   return result if required_providers.empty?
    #   required_providers.each do |k, v|

    #     result += <<-EOF
    #           #{k} = {

    #           }
    #     EOF
    #   end

    #   <<-EOF
    #         required_providers {
    #           #{result}
    #         }
    #   EOF
    # end
  end
end
