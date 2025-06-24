require 'test_helper'
require 'active_support/core_ext/time'
require 'ndr_lookup/fhir/ods/client'

module NdrLookup
  module Fhir
    # TODO
    class BaseTest < Minitest::Test
      def test_should_return_valid_search_ods
        url  = 'https://api.service.nhs.uk/organisation-data-terminology-api/fhir/Organization?Name=Moorfields'
        file = File.new(RESPONSES_DIR + '/fhir/search_success_response.txt')
        stub_request(:get, url).to_return(file)
        response = TestClient.search('Organization', Name: 'Moorfields')

        assert_kind_of(Hash, response)
      end
      # class TestClient < Base
      #   def endpoint
      #     'test_endpoint/fhir'
      #   end
      # end
      
      # def test_find_response
      #   TestClient.new
      # end
      #
      # def test_find_resource_not_found
      # end
      #
      # def test_find_invalid_response
      # end
      #
      # def test_find_api_error
      # end
      
      # def test_should_return_valid_sync_from_file
      #   TestClient.new
      #
      #   url  = ODS_ENDPOINT + "sync?LastChangeDate=#{Date.current}"
      #   file = File.new(RESPONSES_DIR + '/nhsd_ods/sync_success_response.txt')
      #   stub_request(:get, url).to_return(file)
      #   response = NdrLookup::NhsdOds::Client.sync(Date.current)
      #
      #   assert_kind_of(Array, response)
      # end
      #
      # def test_sync_should_raise_error_on_wrong_date_type
      #   assert_raises(ArgumentError) do
      #     NdrLookup::NhsdOds::Client.sync('nhs')
      #   end
      # end
      #
      # def test_should_return_valid_search
      #   url  = ODS_ENDPOINT + 'organisations?Name=nhs'
      #   file = File.new(RESPONSES_DIR + '/nhsd_ods/search_success_response.txt')
      #   stub_request(:get, url).to_return(file)
      #   response = NdrLookup::NhsdOds::Client.search(Name: 'nhs')
      #
      #   assert_kind_of(Array, response)
      # end
      #
      # def test_search_should_raise_error_on_wrong_param_names
      #   url  = ODS_ENDPOINT + 'organisations?wrong_param=nhs'
      #   file = File.new(RESPONSES_DIR + '/nhsd_ods/search_not_acceptable_response.txt')
      #   stub_request(:get, url).to_return(file)
      #
      #   assert_raises do
      #     NdrLookup::NhsdOds::Client.search(wrong_param: 'nhs')
      #   end
      # end
    end

    # TODO: use a test class
    class TestClient < Fhir::Base
      class << self
        def endpoint
          'https://api.service.nhs.uk/organisation-data-terminology-api/fhir'
        end
      end
    end
  end
end
