require 'active_support'
require 'active_resource'
require_relative 'client'

module NdrLookup
  module Fhir
    module Odt
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
            logger.info("Organization not found: #{e.message}")
            nil
          end

          # ActiveRecord subs .all in to /all which then becomes like finding the id 'all'
          # so we have to explicitly block this if we want it to not be a thing.
          def all
            raise NotImplementedError, 'Use search method instead of all'
          end

          # Searches for organizations matching the provided parameters
          # @return [Array<Organisation>] Matching organizations
          def search(params = {})
            response = Client.search(params)
            return [] unless response['entry']

            response['entry'].map { |entry| new(entry['resource']) }
          rescue Client::ApiError => e
            logger.info("Organization search failed: #{e.message}")
            []
          end

          private

          def logger
            @logger ||= if defined?(Rails) && Rails.respond_to?(:logger)
                          Rails.logger
                        else
                          Logger.new($stdout)
                        end
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
