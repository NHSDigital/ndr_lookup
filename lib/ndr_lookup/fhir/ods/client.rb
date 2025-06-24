require_relative '../base'

module NdrLookup
  module Fhir
    module Ods
      # Client for interacting with the NHS Digital FHIR API
      class Client < Base
        FHIR_ODT_ENDPOINT = 'https://api.service.nhs.uk/organisation-data-terminology-api/fhir'.freeze

        class << self
          def endpoint
            FHIR_ODT_ENDPOINT
          end
        end
      end
    end
  end
end
