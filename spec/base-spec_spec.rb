require 'spec_helper'

class AwsAmiDataRootSimple < Struktura23::BaseSpec
  add_provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  add_query_provider :aws, :core_sdk_query_provider


  has_one_data :aws_ami do |aa|
    aa.where most_recent: true, owners: ["amazon"], name_regex: "amazon-eks-arm64-node-1.27-v*"
  end
end

describe AwsAmiDataRootSimple do
  before :each do
    @opentofu = AwsAmiDataRootSimple.to_opentofu
    @data_aws_ami_schema = AwsAmiDataRootSimple.schemas.select do |s|
      s.name == :aws_ami && s.group_name == :data
    end
  end

  it 'generates some opentofu' do
    expect(@opentofu).to be_a(Hash)
  end

  it 'generates variables for aws_ami main' do
    expect(@opentofu["variables"]).to be_a(Hash)
    # TODO: finish (use: https://github.com/rspec/rspec-expectations)
    # expect(@opentofu["variables"].keys.map {|k| }).to be_a(Hash)
  end
end