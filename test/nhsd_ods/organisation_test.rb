require 'test_helper'
require 'ndr_lookup/nhsd_ods/organisation'

module NdrLookup
  module NhsdOds
    # The orgaisation class tests
    class OrganisationTest < Minitest::Test
      def test_organisation_should_have_model_like_behaviour
        url  = ODS_ENDPOINT + 'organisations/X26'
        file = File.new(RESPONSES_DIR + '/nhsd_ods/organisation_find_success_response.txt')
        stub_request(:get, url).to_return(file)
        org = NdrLookup::NhsdOds::Organisation.find('X26')

        assert_equal org.name, 'NHS DIGITAL'
      end
    end
  end
end
