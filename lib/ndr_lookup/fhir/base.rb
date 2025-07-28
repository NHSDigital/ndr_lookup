require 'active_resource'
require 'active_support'
require 'active_support/core_ext'

module NdrLookup
  module Fhir
    # Client for interacting with the NHS Digital FHIR API
    class Base < ActiveResource::Base
      # ENDPOINT = 'https://api.service.nhs.uk/organisation-data-terminology-api/fhir'.freeze

      class ApiError < StandardError; end
      class ResourceNotFound < ApiError; end
      class InvalidResponse < ApiError; end

      class << self
        attr_writer :additional_headers

        def additional_headers
          @additional_headers ||= {}
        end

        # Not implemented yet - will handle syncing data when this is available
        # TODO: This has become 'search'. We'd have to rewrite sync functionality via search
        def sync(date)
          raise NotImplementedError
        end

        # Finds a specific FHIR resource by type and ID
        # @return [Hash] Parsed FHIR resource
        def find(resource_type, id)
        response = connection.get(
          "#{endpoint}/#{resource_type}/#{id}",
          headers
        )
        JSON.parse(response.body)
        rescue ActiveResource::ResourceNotFound
          raise ResourceNotFound, "#{resource_type} with ID '#{id}' not found"
        rescue JSON::ParserError
          raise InvalidResponse, 'Invalid JSON response from server'
        rescue StandardError => e
          raise ApiError, "Unexpected error: #{e.message}"          
        end

        def endpoint
          raise 'Must be defined in subclasses!'
        end

        # Searches for FHIR resources using the provided parameters
        # @param resource_type [String] The type of FHIR resource to search for
        # (e.g. 'Organization', 'OrganizationAffiliation')
        # @param params [Hash] Search parameters specific to the resource type
        # @return [Hash] FHIR Bundle containing search results
        # @example Search for organizations
        #   Client.search('Organization', lastUpdated: 'gt2024-01-01')
        # @example Search for relationships
        #   Client.search('OrganizationAffiliation', organization: 'RHAGX')
        def search(resource_type, params = {})
          url = construct_url(endpoint, resource_type, params)

          # Make the request
          response = connection.get(url, headers)

          # Process response
          payload = JSON.parse(response.body)
          raise_unless_response_success(response, payload)

          payload
        rescue JSON::ParserError
          raise InvalidResponse, 'Invalid JSON response from server'
        rescue StandardError => e
          raise ApiError, "Search failed: #{e.message}"
        end

        private

        def construct_url(endpoint, resource_type, params = {})
          url = "#{endpoint}/#{resource_type}"

          # Add query parameters if any exist
          if params.any?
            # Convert params to proper query string format
            query_string = params.map do |key, value|
              "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
            end.join('&')

            url = "#{url}?#{query_string}"
          end

          url
        end

        # @return [ActiveResource::Connection] Configured connection instance
        def connection
          @connection ||= ActiveResource::Connection.new(endpoint)
        end

        # @return [Hash] FHIR API required headers
        def headers
          {
            'Accept' => 'application/fhir+json',
            'Content-Type' => 'application/fhir+json'
          }.merge(additional_headers)
        end

        # Raises an error unless response is successful
        def raise_unless_response_success(response, payload)
          return if response.code == '200'

          error_message = payload['errorText'] || 'Unknown error'
          raise ApiError, "#{payload['errorCode']} - #{error_message}"
        end
      end
    end
  end
end
