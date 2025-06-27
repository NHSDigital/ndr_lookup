require 'test_helper'
require 'ndr_lookup/fhir/odt/organisation'

module NdrLookup
  module Fhir
    module Odt
      # The orgaisation class tests
      class OrganisationTest < Minitest::Test
        def test_organisation_should_have_model_like_behaviour
          url  = ODT_ENDPOINT + '/Organization/X26'
          file = File.new(RESPONSES_DIR + '/fhir/organisation_find_success_response.txt')
          stub_request(:get, url).to_return(file)
          org = NdrLookup::Fhir::Odt::Organisation.find('X26')

          assert_equal org.name, 'NHS ENGLAND - X26'
        end

        def test_should_raise_error_if_not_valid_find_method
          url  = ODT_ENDPOINT + '/Organization/all'
          file = File.new(RESPONSES_DIR + '/fhir/organisation_all_not_acceptable_response.txt')
          stub_request(:get, url).to_return(file)
          assert_raises do
            NdrLookup::Fhir::Odt::Organisation.all
          end
        end
      end
    end
  end
end
