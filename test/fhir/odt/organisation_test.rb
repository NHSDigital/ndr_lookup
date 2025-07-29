require 'test_helper'
require 'ndr_lookup/fhir/odt/organisation'

module NdrLookup
  module Fhir
    module Odt
      # The orgaisation class tests
      class OrganisationTest < Minitest::Test
        def test_organisation_should_have_model_like_behaviour
          url  = "#{ODT_ENDPOINT}/Organization/X26"
          file = File.new("#{RESPONSES_DIR}/fhir/organisation_find_success_response.txt")
          stub_request(:get, url).to_return(file)
          org = NdrLookup::Fhir::Odt::Organisation.find('X26')

          assert_equal org.name, 'NHS ENGLAND - X26'
        end

        # ActiveResource .all hits NotImplementedError
        def test_should_raise_error_if_not_valid_find_method
          assert_raises(NotImplementedError) do
            NdrLookup::Fhir::Odt::Organisation.all
          end
        end

        def test_find_returns_organisation_instance_from_api_response
          url = "#{ODT_ENDPOINT}/Organization/X26"
          file = File.new("#{RESPONSES_DIR}/fhir/organisation_find_success_response.txt")
          stub_request(:get, url).to_return(file)

          org = Organisation.find('X26')

          assert_instance_of Organisation, org
          assert_equal 'X26', org.id
          assert_equal 'NHS ENGLAND - X26', org.name
        end

        def test_find_handles_resource_not_found_gracefully
          url = "#{ODT_ENDPOINT}/Organization/MISSING"
          file = File.new("#{RESPONSES_DIR}/fhir/metadata_not_found_response.txt")
          stub_request(:get, url).to_return(file)

          org = Organisation.find('MISSING') # This will display on stdout as info because of change to Logger.

          assert_nil org
        end

        def test_sync_returns_empty_array_when_no_results
          url = "#{ODT_ENDPOINT}/Organization?_lastUpdated=gt2025-06-01"
          file = File.new("#{RESPONSES_DIR}/fhir/organisation_sync_empty_response.txt")
          stub_request(:get, url).to_return(file)

          orgs = Organisation.sync('2025-06-01')

          assert_instance_of Array, orgs
          assert_empty orgs
        end

        def test_sync_formats_date_object_correctly
          date = Date.new(2025, 6, 1)
          url = "#{ODT_ENDPOINT}/Organization?_lastUpdated=gt2025-06-01"
          file = File.new("#{RESPONSES_DIR}/fhir/organisation_sync_success_response.txt")
          stub_request(:get, url).to_return(file)

          orgs = Organisation.sync(date)

          assert_instance_of Array, orgs
        end

        def test_sync_handles_api_error_gracefully
          url = "#{ODT_ENDPOINT}/Organization?_lastUpdated=gt2025-06-01"
          stub_request(:get, url).to_return(status: 500, body: 'Server Error')

          orgs = Organisation.sync('2025-06-01')

          assert_equal [], orgs
        end
      end
    end
  end
end
