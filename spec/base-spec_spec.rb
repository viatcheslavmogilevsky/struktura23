require 'spec_helper'

class AwsAmiDataRootSimple < Struktura23::BaseSpec
  add_provider :opentofu, :aws, source: "hashicorp/aws", version: ">= 5.46.0"
  add_query_provider :aws, :core_sdk_query_provider


  has_one_data :aws_ami do |aa|
    aa.where most_recent: true, owners: ["amazon"], name_regex: "amazon-eks-arm64-node-1.27-v*"
  end
end

describe AwsAmiDataRootSimple do
  it 'generates some opentofu' do
    expect(AwsAmiDataRootSimple.to_opentofu).to be_a(Hash)
  end
end