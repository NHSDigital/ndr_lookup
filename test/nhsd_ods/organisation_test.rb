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

      def test_should_raise_error_if_not_valid_find_method
        url  = ODS_ENDPOINT + 'organisations'
        file = File.new(RESPONSES_DIR + '/nhsd_ods/organisation_all_not_acceptable_response.txt')
        stub_request(:get, url).to_return(file)

        assert_raises(ActiveResource::ClientError) do
          NdrLookup::NhsdOds::Organisation.all
        end
      end
    end
  end
end
