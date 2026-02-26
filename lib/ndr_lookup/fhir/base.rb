require 'active_resource'
require 'active_support'
require 'active_support/core_ext'

module NdrLookup
  module Fhir
    # Client for interacting with the NHS Digital FHIR API
    class Base < ActiveResource::Base
      # Specific error classes for different API failure modes
      class ApiError < StandardError; end
      class ResourceNotFound < ApiError; end
      class InvalidResponse < ApiError; end
      class InvalidURIError < ApiError; end
      class UnauthorizedError < ApiError; end

      class << self
        attr_writer :additional_headers

        def additional_headers
          @additional_headers ||= {}
        end

        def sync
          raise 'Must be defined in subclasses!'
        end

        # Finds a specific FHIR resource by type and ID
        # @return [Hash] Parsed FHIR resource
        def find(resource_type, id)
          with_error_handling("#{resource_type} with ID '#{id}' not found") do
            response = connection.get("#{endpoint}/#{resource_type}/#{id}", headers)
            JSON.parse(response.body)
          end
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
          with_error_handling do
            url = construct_url(endpoint, resource_type, params)
            response = connection.get(url, headers)
            payload = JSON.parse(response.body)
            raise_unless_response_success(response, payload)
            payload
          end
        end

        private

        # Wraps API calls with consistent error handling, converting external exceptions
        # (ActiveResource, JSON, URI) into our own error classes.
        def with_error_handling(not_found_message = nil)
          yield
        rescue ActiveResource::ResourceNotFound
          raise ResourceNotFound, not_found_message || 'Resource not found'
        rescue ActiveResource::UnauthorizedAccess
          raise UnauthorizedError, 'Authentication failed'
        rescue JSON::ParserError
          raise InvalidResponse, 'Invalid JSON response from server'
        rescue URI::InvalidURIError => e
          raise InvalidURIError, "Invalid ID format: #{e.message}"
        rescue StandardError => e
          raise ApiError, "Unexpected error: #{e.message}"
        end

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
