require 'active_support'
require 'active_resource'
require_relative 'client'

module NdrLookup
  module Fhir
    module Ods
      # Represents an Organization resource from the NHS Digital FHIR API
      class Organisation < ActiveResource::Base
        self.include_format_in_path = false
        self.site = Client::FHIR_ODT_ENDPOINT
        self.collection_name = 'Organization'

        class << self
          # Finds a specific organization by ID
          # @return [Organisation] The found organization
          def find(id)
            response = Client.find('Organization', id)
            new(response)
          rescue Client::ResourceNotFound => e
            Rails.logger.error("Organization not found: #{e.message}")
            nil
          end

          # Searches for organizations matching the provided parameters
          # @return [Array<Organisation>] Matching organizations
          def search(params = {})
            response = Client.search(params)
            return [] unless response['entry']

            response['entry'].map { |entry| new(entry['resource']) }
          rescue Client::ApiError => e
            Rails.logger.error("Organization search failed: #{e.message}")
            []
          end
        end

        # Initializes a new Organization with downcased attributes
        def initialize(attributes = {}, persisted = false)
          attributes.deep_transform_keys!(&:downcase) if attributes.is_a?(Hash)
          super
        end

        private

        # Prevents Date constants from raising errors
        def const_valid?(*const_args)
          return false if const_args.first == 'Date'

          super
        end
      end
    end
  end
end
