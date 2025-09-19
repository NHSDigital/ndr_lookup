require_relative '../base'

module NdrLookup
  module Fhir
    module Odt
      # Client for interacting with the NHS Digital FHIR API
      # See https://digital.nhs.uk/developer/api-catalogue/organisation-data-terminology
      class Client < Base
        FHIR_ODT_ENDPOINT = 'https://api.service.nhs.uk/organisation-data-terminology-api/fhir'.freeze

        class << self
          # Wrapped in method to enable stubbing in tests (constants are hard to stub)
          def endpoint
            FHIR_ODT_ENDPOINT
          end
        end
      end
    end
  end
end
