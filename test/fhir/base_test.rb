require 'test_helper'
require 'active_support/core_ext/time'

module NdrLookup
  module Fhir
    # test shared functionality
    class BaseTest < Minitest::Test
      def test_find_resource
        url  = "#{ODT_ENDPOINT}/Organization/X26"
        file = File.new("#{RESPONSES_DIR}/fhir/organisation_find_success_response.txt")
        stub_request(:get, url).to_return(file)
        response = TestClient.find('Organization', 'X26')

        assert_kind_of(Hash, response)
      end

      def test_should_raise_error_if_resource_not_found
        url  = "#{ODT_ENDPOINT}/Organization/X9999"
        file = File.new("#{RESPONSES_DIR}/fhir/metadata_not_found_response.txt")
        stub_request(:get, url).to_return(file)

        assert_raises(Fhir::Base::ResourceNotFound) do
          TestClient.find('Organization', 'X9999')
        end
      end

      def test_should_raise_error_if_invalid_json_response_received
        stub_request(:get, 'https://api.service.nhs.uk/organisation-data-terminology-api/fhir/Organization/X26').
          with(
            headers: {
        	     'Accept' => 'application/fhir+json',
        	     'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        	     'Content-Type' => 'application/fhir+json',
        	     'User-Agent' => 'Ruby'
            }
          ).
          to_return(status: 200, body: '', headers: {})

        assert_raises(Fhir::Base::InvalidResponse) do
          TestClient.find('Organization', 'X26')
        end
      end

      def test_should_raise_any_other_error
        # TODO: what path would get here?
      end
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
